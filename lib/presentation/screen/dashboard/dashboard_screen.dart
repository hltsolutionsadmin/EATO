import 'package:eato/core/constants/colors.dart';
import 'package:eato/core/constants/img_const.dart';
import 'package:eato/data/model/cart/getCart/getCart_model.dart';
import 'package:eato/presentation/cubit/cart/createCart/createCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_state.dart';
import 'package:eato/presentation/cubit/restaurants/getNearbyRestaurants/getNearByrestarants_cubit.dart';
import 'package:eato/presentation/cubit/restaurants/getNearbyRestaurants/getNearByrestarants_state.dart';
import 'package:eato/presentation/cubit/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_cubit.dart';
import 'package:eato/presentation/cubit/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_state.dart';
import 'package:eato/presentation/cubit/restaurants/guestNearbyRestaurants/guestNearbyRestaurants_cubit.dart';
import 'package:eato/presentation/cubit/restaurants/guestNearbyRestaurants/guestNearbyRestaurants_state.dart';
import 'package:eato/presentation/screen/cart/cart_screen.dart';
import 'package:eato/presentation/screen/restaurantMenu/restaurantMenu_screen.dart';
import 'package:eato/presentation/screen/widgets/dashboard/bottom_card_widget.dart';
import 'package:eato/presentation/screen/widgets/dashboard/foodCatagoryIcons.dart';
import 'package:eato/presentation/screen/widgets/dashboard/foodItemCard.dart';
import 'package:eato/presentation/screen/widgets/dashboard/locationHeader.dart';
import 'package:eato/components/searchBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  final bool isGuest;
  const DashboardScreen({super.key, this.isGuest = false});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double? latitude;
  double? longitude;
  String searchQuery = '';
  dynamic cartdata = {};
  List<dynamic> cartList = [];
  Map<String, int> cart = {};
  final ScrollController _scrollController = ScrollController();
  bool _showBottomCart = true;
  bool _isScrollingDown = false;
  double _scrollPosition = 0;
  int totalItems = 0, page = 0, size = 10;

  @override
  void initState() {
    super.initState();
    context.read<CreateCartCubit>().createCart(context);
    _loadCoordinatesAndFetch();
    fetchCart();
    _scrollController.addListener(_scrollListener);
  }

  void fetchCart() async {
    await context.read<GetCartCubit>().fetchCart(context);
    final state = context.read<GetCartCubit>().state;
    if (state is GetCartLoaded) {
      cartList = state.cart.cartItems as List<CartItems>;
      cartdata = state.cart;
    } else {
      cartList = [];
      cartdata = {};
    }
  }

  void onLocationChanged() {
    _loadCoordinatesAndFetch();
    setState(() {});
  }

  Future<void> _loadCoordinatesAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    latitude = prefs.getDouble('saved_latitude') ?? 17.385044;
    longitude = prefs.getDouble('saved_longitude') ?? 78.486671;

    if (widget.isGuest) {
      await context
          .read<GuestNearByRestaurantsCubit>()
          .fetchGuestNearbyRestaurants({
        "latitude": latitude,
        "longitude": longitude,
        "postalCode": "531001",
        "page": page,
        "size": size,
      });
    } else {
      context.read<GetNearbyRestaurantsCubit>().fetchNearbyRestaurants({
        "latitude": latitude,
        "longitude": longitude,
        "postalCode": "531001",
        "page": page,
        "size": size,
      });
    }
  }

  void _showRestaurantMenu(String restaurantName, String restaurantId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantMenuScreen(
          restaurantName: restaurantName,
          restaurantId: restaurantId,
          isGuest: widget.isGuest,
        ),
      ),
    ).then((value) => fetchCart());
  }

  Widget _buildNearbyRestaurants() {
    if (widget.isGuest) {
      return BlocBuilder<GuestNearByRestaurantsCubit,
          GuestNearByRestaurantsState>(
        builder: (context, state) {
          if (state is GuestNearByRestaurantsLoading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is GuestNearByRestaurantsSuccess) {
            final restaurants = state.data.content;
            return Column(
              children: restaurants.map((restaurant) {
                final data = {
                  "Restaurant": restaurant.businessName ?? "Unknown",
                  "Items": restaurant.categoryName ?? "",
                  "price": "₹200",
                  "itemPrice": "From ₹ 89",
                  "image": dish,
                  "time": "20 - 25 MINS",
                };
                return FoodItemCard(
                  data: data,
                  onRestaurantTap: (name) => _showRestaurantMenu(
                      name, (restaurant.id ?? "").toString()),
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text("Error loading guest restaurants"));
          }
        },
      );
    } else {
      return BlocBuilder<GetNearbyRestaurantsCubit, GetNearbyRestaurantsState>(
        builder: (context, state) {
          if (state is GetNearbyRestaurantsLoading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is GetNearbyRestaurantsLoaded) {
            final restaurants = state.model.content;
            return Column(
              children: restaurants.map((restaurant) {
                final data = {
                  "Restaurant": restaurant.businessName ?? "Unknown",
                  "Items": restaurant.categoryName ?? "",
                  "price": "₹200",
                  "itemPrice": "From ₹ 89",
                  "image": dish,
                  "time": "20 - 25 MINS",
                };
                return FoodItemCard(
                  data: data,
                  onRestaurantTap: (name) => _showRestaurantMenu(
                      name, (restaurant.id ?? "").toString()),
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text("Error loading restaurants"));
          }
        },
      );
    }
  }

  Widget _buildSearchResults() {
    return BlocBuilder<GetRestaurantsByProductNameCubit,
        GetRestaurantsByProductNameState>(
      builder: (context, state) {
        if (state is GetRestaurantsByProductNameLoading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is GetRestaurantsByProductNameSuccess) {
          final restaurants = state.model.content;
          if (restaurants.isEmpty) {
            return const Center(child: Text("No restaurants found"));
          }
          return Column(
            children: restaurants.map((restaurant) {
              final data = {
                "Restaurant": restaurant.businessName ?? "Unknown",
                "Items": restaurant.categoryName ?? "",
                "price": "₹200",
                "itemPrice": "From ₹ 89",
                "image": dish,
                "time": "20 - 25 MINS",
              };
              return FoodItemCard(
                data: data,
                onRestaurantTap: (name) => _showRestaurantMenu(
                    name, (restaurant.businessId ?? "").toString()),
              );
            }).toList(),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void _scrollListener() {
    final currentPosition = _scrollController.position.pixels;
    if (currentPosition > _scrollPosition) {
      if (!_isScrollingDown) {
        _isScrollingDown = true;
        if (_showBottomCart) {
          setState(() => _showBottomCart = false);
        }
      }
    } else if (currentPosition < _scrollPosition) {
      if (_isScrollingDown) {
        _isScrollingDown = false;
        if (!_showBottomCart) {
          setState(() => _showBottomCart = true);
        }
      }
    }
    _scrollPosition = currentPosition;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetCartCubit, GetCartState>(
      listener: (context, state) {
        if (state is GetCartLoaded) {
          setState(() {
            cartList = state.cart.cartItems as List<CartItems>;
            cartdata = state.cart;
          });
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColor.PrimaryColor,
            elevation: 0,
            title: LocationHeader(
              latitude: latitude,
              longitude: longitude,
              onLocationChanged: onLocationChanged,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CategorySearchBar(
                  hintText: "Search for restaurants, dishes, and cuisines",
                  onChanged: (value) async {
                    setState(() => searchQuery = value);
                    final prefs = await SharedPreferences.getInstance();
                    final latitude =
                        prefs.getDouble('saved_latitude') ?? 17.385044;
                    final longitude =
                        prefs.getDouble('saved_longitude') ?? 78.486671;
                    context
                        .read<GetRestaurantsByProductNameCubit>()
                        .fetchRestaurantsByProductName({
                      "productName": value,
                      "latitude": latitude,
                      "longitude": longitude,
                      "postalCode": "531001",
                      "page": 0,
                      "size": 10,
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        backgroundColor: AppColor.White,
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      FoodCategoryIcons(
                        onCategoryTap: (label) async {
                          setState(() => searchQuery = label);
                          final prefs = await SharedPreferences.getInstance();
                          final latitude =
                              prefs.getDouble('saved_latitude') ?? 17.385044;
                          final longitude =
                              prefs.getDouble('saved_longitude') ?? 78.486671;
                          context
                              .read<GetRestaurantsByProductNameCubit>()
                              .fetchRestaurantsByProductName({
                            "productName": label,
                            "latitude": latitude,
                            "longitude": longitude,
                            "postalCode": "531001",
                            "page": 0,
                            "size": 10,
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Restaurants to Explore",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColor.Black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      searchQuery.isEmpty
                          ? _buildNearbyRestaurants()
                          : _buildSearchResults(),
                      SizedBox(height: cartList.isNotEmpty ? 80 : 0),
                    ],
                  ),
                ),
              ),
            ),
            if (cartList.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  offset: _showBottomCart ? Offset.zero : const Offset(0, 1),
                  child: BottomCartCard(
                    itemCount: cartdata.totalCount,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CartScreen(
                            cartItems: cartList
                                .map((item) => {
                                      'productId': item.id,
                                      'quantity': item.quantity ?? 0,
                                      'price': item.price,
                                      'name': item.productName,
                                      'description': item.productName,
                                    })
                                .toList(),
                          ),
                        ),
                      );
                      if (!mounted) return;
                      if (result != null && result is Map<String, dynamic>) {
                        final updatedCart =
                            result['updatedCart'] as Map<String, int>?;
                        final updatedCartLength =
                            result['cartItemsLength'] ?? 0;
                        if (updatedCart != null) {
                          setState(() {
                            cart = Map<String, int>.from(updatedCart);
                            totalItems = updatedCartLength;
                            cartdata.totalCount = updatedCartLength;
                          });
                        }
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}