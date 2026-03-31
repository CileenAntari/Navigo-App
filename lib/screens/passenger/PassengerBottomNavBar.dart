import 'package:flutter/material.dart';
import 'passengerHomeScreen.dart';
import 'schedulescreen.dart';
import 'RouteDetailsScreen.dart';
import 'ProfileScreen.dart';

class PassengerBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const PassengerBottomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
  if (index == currentIndex) return;

  Widget screen;

  switch (index) {
    case 0:
      screen = const PassengerHomeScreen();
      break;
    case 1:
      screen = const ScheduleScreen();
      break;
    case 2:
      screen = const RouteDetailsScreen();
      break;
    case 3:
      screen = const ProfileScreen();
      break;
    default:
      screen = const PassengerHomeScreen();
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
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(context, 0, Icons.home_outlined, "Home"),
              _buildItem(context, 1, Icons.directions_bus_outlined, "Schedule"),
              _buildItem(context, 2, Icons.receipt_long_outlined, "Trips"),
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
          Icon(
            icon,
            color: isActive ? Colors.green : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.green : Colors.grey,
              fontWeight:
                  isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}