import 'package:eato/core/constants/img_const.dart';
import 'package:eato/presentation/screen/dashboard/foodCatagoryItems_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodCategoryIcons extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {"image": biriyani, "label": "Biryani"},
    {"image": sandwich, "label": "Sandwich"},
    {"image": rolls, "label": "Rolls"},
    {"image": pizza, "label": "Pizza"},
    {"image": dessert, "label": "Dessert"},
  ];

  final Map<String, List<Map<String, dynamic>>> categoryItems = {
  "Biryani": [
    {
      "name": "Hyderabadi Biryani",
      "price": "₹ 240",
      "description": "Spicy and flavorful biryani.",
      "itemImage": biriyani,
    },
    {
      "name": "Chicken Dum Biryani",
      "price": "₹ 280",
      "description": "Slow-cooked traditional dum biryani.",
      "itemImage": biriyani,
    },
  ],
  "Pizza": [
    {
      "name": "Margherita Pizza",
      "price": "₹ 200",
      "description": "Classic cheese pizza with basil.",
      "itemImage": pizza,
    },
    {
      "name": "Pepperoni Pizza",
      "price": "₹ 250",
      "description": "Pepperoni loaded pizza.",
      "itemImage": pizza,
    },
  ],
  "Rolls": [
    {
      "name": "Chicken Kathi Roll",
      "price": "₹ 150",
      "description": "Spicy chicken wrapped in soft bread.",
      "itemImage": rolls,
    },
  ],
  "Sandwich": [
    {
      "name": "Grilled Cheese Sandwich",
      "price": "₹ 120",
      "description": "Melty cheese sandwich.",
      "itemImage": sandwich,
    },
  ],
  "Dessert": [
    {
      "name": "Chocolate Cake",
      "price": "₹ 180",
      "description": "Rich chocolate layered cake.",
      "itemImage": dessert,
    },
  ],
};

   FoodCategoryIcons({super.key});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryItemScreen(
                    categoryName: category["label"],
                    items: categoryItems[category["label"]] ?? [],
                  ),
                ),
              );
            },
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    category["image"],
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category["label"],
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
