import 'dart:async';
import 'package:eato/components/custom_topbar.dart';
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
  final String restaurantName;
  final String restaurantId;

  const RestaurantMenuScreen({
    super.key,
    required this.restaurantName,
    required this.restaurantId,
  });

  @override
  _RestaurantMenuScreenState createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, int> cart = {};
  int totalItems = 0;
  PersistentBottomSheetController? _bottomSheetController;
  bool isBottomSheetVisible = false;
  String searchText = '';
  String filterType = 'All';
  bool useCredit = false;
  double availableCredit = 1000.0;
  int page = 0;
  int size = 10;

  List<Content> selectedItems = [];
  List<Content> menuItems = [];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  void _loadMenu() {
    context.read<GetMenuByRestaurantIdCubit>().fetchMenu({
      'restaurantId': widget.restaurantId,
      'search': searchText,
      'page': page,
      'size': size,
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _bottomSheetController?.close();
    super.dispose();
  }

  void updateCart(Content item, int qty) {
    if (!mounted) return;

    Map<String, int> updatedCart = Map<String, int>.from(cart);
    List<Content> updatedSelectedItems = List<Content>.from(selectedItems);

    if (qty == 0) {
      updatedCart.remove(item.name);
      updatedSelectedItems
          .removeWhere((selectedItem) => selectedItem.name == item.name);
    } else {
      updatedCart[item.name ?? ""] = qty;
      if (!updatedSelectedItems
          .any((selectedItem) => selectedItem.name == item.name)) {
        updatedSelectedItems.add(item);
      }
    }

    int newTotalItems = updatedCart.values.fold(0, (sum, qty) => sum + qty);

    setState(() {
      cart = updatedCart;
      selectedItems = updatedSelectedItems;
      totalItems = newTotalItems;

      final index =
          menuItems.indexWhere((menuItem) => menuItem.name == item.name);
      if (index != -1) {
        menuItems[index] = item;
      }
    });

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
    _bottomSheetController = _scaffoldKey.currentState!.showBottomSheet(
      (context) {
        return RestaurantCartBottomSheet(
          totalItems: totalItems,
          onViewCartPressed: () async {
            _bottomSheetController?.close();

            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CartScreen(
                  cartItems: selectedItems.map((item) {
                    return {
                      'productId': item.id,
                      'quantity': cart[item.name] ?? 0,
                      'price': item.price,
                      'name': item.name,
                      'description': item.description,
                      'categoryName': item.categoryName,
                      'media': item.media,
                    };
                  }).toList(),
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
                    if (quantity != 0) {
                      updateCart(item, quantity);
                    }
                  }
                });
                _onBottomSheetVisibilityChanged(cart.isNotEmpty);

                _loadMenu();
              }
            }
          },
        );
      },
    );

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

    if (!visible) {
      _bottomSheetController?.close();
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: widget.restaurantName,
        onBackPressed: () {
          Navigator.pop(context);
          if (isBottomSheetVisible) {
            _bottomSheetController?.close();
          }
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
                            color: Colors.white,
                          )),
                      const SizedBox(height: 4),
                      Text("Rating: ⭐ 4.5",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white70,
                          )),
                      const SizedBox(height: 4),
                      // Text(
                      //     "Credit Available: ₹${availableCredit.toStringAsFixed(0)}",
                      //     style: GoogleFonts.poppins(
                      //       fontSize: 14,
                      //       color: Colors.white70,
                      //     )),
                    ],
                  ),
                  const Icon(Icons.restaurant_menu,
                      color: Colors.white, size: 32),
                ],
              ),
            ),
            HomeSearchBar(
              hintText: "menu",
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: ['All', 'Veg', 'Non-Veg'].map((filter) {
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
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<GetMenuByRestaurantIdCubit,
                  GetMenuByRestaurantIdState>(
                builder: (context, state) {
                  if (state is GetMenuByRestaurantIdLoading) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else if (state is GetMenuByRestaurantIdLoaded) {
                    menuItems = state.model.content;
                    final filteredItems = menuItems.where((item) {
                      final matchesSearch = item.name
                              ?.toLowerCase()
                              .contains(searchText.toLowerCase()) ??
                          false;
                      final matchesFilter = filterType == 'All' ||
                          (filterType == 'Veg' && item.categoryName == 'Veg') ||
                          (filterType == 'Non-Veg' &&
                              item.categoryName == 'Non-Veg');
                      return matchesSearch && matchesFilter;
                    }).toList();

                    return filteredItems.isEmpty
                        ? Center(
                            child: Text(
                              "No items match your filter.",
                              style: GoogleFonts.poppins(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final quantity = cart[item.name ?? ""] ?? 0;

                              return MenuItemWidget(
                                item: item,
                                quantity: quantity,
                                onQuantityChanged: (qty) =>
                                    updateCart(item, qty),
                              );
                            },
                          );
                  } else if (state is GetMenuByRestaurantIdError) {
                    return Center(
                      child: Text(
                        "Error: ${state.message}",
                        style: GoogleFonts.poppins(color: Colors.red),
                      ),
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
