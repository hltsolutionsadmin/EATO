import 'package:eato/components/bottomTab.dart';
import 'package:eato/components/custom_button.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/core/constants/img_const.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/get/current_customer_cubit.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/get/current_customer_state.dart';
import 'package:eato/presentation/cubit/authentication/login/trigger_otp_cubit.dart';
import 'package:eato/presentation/cubit/authentication/login/trigger_otp_state.dart';
import 'package:eato/presentation/cubit/authentication/signin/sigin_cubit.dart';
import 'package:eato/presentation/cubit/authentication/signin/signin_state.dart';
import 'package:eato/presentation/screen/authentication/nameInput_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  final FocusNode focusNode = FocusNode();
  String otpValue = '';
  String otp;
  final String mobileNumber;
  String fullName;

  OtpScreen(
      {super.key,
      required this.mobileNumber,
      required this.otp,
      required this.otpValue,
      required this.fullName});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController otpFieldController = TextEditingController();
  final FocusNode focusNode = FocusNode();

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
    otpFieldController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _navigateBasedOnCustomerStatus(BuildContext context) {
    // After successful sign-in, fetch current customer data
    context.read<CurrentCustomerCubit>().GetCurrentCustomer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MultiBlocListener(
        listeners: [
          BlocListener<SignInCubit, SignInState>(
            listener: (context, state) {
              if (state is SignInLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Center(
                      child: CupertinoActivityIndicator(
                    color: AppColor.PrimaryColor,
                  )),
                );
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }

              if (state is SignInLoaded) {
                _navigateBasedOnCustomerStatus(context);
              } else if (state is SignInError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<TriggerOtpCubit, TriggerOtpState>(
            listener: (context, state) {
              if (state is ResendOtpLoaded) {
                setState(() {
                  widget.otp = state.resendOtp.otp ?? '';
                });
              } else if (state is TriggerOtpError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<CurrentCustomerCubit, CurrentCustomerState>(
            listener: (context, state) {
              if (state is CurrentCustomerLoaded) {
                if (state.currentCustomerModel.eato == true) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => BottomTab()),
                  );
                } else {
                  // Navigate to CurrentUserFormScreen if eato is false
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => NameInputScreen()),
                  );
                }
              } else if (state is CurrentCustomerError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ],
        child: Stack(
          children: [
            _buildBackgroundImage(),
            Align(
              alignment: Alignment.bottomCenter,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildOtpContainer(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Rest of your existing methods remain the same...
  Widget _buildBackgroundImage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Image.asset(
        dish,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  Widget _buildOtpContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      height: MediaQuery.of(context).size.height * 0.52,
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
            "Enter OTP",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColor.White,
            ),
          ),
          const SizedBox(height: 20),
          _buildSubtitle(),
          const SizedBox(height: 30),
          if (widget.otp != 'true') _buildOtpDisplay(),
          const SizedBox(height: 20),
          _buildOtpInput(),
          const SizedBox(height: 30),
          BlocBuilder<TriggerOtpCubit, TriggerOtpState>(
            builder: (context, state) {
              return _buildVerifyButton(context, state);
            },
          ),
          const SizedBox(height: 20),
          _buildResendOtp(context),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      "We've sent a verification code to your phone",
      style: TextStyle(
        color: AppColor.White,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildOtpDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.White),
      ),
      child: Text(
        'OTP: ${widget.otp}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColor.White,
        ),
      ),
    );
  }

  Widget _buildOtpInput() {
    return Pinput(
      length: 6,
      focusNode: focusNode,
      controller: otpFieldController,
      keyboardType: TextInputType.number,
      onCompleted: (val) {
        context
            .read<SignInCubit>()
            .signIn(context, widget.mobileNumber, val, widget.fullName);
      },
      defaultPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: TextStyle(
          fontSize: 22,
          color: AppColor.White,
          fontWeight: FontWeight.bold,
        ),
        decoration: BoxDecoration(
          color: AppColor.PrimaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.White),
        ),
      ),
    );
  }

  Widget _buildVerifyButton(BuildContext context, TriggerOtpState state) {
    return CustomButton(
      buttonText: 'Verify & Continue',
      isLoading: state is SignInLoading,
      onPressed: () {
        if (otpFieldController.text.length == 6) {
          context.read<SignInCubit>().signIn(
                context,
                widget.mobileNumber,
                otpFieldController.text,
                widget.fullName,
              );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please enter a valid 6-digit OTP.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  Widget _buildResendOtp(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<TriggerOtpCubit>().resendOtp(context, widget.mobileNumber);
      },
      child: Text.rich(
        TextSpan(
          text: "Didn't receive an OTP? ",
          style: TextStyle(color: AppColor.White, fontSize: 16),
          children: [
            TextSpan(
              text: 'Resend OTP',
              style: TextStyle(
                color: AppColor.White,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}