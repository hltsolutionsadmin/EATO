import 'package:eato/core/constants/colors.dart';
import 'package:eato/data/model/restaurants/guestMenuByRestaurantId/menu_content_model.dart';
import 'package:eato/presentation/screen/widgets/restaurantMenu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.item,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
   final imageUrl = (() {
      final media = item['media'];
      if (media is String) return media; // ✅ direct url from DashboardScreen
      if (media is List && media.isNotEmpty) {
        final first = media[0];
        if (first is Map && first['url'] != null) {
          return first['url'];
        } else if (first is Media && first.url != null) {
          return first.url;
        }
      }
      return null;
    })();


    final isVeg = (item['type']?.toLowerCase() ?? '') == 'veg';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey[200],
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.restaurant_menu, size: 50),
                        )
                      : const Icon(Icons.restaurant_menu, size: 50),
                ),
              ),
              Positioned(
                bottom: 6,
                left: 6,
                right: 6,
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => onQuantityChanged(quantity - 1),
                        child: const Icon(Icons.remove,
                            size: 18, color: Colors.red),
                      ),
                      Text(
                        '$quantity',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => onQuantityChanged(quantity + 1),
                        child: Icon(Icons.add,
                            size: 18, color: AppColor.PrimaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    vegNonVegIcon(isVeg),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item['name'] ?? '',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "₹${item['price'] ?? '0'}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text("4.5",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item['description'] ?? "Juicy meat on a stick. Serves 1–2.",
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
