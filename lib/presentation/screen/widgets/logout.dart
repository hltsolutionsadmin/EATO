import 'package:eato/core/constants/colors.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/current_customer_cubit.dart';
import 'package:eato/presentation/screen/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutCnfrmBottomSheet extends StatelessWidget {
  const LogOutCnfrmBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  
                  context.read<CurrentCustomerCubit>().reset();

                  prefs.remove('TOKEN');
                  prefs.clear();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (_) => false,
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColor.Black),
                child:  Text('Yes', style: TextStyle(color: AppColor.White)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
