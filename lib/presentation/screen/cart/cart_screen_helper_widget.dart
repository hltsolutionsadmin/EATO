import 'package:flutter/material.dart';

Widget BuildPriceRow(String label, double amount, {bool isBold = false}) {
    final textStyle = TextStyle(
      fontSize: isBold ? 18 : 16,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text("₹${amount.toStringAsFixed(2)}", style: textStyle),
        ],
      ),
    );
  }
  
  