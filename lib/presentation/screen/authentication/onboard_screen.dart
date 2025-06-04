import 'package:eato/core/constants/colors.dart';
import 'package:eato/core/constants/img_const.dart';
import 'package:eato/presentation/screen/authentication/login_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: AppColor.PrimaryColor),
          ),

          Positioned.fill(
            child: ClipPath(
              clipper: DiagonalWaveClipper(),
              child: Container(color: AppColor.White),
            ),
          ),

          Positioned(
            top: 30,
            right: -10,
            child: ClipOval(
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Image.asset(
                  dish,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 380,
            left: 30,
            right: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit sed.",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColor.Black,
                  ),
                ),
                const SizedBox(height: 12),
                 Text(
                  "Tempor incididunt ut labore et dolore magna aliqua consectetur adipiscing elit sed.",
                  style: TextStyle(fontSize: 16, color: AppColor.Black),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 60,
            left: 100,
            right: 100,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.White,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 5,
              ),
              onPressed: () {
                 Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
              },
              child:  Text(
                "Get Started",
                style: TextStyle(fontSize: 18, color: AppColor.PrimaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiagonalWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(size.width, size.height * 0);
    path.quadraticBezierTo(
      size.width * 1, size.height * 0.25,
      size.width * 0.45, size.height * 0.25,
    );
    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.27,
      5, size.height * 0.45,
    );

    path.lineTo(0, size.height );

    path.quadraticBezierTo(
      size.width * 0, size.height * 0.78,
      size.width * 0.45, size.height * 0.75,
    );
    path.quadraticBezierTo(
      size.width * 0.72, size.height * 0.73,
      size.width, size.height * 0.55,
    );

    path.lineTo(size.width, size.height * 0.2);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


