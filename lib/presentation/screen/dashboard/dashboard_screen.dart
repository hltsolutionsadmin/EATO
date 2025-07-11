import 'package:eato/core/constants/colors.dart';
import 'package:eato/core/constants/img_const.dart';
import 'package:eato/data/model/cart/getCart/getCart_model.dart';
import 'package:eato/presentation/cubit/cart/clearCart/clearCart_cubit.dart';
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
import 'package:eato/presentation/screen/widgets/dashboard/LocationPermissionDialog.dart';
import 'package:eato/presentation/screen/widgets/dashboard/bottom_card_widget.dart';
import 'package:eato/presentation/screen/widgets/dashboard/clear_cart_dialog.dart';
import 'package:eato/presentation/screen/widgets/dashboard/foodCatagoryIcons.dart';
import 'package:eato/presentation/screen/widgets/dashboard/foodItemCard.dart';
import 'package:eato/presentation/screen/widgets/dashboard/locationHeader.dart';
import 'package:eato/components/searchBar.dart';
import 'package:eato/presentation/screen/widgets/dashboard/offersCard_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
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
  List<CartItem> cartList = [];
  GetCartModel? cartData;
  final ScrollController _scrollController = ScrollController();
  bool _showBottomCart = true;
  bool _isScrollingDown = false;
  double _scrollPosition = 0;
  int page = 0, size = 10;
  bool _isLoading = true;

