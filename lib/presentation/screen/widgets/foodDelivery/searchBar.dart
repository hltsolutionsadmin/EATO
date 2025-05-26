// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AppSearchBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF223344),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.4),
//             blurRadius: 10,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: TextField(
//         decoration: InputDecoration(
//           icon: Icon(Icons.search_rounded, color: Colors.white70, size: 22),
//           hintText: "Search for pizza...",
//           hintStyle: GoogleFonts.poppins(
//             color: Colors.white60,
//             fontSize: 14,
//           ),
//           border: InputBorder.none,
//         ),
//         style: GoogleFonts.poppins(
//           color: Colors.white,
//           fontSize: 15,
//         ),
//         cursorColor: Colors.greenAccent,
//       ),
//     );
//   }
// }