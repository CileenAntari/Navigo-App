import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'PassengerBottomNavBar.dart';
import 'PassengerHomeScreen.dart';

class RouteDetailsScreen extends StatelessWidget {
  const RouteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavigoColors.backgroundLight,

      /// ✅ NAV BAR
      bottomNavigationBar: const PassengerBottomNavBar(
        currentIndex: 1, // adjust index according to your nav logic
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Top Bar with Tracking Icon
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    /// Title
                    Text(
                      "Route Details",
                      style: NavigoTextStyles.titleLarge,
                    ),

                    /// Tracking Icon
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const PassengerHomeScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration:
                            NavigoDecorations.kTopBarBackButton,
                        child: const Icon(
                          Icons.location_on,
                          color: NavigoColors.primaryOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// Route Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Birzeit ↔ Ramallah (Line 12)",
                      style: NavigoTextStyles.titleSmall,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "Average trip: 20 min • Price: 6.00 NIS",
                      style: NavigoTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Stops Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Stops",
                  style: NavigoTextStyles.titleSmall,
                ),
              ),

              const SizedBox(height: 10),

              /// Stops Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: NavigoDecorations.kCardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("1. Birzeit – Main Gate"),
                      SizedBox(height: 8),
                      Text("2. Al-Bireh – Roundabout"),
                      SizedBox(height: 8),
                      Text("3. Ramallah – Al-Manara"),
                      SizedBox(height: 8),
                      Text("4. Ramallah – Bus Station"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Next departures
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Next departures",
                  style: NavigoTextStyles.titleSmall,
                ),
              ),

              const SizedBox(height: 10),

              /// Departure Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: NavigoDecorations.kCardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "09:50",
                            style: NavigoTextStyles.titleSmall.copyWith(
                              color: NavigoColors.accentGreen,
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Text("Available"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Every 10–15 minutes",
                        style: NavigoTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}