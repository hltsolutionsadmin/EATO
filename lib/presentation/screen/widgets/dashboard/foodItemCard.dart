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
          index < rating.floor()
              ? Icons.star_rounded
              : Icons.star_border_rounded,
          color: Colors.amber,
          size: 18,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onRestaurantTap?.call(data["Restaurant"]),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 12, right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: Stack(
                children: [
                  Image.asset(
                    data["image"],
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant & Status Row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data["Restaurant"],
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (data["status"] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(data["status"])
                                .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            data["status"],
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: _getStatusColor(data["status"]),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Date, Items
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        data["date"] != null
                            ? DateFormat('MMM dd, yyyy').format(data["date"])
                            : data["time"] ?? "",
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.grey[700]),
                      ),
                      const Spacer(),
                      Text(
                        '${data["Items"]} ${int.tryParse(data["Items"]) == 1 ? 'item' : 'items'}',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.grey[700]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Rating & Price
                  Row(
                    children: [
                      if (data["rating"] != null)
                        _buildRatingStars(data["rating"]),
                      const Spacer(),
                      Text(
                        '₹${data["itemPrice"] ?? data["price"]}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.PrimaryColor,
                        ),
                      ),
                    ],
                  ),

                  // Divider
                  if (onReorder != null || onViewDetails != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(thickness: 0.8, color: Colors.grey[200]),
                    ),

                  // Buttons
                  if (onReorder != null || onViewDetails != null)
                    Row(
                      children: [
                        if (onReorder != null)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: onReorder,
                              icon: const Icon(Icons.refresh,
                                  size: 18, color: Colors.black),
                              label: Text("Reorder",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  )),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                        if (onReorder != null && onViewDetails != null)
                          const SizedBox(width: 12),
                        if (onViewDetails != null)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: onViewDetails,
                              icon: const Icon(Icons.receipt_long,
                                  size: 18, color: Colors.white),
                              label: Text("Details",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  )),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: AppColor.PrimaryColor,
                                elevation: 2,
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
