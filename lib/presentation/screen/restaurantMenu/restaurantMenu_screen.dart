import 'dart:async';
import 'package:eato/components/custom_topbar.dart';
import 'package:eato/data/model/cart/getCart/getCart_model.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_state.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_cubit.dart';
import 'package:eato/presentation/screen/authentication/login_screen.dart';
import 'package:eato/presentation/screen/widgets/restaurantMenu/searchBar.dart';
import 'package:eato/presentation/screen/widgets/restaurantMenu/bottomSheet.dart';
import 'package:eato/presentation/screen/widgets/restaurantMenu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/presentation/screen/cart/cart_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eato/data/model/restaurants/guestMenuByRestaurantId/menu_content_model.dart';
import 'package:eato/presentation/cubit/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_cubit.dart';
import 'package:eato/presentation/cubit/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_state.dart';
import 'package:eato/presentation/cubit/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_cubit.dart';
import 'package:eato/presentation/cubit/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_state.dart';

class RestaurantMenuScreen extends StatefulWidget {
  final String restaurantName, restaurantId;
  final bool isGuest;
  const RestaurantMenuScreen({
    super.key,
    required this.restaurantName,
    required this.restaurantId,
    this.isGuest = false,
  });

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

    // ✅ Print isGuest value
    print("RestaurantMenuScreen - isGuest: ${widget.isGuest}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isGuest) {
        context
            .read<GuestMenuByRestaurantIdCubit>()
            .fetchGuestMenuByRestaurantId({
          'restaurantId': int.tryParse(widget.restaurantId) ?? 0,
        });
      } else {
        context.read<GetMenuByRestaurantIdCubit>().fetchMenu({
          'restaurantId': widget.restaurantId,
          'search': searchText,
          'page': page,
          'size': size,
        });
        Future.delayed(const Duration(milliseconds: 300), () {
          _loadCart();
        });
      }
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

    for (var cartItem in state.cart.cartItems as List<CartItems>) {
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
      context.read<GetCartCubit>().fetchCart(context);
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
    context.read<GetCartCubit>().fetchCart(context);

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
              if (!widget.isGuest) {
                _loadMenu();
              }

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
      if (!widget.isGuest) {
        _loadMenu(); // ✅ Only for logged-in users
      }
    });
  }

  void showLoginPromptBottomSheet(BuildContext context, int qty, Content item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: 40, color: AppColor.PrimaryColor),
              const SizedBox(height: 12),
              Text(
                "Login Required",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Please login to add items to your cart.",
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() {
                          cart[item.name ?? ""] = qty;
                          selectedItems.add(item);
                          totalItems += qty;
                        });
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.PrimaryColor,
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                      child: const Text("Login"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
      body: Column(
        children: [
          // top UI...
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
                      setState(() {
                        filterType = filter;
                      });
                      if (!widget.isGuest) _loadMenu();
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
            child: widget.isGuest
                ? BlocConsumer<GuestMenuByRestaurantIdCubit,
                    GuestMenuByRestaurantIdState>(
                    listener: (context, state) {
                      if (state is GuestMenuByRestaurantIdSuccess) {
                        _isMenuLoaded = true;
                      }
                    },
                    builder: (context, state) {
                      if (state is GuestMenuByRestaurantIdLoading) {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      } else if (state is GuestMenuByRestaurantIdSuccess) {
                        final filteredItems = state.data.content.where((item) {
                          final matchesSearch = (item.name ?? "")
                              .toLowerCase()
                              .contains(searchText.toLowerCase());

                          final foodType = item.attributes
                              .firstWhere(
                                (a) =>
                                    (a.attributeName ?? "").toLowerCase() ==
                                    'type',
                                orElse: () => Attribute(
                                    id: 0,
                                    attributeName: '',
                                    attributeValue: ''),
                              )
                              .attributeValue
                              ?.toLowerCase();

                          final matchesFilter = filterType == 'All' ||
                              (filterType.toLowerCase() == 'veg' &&
                                  foodType == 'veg') ||
                              (filterType.toLowerCase() == 'nonveg' &&
                                  foodType == 'nonveg');

                          return matchesSearch && matchesFilter;
                        }).toList();

                        if (filteredItems.isEmpty) {
                          return const Center(
                              child: Text("No menu items available"));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return MenuItemWidget(
                              item: item,
                              quantity: 0,
                              restaurantId: widget.restaurantId,
                              restaurantName: widget.restaurantName,
                              isGuest: true,
                              onQuantityChanged: (_) {},
                              onGuestAttempt: () {
                                showLoginPromptBottomSheet(context, 0, item);
                              },
                            );
                          },
                        );
                      } else if (state is GuestMenuByRestaurantIdFailure) {
                        return const Center(child: Text("Error loading menu"));
                      }
                      return const SizedBox();
                    },
                  )
                : BlocConsumer<GetMenuByRestaurantIdCubit,
                    GetMenuByRestaurantIdState>(
                    listener: (context, state) {
                      if (state is GetMenuByRestaurantIdLoaded) {
                        setState(() {
                          menuItems = state.model.content;
                          _isMenuLoaded = true;
                        });
                        if (!_isCartLoaded) _loadCart();
                      }
                    },
                    builder: (context, state) {
                      if (state is GetMenuByRestaurantIdLoading) {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      } else if (state is GetMenuByRestaurantIdLoaded) {
                        final filteredItems = menuItems.where((item) {
                          final matchesSearch = (item.name ?? "")
                              .toLowerCase()
                              .contains(searchText.toLowerCase());

                          final foodType = item.attributes
                              .firstWhere(
                                (a) =>
                                    (a.attributeName ?? "").toLowerCase() ==
                                    'type',
                                orElse: () => Attribute(
                                    id: 0,
                                    attributeName: '',
                                    attributeValue: ''),
                              )
                              .attributeValue
                              ?.toLowerCase();

                          final matchesFilter = filterType == 'All' ||
                              (filterType.toLowerCase() == 'veg' &&
                                  foodType == 'veg') ||
                              (filterType.toLowerCase() == 'nonveg' &&
                                  foodType == 'nonveg');

                          return matchesSearch && matchesFilter;
                        }).toList();

                        if (filteredItems.isEmpty) {
                          return const Center(
                              child: Text("No menu items available"));
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
                              restaurantId: widget.restaurantId,
                              restaurantName: widget.restaurantName,
                              onQuantityChanged: (qty) =>
                                  update_Cart(item, qty),
                            );
                          },
                        );
                      } else if (state is GetMenuByRestaurantIdError) {
                        return const Center(child: Text("Error loading menu"));
                      }
                      return const Center(child: Text("Loading..."));
                    },
                  ),
          )
        ],
      ),
    );
  }
}
