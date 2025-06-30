import 'package:eato/core/constants/colors.dart';
import 'package:eato/core/utils/push_notication_services.dart';
import 'package:eato/presentation/screen/authentication/login_screen.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/update/update_current_customer_cubit.dart';
import 'package:eato/presentation/screen/dashboard/dashboard_screen.dart';
import 'package:eato/presentation/screen/order/orderHistory_Screen.dart';
import 'package:eato/presentation/screen/profile/profile_screen.dart';
import 'package:eato/presentation/screen/promotions/promotions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomTab extends StatefulWidget {
  final bool isGuest;

  const BottomTab({super.key, this.isGuest = false});

  @override
  _BottomTabState createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  int _selectedIndex = 0;
  final NotificationServices _notificationServices = NotificationServices();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _initNotifications();

    _pages = [
      DashboardScreen(isGuest: widget.isGuest),
      PromotionsScreen(),
      ProfileScreen(isGuest: widget.isGuest),
    ];
  }

Future<void> _initNotifications() async {
  await _notificationServices.requestNotificationPermissions();
  await _notificationServices.forgroundMessage();
  await _notificationServices.firebaseInit(context);
  await _notificationServices.setupInteractMessage(context);
  await _notificationServices.isRefreshToken();

  _notificationServices.getDeviceToken().then((fcmToken) {
    if (fcmToken != null) {
      print("FCM Token: $fcmToken");
      final payload = {
        'fullName': '',
        'email': '',
        'eato': true,
        "fcmToken" : fcmToken,
      };
      context.read<UpdateCurrentCustomerCubit>().updateCustomer(payload, context);
    }
  });
}

  void _onItemTapped(int index) {
    if (widget.isGuest && (index == 1 || index == 2)) {
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline_rounded,
                  size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                "Login Required",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.PrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Please login to access this feature and track your orders.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.PrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Login Now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Maybe Later",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Restaurants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor.PrimaryColor,
        unselectedItemColor: AppColor.Black,
        backgroundColor: AppColor.White,
      ),
    );
  }
}
