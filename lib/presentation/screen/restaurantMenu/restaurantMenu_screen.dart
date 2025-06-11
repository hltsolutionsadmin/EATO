import 'dart:async';
import 'package:eato/components/custom_topbar.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_state.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_cubit.dart';
import 'package:eato/presentation/screen/widgets/restaurantMenu/searchBar.dart';
import 'package:eato/presentation/screen/widgets/restaurantMenu/bottomSheet.dart';
import 'package:eato/presentation/screen/widgets/restaurantMenu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/presentation/screen/cart/cart_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eato/presentation/cubit/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_cubit.dart';
import 'package:eato/presentation/cubit/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_state.dart';
import 'package:eato/data/model/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_model.dart';

class RestaurantMenuScreen extends StatefulWidget {
  final String restaurantName, restaurantId;
  const RestaurantMenuScreen(
      {super.key, required this.restaurantName, required this.restaurantId});

  @override
  _RestaurantMenuScreenState createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, int> cart = {};
  int totalItems = 0, page = 0, size = 10;
  PersistentBottomSheetController? _bottomSheetController;
  bool isBottomSheetVisible = false;
  String searchText = '', filterType = 'All';
  List<Content> selectedItems = [], menuItems = [];
  Timer? _debounce;
  bool _isMenuLoaded = false;
  bool _isCartLoaded = false;

