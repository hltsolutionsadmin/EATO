import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eato/core/network/network_cubit.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/current_customer_cubit.dart';
import 'package:eato/presentation/cubit/authentication/login/trigger_otp_cubit.dart';
import 'package:eato/presentation/cubit/authentication/roles/rolesPost_cubit.dart';
import 'package:eato/presentation/cubit/authentication/signUp/signup_cubit.dart';
import 'package:eato/presentation/cubit/authentication/signin/sigin_cubit.dart';
import 'package:eato/presentation/cubit/cart/createCart/createCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/getCart/getCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/productsAddToCart/productsAddtoCart_cubit.dart';
import 'package:eato/presentation/cubit/cart/updateCartItems/updateCartItems_cubit.dart';
import 'package:eato/presentation/cubit/location/location_cubit.dart';
import 'package:eato/presentation/cubit/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_cubit.dart';
import 'package:eato/presentation/cubit/restaurants/getNearbyRestaurants/getNearByrestarants_cubit.dart';
import 'package:eato/presentation/screen/authentication/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection.dart' as di;



final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  di.init();

  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    print("No Internet Connection");
  } else {
    print("Connected to the Internet");
  }
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<TriggerOtpCubit>()),
        BlocProvider(create: (_) => di.sl<SignInCubit>()),
        BlocProvider(create: (_) => di.sl<SignUpCubit>()),
        BlocProvider(create: (_) => di.sl<CurrentCustomerCubit>()),
        BlocProvider(create: (_) => di.sl<NetworkCubit>()),
        BlocProvider(create: (_) => di.sl<LocationCubit>()),
        BlocProvider(create: (_) => di.sl<RolePostCubit>()),
        BlocProvider(create: (_) => di.sl<GetNearbyRestaurantsCubit>()),
        BlocProvider(create: (_) => di.sl<GetMenuByRestaurantIdCubit>()),
        BlocProvider(create: (_) => di.sl<CreateCartCubit>()),
        BlocProvider(create: (_) => di.sl<GetCartCubit>()),
        BlocProvider(create: (_) => di.sl<ProductsAddToCartCubit>()),
        BlocProvider(create: (_) => di.sl<UpdateCartItemsCubit>()),
      ],
      child: MaterialApp(
        title: 'Eato',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home:  SplashScreen(),
      ),
    );
  }
}