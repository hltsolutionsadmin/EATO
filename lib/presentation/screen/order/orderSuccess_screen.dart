import 'package:eato/components/custom_button.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/presentation/screen/order/orderTracking_screen.dart';
import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color(0xFF4CAF50).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: TweenAnimationBuilder(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 500),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Icon(
                                Icons.check_circle,
                                size: 60,
                                color: Color(0xFF4CAF50),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Order Confirmed!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your delicious food is being prepared and will arrive soon',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  color: AppColor.PrimaryColor, size: 20),
                              SizedBox(width: 12),
                              Text(
                                'Estimated Delivery Time',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '25-35 min',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Divider(height: 1, color: Colors.grey[200]),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(Icons.receipt,
                                  color: AppColor.PrimaryColor, size: 20),
                              SizedBox(width: 12),
                              Text(
                                'Order Number',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '#FD-128456',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: CustomButton(
                          buttonText: "Track Your Order",
                          onPressed: () {
                            // Navigator.pushNamed(context, '/orderTracking');
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return OrderTracker(
                                  orderId: "1234", status: "Preparing");
                            }));
                          }),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0, left: 32, right: 32),
              child: TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    color: AppColor.PrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
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
