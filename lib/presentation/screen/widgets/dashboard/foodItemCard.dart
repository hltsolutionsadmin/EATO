import 'package:eato/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FoodItemCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String restaurantName)? onRestaurantTap;
  final Function()? onReorder;
  final Function()? onViewDetails;

  const FoodItemCard({
    super.key, 
    required this.data, 
    this.onRestaurantTap,
    this.onReorder,
    this.onViewDetails,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onRestaurantTap != null) {
          onRestaurantTap!(data["Restaurant"]);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColor.SecondaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                data["image"],
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data["Restaurant"],
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (data["status"] != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(data["status"]).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          data["status"],
                          style: GoogleFonts.poppins(
                            color: _getStatusColor(data["status"]),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        data["date"] != null 
                          ? DateFormat('MMM dd, yyyy').format(data["date"])
                          : data["time"] ?? "",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      Spacer(),
                      Text(
                        '${data["Items"]} ${int.tryParse(data["Items"]) == 1 ? 'item' : 'items'}',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      if (data["rating"] != null) _buildRatingStars(data["rating"]),
                      Spacer(),
                      Text(
                        '\$${data["itemPrice"] ?? data["price"]}',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ],
                  ),
                  if (onReorder != null || onViewDetails != null)
                  SizedBox(height: 16),
                  if (onReorder != null || onViewDetails != null)
                  Row(
                    children: [
                      if (onReorder != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.repeat, size: 20, color: Colors.black),
                          label: Text('Reorder',
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                          onPressed: onReorder,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                      ),
                      if (onReorder != null && onViewDetails != null)
                      SizedBox(width: 12),
                      if (onViewDetails != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.description, size: 20, color: Colors.white),
                          label: Text('Details',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                          onPressed: onViewDetails,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.PrimaryColor,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}