import 'package:eato/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantCartBottomSheet extends StatelessWidget {
  final int totalItems;
  final VoidCallback onViewCartPressed;

  const RestaurantCartBottomSheet({
    super.key,
    required this.totalItems,
    required this.onViewCartPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.PrimaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$totalItems item${totalItems > 1 ? 's' : ''} in cart",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          TextButton(
            onPressed: onViewCartPressed,
            child: Text(
              "View Cart",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}