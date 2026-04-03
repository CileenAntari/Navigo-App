import 'package:flutter/material.dart';
import '../Driver/DriverProfileScreen.dart';
import '../Driver/DriverRequestsScreen.dart';
import '../Driver/DriverTripsScreen.dart';
import 'DriverHomeScreen.dart';

class DriverBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const DriverBottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget screen = const DriverHomeScreen();

    switch (index) {
      case 0:
        screen = const DriverHomeScreen();
        break;
      case 1:
        screen = const DriverTripsScreen();
        break;
      case 2:
        screen = const DriverRequestsScreen();
        break;
      case 3:
        screen = const DriverProfileScreen();
        break;
      default:
        screen = const DriverHomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(context, 0, Icons.home_outlined, "Home"),
              _buildItem(context, 1, Icons.receipt_long_outlined, "Trips"),
              _buildItem(context, 2, Icons.notifications_none, "Requests"),
              _buildItem(context, 3, Icons.person_outline, "Profile"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? Colors.green : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.green : Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
