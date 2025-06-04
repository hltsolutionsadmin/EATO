import 'package:eato/components/custom_topbar.dart';
import 'package:eato/core/constants/colors.dart';
import 'package:eato/presentation/screen/widgets/logout.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.White,
      appBar: CustomAppBar(title: "My Profile", showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfile(),
            const SizedBox(height: 24),
            _buildMembershipCard(),
            const SizedBox(height: 24),
            Text(
              "Account Settings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColor.PrimaryColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsList(context),
            const SizedBox(height: 24),
            Text(
              "More",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColor.PrimaryColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildMoreOptionsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.PrimaryColor.withOpacity(0.1),
            border: Border.all(
              color: AppColor.PrimaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.person,
            size: 40,
            color: AppColor.PrimaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "John Doe",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.PrimaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "+91 9876543210",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: AppColor.PrimaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.PrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.PrimaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.star,
            color: AppColor.PrimaryColor,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Eato Premium",
                  style: TextStyle(
                    color: AppColor.PrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Enjoy Free Deliveries & More Benefits",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.PrimaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {},
            child: const Text("Upgrade"),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    final settings = [
      _Option(Icons.shopping_bag_outlined, "My Orders"),
      _Option(Icons.payment_outlined, "Payment Methods"),
      _Option(Icons.location_on_outlined, "Saved Addresses"),
      _Option(Icons.favorite_border, "Favorites"),
    ];

    return Column(
      children: settings.map((opt) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.PrimaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(opt.icon, color: AppColor.PrimaryColor),
            ),
            title: Text(
              opt.title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: AppColor.PrimaryColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            onTap: opt.onTap ?? () {},
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMoreOptionsList(BuildContext context) {
    final options = [
      _Option(Icons.local_offer_outlined, "Offers & Promotions"),
      _Option(Icons.help_outline, "Help Center"),
      _Option(Icons.info_outline, "About Us"),
      _Option(
        Icons.logout,
        "Logout",
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return const LogOutCnfrmBottomSheet();
            },
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          );
        },
      ),
    ];

    return Column(
      children: options.map((opt) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.PrimaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(opt.icon, color: AppColor.PrimaryColor),
            ),
            title: Text(
              opt.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: opt.title == "Logout" ? Colors.red : null,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: opt.title == "Logout" ? Colors.red : AppColor.PrimaryColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            onTap: opt.onTap ?? () {},
          ),
        );
      }).toList(),
    );
  }
}

class _Option {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  
  _Option(this.icon, this.title, {this.onTap});
}