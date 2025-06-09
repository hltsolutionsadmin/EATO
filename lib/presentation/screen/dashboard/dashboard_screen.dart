import 'package:eato/core/constants/colors.dart';
import 'package:eato/core/constants/img_const.dart';
import 'package:eato/presentation/cubit/cart/createCart/createCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_cubit.dart';
import 'package:eato/presentation/cubit/restaurants/getNearbyRestaurants/getNearByrestarants_cubit.dart';
import 'package:eato/presentation/cubit/restaurants/getNearbyRestaurants/getNearByrestarants_state.dart';
import 'package:eato/presentation/cubit/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_cubit.dart';
import 'package:eato/presentation/cubit/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_state.dart';
import 'package:eato/presentation/screen/restaurantMenu/restaurantMenu_screen.dart';
import 'package:eato/presentation/screen/widgets/dashboard/foodCatagoryIcons.dart';
import 'package:eato/presentation/screen/widgets/dashboard/foodItemCard.dart';
import 'package:eato/presentation/screen/widgets/dashboard/locationHeader.dart';
import 'package:eato/components/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double? latitude;
  double? longitude;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<CreateCartCubit>().createCart();
    context.read<GetCartCubit>().fetchCart();
    _loadCoordinatesAndFetch();
  }

  // Add this method to be called when location changes
  void onLocationChanged() {
    _loadCoordinatesAndFetch();
    setState(() {}); // Trigger a rebuild
  }

  Future<void> _loadCoordinatesAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      latitude = prefs.getDouble('saved_latitude') ?? 17.385044;
      longitude = prefs.getDouble('saved_longitude') ?? 78.486671;
    });

    context.read<GetNearbyRestaurantsCubit>().fetchNearbyRestaurants({
      "latitude": latitude,
      "longitude": longitude,
      "postalCode": "531001",
      "page": 0,
      "size": 10,
    });
  }

  void _showRestaurantMenu(String restaurantName, String restaurantId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantMenuScreen(
          restaurantName: restaurantName,
          restaurantId: restaurantId,
        ),
      ),
    );
  }

  Widget _buildNearbyRestaurants() {
    return BlocBuilder<GetNearbyRestaurantsCubit, GetNearbyRestaurantsState>(
      builder: (context, state) {
        if (state is GetNearbyRestaurantsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetNearbyRestaurantsLoaded) {
          final restaurants = state.model.content;
          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
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
                onRestaurantTap: (name) =>
                    _showRestaurantMenu(name, (restaurant.id ?? "").toString()),
              );
            },
          );
        } else if (state is GetNearbyRestaurantsError) {
          print("Error: ${state.message}");
          return Center(child: Text("Error fetching restaurants")); 
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<GetRestaurantsByProductNameCubit,
        GetRestaurantsByProductNameState>(
      builder: (context, state) {
        if (state is GetRestaurantsByProductNameLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetRestaurantsByProductNameSuccess) {
          final restaurants = state.model.content;
          if (restaurants.isEmpty) {
            return const Center(child: Text("No restaurants found"));
          }
          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
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
            },
          );
        } else if (state is GetRestaurantsByProductNameFailure) {
          return Center(child: Text("Error fetching results"));
        } else {
          return const SizedBox();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColor.PrimaryColor,
              elevation: 0,
              title: LocationHeader(
                latitude: latitude,
                longitude: longitude,
                onLocationChanged: onLocationChanged, // Pass the callback
              ),
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: CategorySearchBar(
                    hintText: "Search for restaurants, dishes, and cuisines",
                    onChanged: (value) async {
                      setState(() {
                        searchQuery = value;
                      });
                      if (value.isNotEmpty) {
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
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: AppColor.White,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  FoodCategoryIcons(
                    onCategoryTap: (label) async {
                      if (label.isNotEmpty) {
                        setState(() {
                          searchQuery = label;
                        });
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
                      } else {
                        setState(() {
                          searchQuery = '';
                        });
                      }
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
                  Expanded(
                    child: searchQuery.isEmpty
                        ? _buildNearbyRestaurants()
                        : _buildSearchResults(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}