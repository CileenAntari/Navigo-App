import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'DriverBottomNavBar.dart';
import 'DriverRequestsScreen.dart';
import 'DriverTripsScreen.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavigoColors.backgroundLight,
      bottomNavigationBar: const DriverBottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NavigoDecorations.homeStyleTitleBar(
                title: "Driver Home",
                subtitle: "Track your line and manage requests",
                avatar: CircleAvatar(
                  radius: 20,
                  backgroundColor: NavigoColors.surfaceWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Line 12", style: NavigoTextStyles.bodySmall),
                      Text(
                        "Vehicle: Microbus",
                        style: NavigoTextStyles.bodySmall,
                      ),
                      Text("Plate: 7-12345", style: NavigoTextStyles.bodySmall),
                    ],
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: NavigoColors.successLight,
                    child: const Icon(
                      Icons.directions_bus,
                      color: NavigoColors.accentGreen,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: NavigoDecorations.kLightCardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today's Summary",
                          style: NavigoTextStyles.titleSmall,
                        ),
                        NavigoDecorations.statusChip(
                          label: "Available",
                          color: NavigoColors.accentGreen,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text("Trips: 8", style: NavigoTextStyles.bodyMedium),
                    const Text(
                      "Earnings: 54 NIS",
                      style: NavigoTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: NavigoSizes.buttonHeight,
                child: ElevatedButton(
                  style: NavigoDecorations.kPrimaryButtonLargeStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DriverTripsScreen(),
                      ),
                    );
                  },
                  child: const Text("Trip Details"),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: NavigoSizes.buttonHeight,
                child: ElevatedButton(
                  style: NavigoDecorations.kPrimaryButtonLargeStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DriverRequestsScreen(),
                      ),
                    );
                  },
                  child: const Text("Open Requests"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
