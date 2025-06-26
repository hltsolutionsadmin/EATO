import 'package:eato/core/constants/colors.dart';
import 'package:eato/core/utils/push_notication_services.dart';
import 'package:eato/presentation/cubit/authentication/currentcustomer/update/update_current_customer_cubit.dart';
import 'package:eato/presentation/screen/dashboard/dashboard_screen.dart';
import 'package:eato/presentation/screen/order/orderHistory_Screen.dart';
import 'package:eato/presentation/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomTab extends StatefulWidget {
  const BottomTab({super.key});

  @override
  _BottomTabState createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  int _selectedIndex = 0;
  final NotificationServices _notificationServices = NotificationServices();

  final List<Widget> _pages = [
    DashboardScreen(),
OrderHistoryScreen(),   
    ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    _initNotifications();
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
    setState(() {
      _selectedIndex = index;
    });
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
            icon: Icon(Icons.history),
            label: 'Reorder',
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
