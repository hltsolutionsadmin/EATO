import 'package:eato/core/constants/colors.dart';
import 'package:eato/core/utils/push_notication_services.dart';
import 'package:eato/presentation/screen/authentication/login_screen.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/update/update_current_customer_cubit.dart';
import 'package:eato/presentation/screen/dashboard/dashboard_screen.dart';
import 'package:eato/presentation/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BottomTab extends StatefulWidget {
  final bool isGuest;

  const BottomTab({super.key, this.isGuest = false});

  @override
  State<BottomTab> createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  int _selectedIndex = 0;
  final NotificationServices _notificationServices = NotificationServices();

  late final List<_TabItem> tabItems;

  @override
  void initState() {
    super.initState();
    _initNotifications();

    tabItems = [
      _TabItem(
        label: 'Restaurants',
        icon: Icons.fastfood_rounded,
        screen: DashboardScreen(isGuest: widget.isGuest),
      ),
      // _TabItem(
      //   label: 'Offers',
      //   icon: Icons.local_offer_outlined,
      //   screen: PromotionsScreen(),
      // ),
      _TabItem(
        label: 'Profile',
        icon: Icons.person_outline,
        screen: ProfileScreen(isGuest: widget.isGuest),
      ),
    ];
  }

  

  Future<void> _initNotifications() async {
    await _notificationServices.requestNotificationPermissions();
    await _notificationServices.forgroundMessage();

    if (!mounted) return;
    await _notificationServices.firebaseInit(context);

    if (!mounted) return;
    await _notificationServices.setupInteractMessage(context);

    if (!mounted) return;
    await _notificationServices.isRefreshToken();

    _notificationServices.getDeviceToken().then((fcmToken) {
      if (!mounted) return; 
      if (fcmToken != null) {
        final payload = {
          'fullName': '',
          'email': '',
          'eato': true,
          "fcmToken": fcmToken,
        };
        context
            .read<UpdateCurrentCustomerCubit>()
            .updateCustomer(payload, context);
      }
    });
  }


  void _onItemTapped(int index) {
    final selectedTab = tabItems[index];
    if (widget.isGuest &&
        (selectedTab.label == 'Offers' || selectedTab.label == 'Profile')) {
      _showLoginPromptSheet();
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void _showLoginPromptSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🍽️ Custom food-style icon or image (you can use AssetImage too)
                const Icon(
                  Icons.fastfood_rounded,
                  size: 64,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(height: 16),
                Text(
                  "Login Required",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColor.PrimaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "To continue enjoying delicious food and offers, please login to your account.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    icon: const Icon(Icons.lock_open),
                    label: const Text("Login Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.PrimaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Maybe Later",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabItems[_selectedIndex].screen,
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabItems.length, (index) {
              final tab = tabItems[index];
              final isSelected = index == _selectedIndex;
              return GestureDetector(
                onTap: () => _onItemTapped(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.PrimaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(tab.icon,
                          size: 24,
                          color: isSelected
                              ? AppColor.PrimaryColor
                              : Colors.grey[600]),
                      const SizedBox(height: 4),
                      Text(
                        tab.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? AppColor.PrimaryColor
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  final Widget screen;

  _TabItem({
    required this.label,
    required this.icon,
    required this.screen,
  });
}
