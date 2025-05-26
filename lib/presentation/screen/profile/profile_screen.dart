import 'package:eato/components/custom_topbar.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Account", showBackButton: false),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.PrimaryColor, AppColor.White],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildProfileCard(),
                const SizedBox(height: 8),
                _buildPremiumCard(),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      _buildOptionsList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.PrimaryColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.PrimaryColor.withOpacity(0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          "John Doe",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColor.White,
          ),
        ),
        subtitle: const Text(
          "+91 9876543210",
          style: TextStyle(color: Colors.white70),
        ),
        trailing: Icon(Icons.edit, color: AppColor.White),
        onTap: () {},
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.PrimaryColor.withOpacity(0.9),
            AppColor.PrimaryColor
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.star, color: Colors.white, size: 36),
        title: const Text(
          "Eato Premium",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          "Enjoy Free Deliveries & More",
          style: TextStyle(color: Colors.white70),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColor.PrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {},
          child: const Text("Join Now"),
        ),
      ),
    );
  }

  Widget _buildOptionsList() {
    final options = [
      _Option(Icons.shopping_bag, "Orders"),
      _Option(Icons.payment, "Payments"),
      _Option(Icons.location_on, "Saved Addresses"),
      _Option(Icons.local_offer, "Offers"),
      _Option(Icons.support_agent, "Help Center"),
      _Option(Icons.logout, "Logout"),
    ];

    return Column(
      children: options.map((opt) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: AppColor.PrimaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.PrimaryColor.withOpacity(0.3)),
          ),
          child: ListTile(
            leading: Icon(opt.icon, color: AppColor.PrimaryColor),
            title: Text(
              opt.title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing:
                Icon(Icons.arrow_forward_ios, size: 16, color: AppColor.PrimaryColor),
            onTap: () {},
          ),
        );
      }).toList(),
    );
  }
}

class _Option {
  final IconData icon;
  final String title;
  _Option(this.icon, this.title);
}
