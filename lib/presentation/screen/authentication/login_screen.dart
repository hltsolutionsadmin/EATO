import 'package:eato/components/custom_button.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/core/constants/img_const.dart';
import 'package:eato/presentation/cubit/authentication/login/trigger_otp_cubit.dart';
import 'package:eato/presentation/cubit/authentication/login/trigger_otp_state.dart';
import 'package:eato/presentation/screen/authentication/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/injection.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController mobileNumberController = TextEditingController();
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TriggerOtpCubit>(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Image.asset(
                dish,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    color: AppColor.PrimaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColor.White,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: mobileNumberController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColor.White),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: AppColor.White, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(color: AppColor.White),
                          prefixIcon: Icon(Icons.phone, color: AppColor.White),
                        ),
                        style: TextStyle(color: AppColor.White),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            activeColor: Colors.transparent,
                            side: BorderSide(color: AppColor.White, width: 2),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            },
                            child: Text(
                              "I agree to the Terms & Conditions",
                              style: TextStyle(color: AppColor.White),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      BlocBuilder<TriggerOtpCubit, TriggerOtpState>(
                        builder: (context, state) {
                          return CustomButton(
                            buttonText: "Next",
                            isLoading: state is TriggerOtpLoading,
                            onPressed: () {
                              if (isChecked) {
                                final triggerOtpCubit =
                                    context.read<TriggerOtpCubit>();
                                triggerOtpCubit.fetchOtp(
                                    context, mobileNumberController.text);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
