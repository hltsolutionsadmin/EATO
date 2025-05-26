import 'package:eato/core/constants/colors.dart';
import 'package:eato/presentation/screen/dashboard/foodDelivery_screen.dart';
import 'package:eato/presentation/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomTab extends StatefulWidget {
  const BottomTab({super.key});

  @override
  _BottomTabState createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    FoodDeliveryScreen(),
    Center(child: Text('Reorder Screen', style: TextStyle(fontSize: 24))),
    ProfileScreen()
  ];

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
