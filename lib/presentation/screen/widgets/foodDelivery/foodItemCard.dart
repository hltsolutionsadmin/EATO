import 'package:eato/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodItemCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String restaurantName)? onRestaurantTap;

  const FoodItemCard({super.key, required this.data, this.onRestaurantTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onRestaurantTap != null) {
          onRestaurantTap!(data["Restaurant"]);
        }
      },
      child: Container(
        height: 130,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF1A2B3C), Color(0xFF0F1A2C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            // Image Section
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Hero(
                tag: data["image"],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    data["image"],
                    height: 110,
                    width: 110,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Text Section
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 12.0, top: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data["Restaurant"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: AppColor.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data["Items"],
                      style: GoogleFonts.poppins(
                        color: Colors.grey[400],
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      data["price"],
                      style: GoogleFonts.poppins(
                        color: Colors.grey[400],
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data["itemPrice"],
                          style: GoogleFonts.poppins(
                            color: Colors.orange[200],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          data["time"],
                          style: GoogleFonts.poppins(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
