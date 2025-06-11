import 'package:eato/components/bottomTab.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/core/injection.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/get/current_customer_cubit.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/get/current_customer_state.dart';
import 'package:eato/presentation/screen/authentication/login_screen.dart';
import 'package:eato/presentation/screen/authentication/nameInput_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Start fetching customer data
    context.read<CurrentCustomerCubit>().GetCurrentCustomer(context);
    // No need to await, navigation will be handled in BlocListener
  }

  void _navigateTo(Widget screen) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentCustomerCubit, CurrentCustomerState>(
      listener: (context, state) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('TOKEN') ?? '';
        if (state is CurrentCustomerLoaded) {
          final eatoStatus = state.currentCustomerModel.eato ?? false;
          debugPrint('Eato status: $eatoStatus, Token: ${token.isNotEmpty}');
          if (eatoStatus && token.isNotEmpty) {
            _navigateTo(BottomTab());
          } else {
            _navigateTo(NameInputScreen());
          }
        } else if (state is CurrentCustomerError) {
          _navigateTo(LoginScreen());
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.PrimaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Eato",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: AppColor.White,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}