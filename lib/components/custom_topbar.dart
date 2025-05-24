import 'package:eato/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showBackButton = true, // default to true
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.PrimaryColor,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColor.White,
                size: 24,
              ),
              onPressed: onBackPressed,
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: AppColor.White,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
