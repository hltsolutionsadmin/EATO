import 'package:eato/components/bottomTab.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/core/injection.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/get/current_customer_cubit.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/get/current_customer_state.dart';
import 'package:eato/presentation/screen/authentication/onboard_screen.dart';
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
    context.read<CurrentCustomerCubit>().GetCurrentCustomer(context);
    context.read<CurrentCustomerCubit>().startTimer();
    _checkSession(context);
  }

  _checkSession(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('TOKEN') ?? '';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (token.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomTab()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OnboardingScreen()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CurrentCustomerCubit>(),
      child: BlocListener<CurrentCustomerCubit, CurrentCustomerState>(
        listener: (context, state) {
          if (state is CurrentCustomerLoaded) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OnboardingScreen()),
            );
          } else if (state is CurrentCustomerError) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OnboardingScreen()),
            );
          }
        },
        child: Scaffold(
          backgroundColor:AppColor.PrimaryColor, 
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
             Text(
                  "Eato",
                  style: TextStyle(
                    fontSize: 60, 
                    fontWeight: FontWeight.bold,
                    color:AppColor.White,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
