import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eato/data/model/orders/orderHistory/orderHistory_model.dart';

class RatingService {
  static final RatingService _instance = RatingService._internal();
  factory RatingService() => _instance;
  RatingService._internal();

  Future<void> checkAndShowRatingPopup({
    required BuildContext context,
    required List<Content> orders,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    for (var order in orders) {
      if (order.orderStatus?.toUpperCase() == 'DELIVERED' &&
          order.createdDate != null) {
        final deliveryTime = order.createdDate!;
        final now = DateTime.now();

        // Only if delivered over 20 minutes ago
        if (now.difference(deliveryTime).inMinutes >= 20) {
          final orderId = order.orderNumber ?? '';
          final ratedKey = 'rated_$orderId';
          final isRated = prefs.getBool(ratedKey) ?? false;

          if (!isRated) {
            await prefs.setBool(ratedKey, true); // mark as shown
            _showRatingDialog(context: context, order: order);
            break; // show only one popup at a time
          }
        }
      }
    }
  }

  void _showRatingDialog(
      {required BuildContext context, required Content order}) {
    double rating = 0;
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
              "Rate your order from ${order.businessName ?? "restaurant"}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("How was your experience?"),
              SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          rating > index ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1.0;
                          });
                        },
                      );
                    }),
                  );
                },
              ),
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  hintText: 'Leave feedback (optional)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Later"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Send rating + feedback to your API here if needed
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Thanks for your feedback!")),
                );
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}