@override
  void initState() {
    super.initState();
    context.read<CreateCartCubit>().createCart(context);
    _requestLocationPermission();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await _loadCoordinatesAndFetchRestaurants();

      if (!widget.isGuest) {
        await _fetchCart();
      }
    } else {
      if (!mounted) return;
      await LocationPermissionDialog.show(context);
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _clearCart() async {
    await context.read<ClearCartCubit>().clearCart(context);
    await _fetchCart();
  }

  void _scrollListener() {
    final currentPosition = _scrollController.position.pixels;
    final scrollDelta = currentPosition - _scrollPosition;
    _scrollPosition = currentPosition;

    if (cartList.isNotEmpty && (cartData?.totalCount ?? 0) > 0) {
      if (scrollDelta > 10 && !_isScrollingDown) {
        _isScrollingDown = true;
        if (_showBottomCart) setState(() => _showBottomCart = false);
      } else if (scrollDelta < -10 && _isScrollingDown) {
        _isScrollingDown = false;
        if (!_showBottomCart) setState(() => _showBottomCart = true);
      }
    }
  }

  Future<void> _fetchCart() async {
    await context.read<GetCartCubit>().fetchCart(context);

    final state = context.read<GetCartCubit>().state;
    if (state is GetCartLoaded) {
      setState(() {
        cartList = state.cart.cartItems;
        cartData = state.cart;
        _showBottomCart =
            cartList.isNotEmpty && (cartData?.totalCount ?? 0) > 0;
      });
    }
  }

  void _onLocationChanged() {
    _loadCoordinatesAndFetchRestaurants();
  }

  Future<void> _loadCoordinatesAndFetchRestaurants() async {
    // await Future.delayed(const Duration(milliseconds: 500)); // Optional delay

    final prefs = await SharedPreferences.getInstance();

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude = position.latitude;
      longitude = position.longitude;
      prefs.setDouble('saved_latitude', latitude!);
      prefs.setDouble('saved_longitude', longitude!);
    } catch (e) {
    latitude = prefs.getDouble('saved_latitude') ?? 17.385044;
    longitude = prefs.getDouble('saved_longitude') ?? 78.486671;
    }

    final params = {
      "latitude": latitude,
      "longitude": longitude,
      "postalCode": "531001",
      "page": page,
      "size": size,
    };

    if (widget.isGuest) {
      context
          .read<GuestNearByRestaurantsCubit>()
          .fetchGuestNearbyRestaurants(params);
    } else {
      context.read<GetNearbyRestaurantsCubit>().fetchNearbyRestaurants(params);
    }
  }

  void _navigateToRestaurantMenu(String name, String id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RestaurantMenuScreen(
          restaurantName: name,
          restaurantId: id,
          isGuest: widget.isGuest,
        ),
      ),
    );

    if (!mounted) return;
    _fetchCart();
  }

  Map<String, String> _buildRestaurantCardData(String name, String category) {
    return {
      "Restaurant": name,
      "Items": category,
      "price": "₹200",
      "itemPrice": "From ₹ 89",
      "image": dish,
      "time": "20 - 25 MINS",
    };
  }

  Widget _buildRestaurantList<T>({
    required List<T> restaurants,
    required String Function(T) getName,
    required String Function(T) getCategory,
    required String Function(T) getId,
  }) {
    return Column(
      children: restaurants.map((restaurant) {
        final data = _buildRestaurantCardData(
          getName(restaurant),
          getCategory(restaurant),
        );
        return FoodItemCard(
          data: data,
          onRestaurantTap: (name) =>
              _navigateToRestaurantMenu(name, getId(restaurant)),
        );
      }).toList(),
    );
  }

  Widget _buildNearbyRestaurants() {
    return widget.isGuest
        ? BlocBuilder<GuestNearByRestaurantsCubit, GuestNearByRestaurantsState>(
            builder: (context, state) {
              if (state is GuestNearByRestaurantsLoading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state is GuestNearByRestaurantsSuccess) {
                return _buildRestaurantList(
                  restaurants: state.data.content,
                  getName: (r) => r.businessName ?? "Unknown",
                  getCategory: (r) => r.categoryName ?? "",
                  getId: (r) => (r.id ?? "").toString(),
                );
              } else {
                return const Center(
                    child: Text("Failed to load guest restaurants"));
              }
            },
          )
        : BlocBuilder<GetNearbyRestaurantsCubit, GetNearbyRestaurantsState>(
            builder: (context, state) {
              if (state is GetNearbyRestaurantsLoading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state is GetNearbyRestaurantsLoaded) {
                return _buildRestaurantList(
                  restaurants: state.model.content,
                  getName: (r) => r.businessName ?? "Unknown",
                  getCategory: (r) => r.categoryName ?? "",
                  getId: (r) => (r.id ?? "").toString(),
                );
              } else {
                return const Center(child: Text("Failed loading restaurants"));
              }
            },
          );
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
          return _buildRestaurantList(
            restaurants: restaurants,
            getName: (r) => r.businessName ?? "Unknown",
            getCategory: (r) => r.categoryName ?? "",
            getId: (r) => (r.businessId ?? "").toString(),
          );
        }
        return const SizedBox();
      },
    );
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
            cartList = state.cart.cartItems;
            cartData = state.cart;
            _showBottomCart =
                cartList.isNotEmpty && (cartData?.totalCount ?? 0) > 0;
          });
        }
        if (state is GetCartError) {}
      },
      child: Scaffold(
        backgroundColor: AppColor.White,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(350),
          child: ClipPath(
            clipper: EyeShapeClipper(),
            child: Container(
              color: AppColor.PrimaryColor,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: LocationHeader(
                        latitude: latitude,
                        longitude: longitude,
                        onLocationChanged: _onLocationChanged,
                        isGuest: widget.isGuest,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: CategorySearchBar(
                        hintText:
                            "Search for restaurants, dishes, and cuisines",
                        onChanged: (query) async {
                          setState(() => searchQuery = query);
                          final prefs = await SharedPreferences.getInstance();
                          final lat =
                              prefs.getDouble('saved_latitude') ?? 17.385044;
                          final lon =
                              prefs.getDouble('saved_longitude') ?? 78.486671;

                          context
                              .read<GetRestaurantsByProductNameCubit>()
                              .fetchRestaurantsByProductName({
                            "productName": query,
                            "latitude": lat,
                            "longitude": lon,
                            "postalCode": "531001",
                            "page": 0,
                            "size": 10,
                          });
                        },
                      ),
                    ),
                    const OffersCarousel(),
                  ],
                ),
              ),
            ),
          ),
        ),
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
                          final lat =
                              prefs.getDouble('saved_latitude') ?? 17.385044;
                          final lon =
                              prefs.getDouble('saved_longitude') ?? 78.486671;

                          context
                              .read<GetRestaurantsByProductNameCubit>()
                              .fetchRestaurantsByProductName({
                            "productName": label,
                            "latitude": lat,
                            "longitude": lon,
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
            if (cartList.isNotEmpty && (cartData?.totalCount ?? 0) > 0)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  offset: _showBottomCart ? Offset.zero : const Offset(0, 1),
                  child: BottomCartCard(
                    itemCount: cartData?.totalCount ?? 0,
                    onDeletePressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ClearCartDialog(
                          onClear: () async {
                            await _clearCart();
                          },
                        ),
                      );
                    },
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CartScreen(
                            cartItems: cartList
                                .map((cartItem) => {
                                      'productId': cartItem.productId,
                                      'quantity': cartItem.quantity ?? 0,
                                      'price': cartItem.price ?? 0,
                                      'name': cartItem.productName ?? '',
                                      'media': cartItem.media.isNotEmpty
                                          ? cartItem.media[0].url
                                          : null,
                                    })
                                .toList(),
                          ),
                        ),
                      );

                      if (!mounted) return;

                      if (result != null && result is Map) {
                        final int updatedCount = result['cartItemsLength'] ?? 0;
                        final cubit = context.read<GetCartCubit>();
                        await cubit.fetchCart(context);
                        final state = cubit.state;
                        if (state is GetCartLoaded) {
                          setState(() {
                            cartList = state.cart.cartItems;
                            cartData = state.cart;
                            _showBottomCart = updatedCount > 0 &&
                                (cartData?.totalCount ?? 0) > 0;
                          });
                          double total = 0;
                          debugPrint("🛒 Updated Cart Items:");
                          for (var item in cartList) {
                            final quantity = item.quantity ?? 0;
                            final price = item.price ?? 0;
                            final itemTotal = quantity * price;
                            total += itemTotal;
                            debugPrint(
                                "→ ${item.productName}: Qty = $quantity, Price = ₹$price, Total = ₹$itemTotal");
                          }
                          debugPrint(
                              "🧾 Grand Total: ₹${total.toStringAsFixed(2)}");
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

class EyeShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height + 20, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