  @override
  void initState() {
    super.initState();
    print('initState: Loading menu for restaurantId = ${widget.restaurantId}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetMenuByRestaurantIdCubit>().fetchMenu({
        'restaurantId': widget.restaurantId,
        'search': searchText,
        'page': page,
        'size': size,
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        _loadCart();
      });
    });
  }

  Future<void> _loadCart() async {
    final cartState = context.read<GetCartCubit>().state;
    if (cartState is GetCartLoaded) {
      _processCartData(cartState);
    } else {
      await Future.delayed(const Duration(milliseconds: 100));
      final newCartState = context.read<GetCartCubit>().state;
      if (newCartState is GetCartLoaded) {
        _processCartData(newCartState);
      }
    }
  }

  void _processCartData(GetCartLoaded state) {
    if (state.cart.businessId.toString() != widget.restaurantId) return;
    if (!_isMenuLoaded) return;

    int itemCounter = 0;
    Map<String, int> updatedCart = {};
    List<Content> updatedSelectedItems = [];

    for (var cartItem in state.cart.cartItems) {
      final menuItem = menuItems.firstWhere(
        (item) => item.id == cartItem.productId,
        orElse: () => Content(
          id: 0,
          name: '',
          shortCode: '',
          ignoreTax: false,
          discount: true,
          description: '',
          price: 0,
          available: false,
          shopifyProductId: '',
          shopifyVariantId: '',
          businessId: 0,
          categoryId: 0,
          media: [],
          attributes: [],
        ),
      );

      if (menuItem.id != 0) {
        final qty = cartItem.quantity ?? 0;
        updatedCart[menuItem.name ?? ""] = qty;
        updatedSelectedItems.add(menuItem);
        itemCounter += qty;
      }
    }

    if (!mounted) return;
    setState(() {
      cart = updatedCart;
      selectedItems = updatedSelectedItems;
      totalItems = itemCounter;
      _isCartLoaded = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (totalItems > 0 && !isBottomSheetVisible) {
        showPersistentCart();
      } else if (totalItems == 0 && isBottomSheetVisible) {
        _bottomSheetController?.close();
      }
    });
  }

  Future<void> _loadMenu() async {
    print('Loading menu with search: "$searchText", filterType: "$filterType"');
    await context.read<GetMenuByRestaurantIdCubit>().fetchMenu({
      'restaurantId': widget.restaurantId,
      'search': searchText,
      'page': page,
      'size': size,
    });
  }

  void update_Cart(Content item, int qty) {
    var updatedCart = Map<String, int>.from(cart);
    var updatedSelectedItems = List<Content>.from(selectedItems);

    if (qty == 0) {
      updatedCart.remove(item.name);
      updatedSelectedItems.removeWhere((i) => i.name == item.name);
    } else {
      updatedCart[item.name ?? ""] = qty;
      if (!updatedSelectedItems.any((i) => i.name == item.name)) {
        updatedSelectedItems.add(item);
      }
    }

    int newTotalItems = updatedCart.values.fold(0, (sum, qty) => sum + qty);

    if (!mounted) return;
    setState(() {
      cart = updatedCart;
      selectedItems = updatedSelectedItems;
      totalItems = newTotalItems;
      final idx = menuItems.indexWhere((m) => m.name == item.name);
      if (idx != -1) menuItems[idx] = item;
    });

    final payload = {
      "productId": item.id,
      "quantity": qty,
      "price": item.price ?? 0
    };
    context.read<ProductsAddToCartCubit>().addToCart([payload]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (totalItems > 0 && !isBottomSheetVisible) {
        showPersistentCart();
      } else if (totalItems == 0 && isBottomSheetVisible) {
        _bottomSheetController?.close();
      } else if (isBottomSheetVisible) {
        _bottomSheetController?.setState?.call(() {});
      }
    });
  }

  void showPersistentCart() {
    _bottomSheetController =
        _scaffoldKey.currentState!.showBottomSheet((context) {
      return RestaurantCartBottomSheet(
        totalItems: totalItems,
        onViewCartPressed: () async {
          _bottomSheetController?.close();
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CartScreen(
                cartItems: selectedItems
                    .map((item) => {
                          'productId': item.id,
                          'quantity': cart[item.name] ?? 0,
                          'price': item.price,
                          'name': item.name,
                          'description': item.description,
                          'categoryName': item.attributes
                              .firstWhere(
                                (a) => a.attributeName?.toLowerCase() == 'type',
                                orElse: () => Attribute(
                                    id: 0,
                                    attributeName: '',
                                    attributeValue: ''),
                              )
                              .attributeValue,
                          'media': item.media,
                        })
                    .toList(),
                onBottomSheetVisibilityChanged: _onBottomSheetVisibilityChanged,
              ),
            ),
          );
          if (!mounted) return;
          if (result != null && result is Map<String, dynamic>) {
            final updatedCart = result['updatedCart'] as Map<String, int>?;
            final updatedCartLength = result['cartItemsLength'] ?? 0;
            if (updatedCart != null) {
              setState(() {
                cart = Map<String, int>.from(updatedCart);
                totalItems = updatedCartLength;
                selectedItems = selectedItems
                    .where((item) =>
                        cart.containsKey(item.name) && cart[item.name]! > 0)
                    .toList();
                for (var item in menuItems) {
                  final quantity = cart[item.name] ?? 0;
                  if (quantity != 0) update_Cart(item, quantity);
                }
              });
              _onBottomSheetVisibilityChanged(cart.isNotEmpty);
              _loadMenu();
            }
          }
        },
      );
    });

    _bottomSheetController!.closed.then((_) {
      if (!mounted) return;
      setState(() {
        isBottomSheetVisible = false;
      });
    });

    setState(() {
      isBottomSheetVisible = true;
    });
  }

  void _onBottomSheetVisibilityChanged(bool visible) {
    if (!mounted) return;
    if (visible && !isBottomSheetVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showPersistentCart();
      });
    }
    setState(() {
      isBottomSheetVisible = visible;
    });
    if (!visible) _bottomSheetController?.close();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        searchText = value;
      });
      _loadMenu();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _bottomSheetController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: widget.restaurantName,
        onBackPressed: () {
          Navigator.pop(context);
          if (isBottomSheetVisible) _bottomSheetController?.close();
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.White, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.PrimaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.restaurantName,
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text("Rating: ⭐ 4.5",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.white70)),
                    ],
                  ),
                  const Icon(Icons.restaurant_menu,
                      color: Colors.white, size: 32),
                ],
              ),
            ),
            HomeSearchBar(hintText: "menu", onChanged: _onSearchChanged),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: ['All', 'Veg', 'NonVeg'].map((filter) {
                  final isSelected = filter == filterType;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) {
                        if (!mounted) return;
                        setState(() {
                          filterType = filter;
                        });
                        _loadMenu();
                      },
                      selectedColor: AppColor.PrimaryColor,
                      labelStyle: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocConsumer<GetMenuByRestaurantIdCubit,
                  GetMenuByRestaurantIdState>(
                listener: (context, state) {
                  if (state is GetMenuByRestaurantIdLoaded) {
                    print('Menu Loaded: ${state.model.content.length} items');
                    setState(() {
                      menuItems = state.model.content;
                      _isMenuLoaded = true;
                    });
                    if (!_isCartLoaded) {
                      _loadCart();
                    }
                  } else if (state is GetMenuByRestaurantIdError) {
                    print(
                        'Error loading menu: ${state.message}'); // Add .message in your state class if missing
                  }
                },
                builder: (context, state) {
                  if (state is GetMenuByRestaurantIdLoading) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else if (state is GetMenuByRestaurantIdLoaded) {
                    final filteredItems = menuItems.where((item) {
                      final matchesSearch = item.name
                              ?.toLowerCase()
                              .contains(searchText.toLowerCase()) ??
                          false;
                      final foodType = item.attributes
                          .firstWhere(
                              (a) => a.attributeName?.toLowerCase() == 'type',
                              orElse: () => Attribute(
                                  id: 0, attributeName: '', attributeValue: ''))
                          .attributeValue;
                      final matchesFilter = filterType == 'All' ||
                          (filterType.toLowerCase() == 'veg' &&
                              foodType?.toLowerCase() == 'veg') ||
                          (filterType.toLowerCase() == 'nonveg' &&
                              foodType?.toLowerCase() == 'nonveg');

                      return matchesSearch && matchesFilter;
                    }).toList();

                    if (filteredItems.isEmpty) {
                      return Center(
                        child: Text("No items match your filter.",
                            style: GoogleFonts.poppins(color: Colors.grey)),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final quantity = cart[item.name ?? ""] ?? 0;
                        return MenuItemWidget(
                          item: item,
                          quantity: quantity,
                          onQuantityChanged: (qty) => update_Cart(item, qty),
                        );
                      },
                    );
                  } else if (state is GetMenuByRestaurantIdError) {
                    print("Menu load failed with error");
                    return Center(
                      child: Text("Error Loading Menu",
                          style: GoogleFonts.poppins(color: Colors.red)),
                    );
                  } else {
                    return const Center(child: Text("Initial state"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
