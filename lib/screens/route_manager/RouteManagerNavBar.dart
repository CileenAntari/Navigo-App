import 'package:flutter/material.dart';
import 'ManagerProfile.dart';
import 'Reports.dart';
import 'RouteSchedule.dart';
import 'AssignDriver.dart';

class RouteManagerNavBar extends StatelessWidget {
  final int currentIndex;

  const RouteManagerNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget screen;

    switch (index) {
      case 0:
        screen = const RouteSchedule();
        break;
      case 1:
        screen = const AssignDriver();
        break;
      case 2:
        screen = const Reports();
        break;
      case 3:
        screen = const ManagerProfile();
        break;
      default:
        screen = const RouteSchedule();
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
              _buildItem(context, 0, Icons.schedule, "Schedule"),
              _buildItem(context, 1, Icons.assignment, "Assign"),
              _buildItem(context, 2, Icons.bar_chart, "Reports"),
              _buildItem(context, 3, Icons.person, "Profile"),
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
