import 'package:flutter/material.dart';
import 'package:navigo/screens/route_manager/RouteSchedule.dart';
import 'RouteManagerNavBar.dart';
import 'package:navigo/theme/app_theme.dart';

class AssignDriver extends StatefulWidget {
  const AssignDriver({super.key});

  @override
  State<AssignDriver> createState() => _AssignDriverState();
}

class _AssignDriverState extends State<AssignDriver> {
  String selectedFilter = "All";

  final List<Map<String, String>> drivers = [
    {
      "name": "Ahmad Saleh",
      "vehicle": "Microbus - 7-12345",
      "line": "Line 12",
      "status": "Available",
    },
    {
      "name": "Rawan A.",
      "vehicle": "Bus - T-55221",
      "line": "Line 12",
      "status": "On Trip",
    },
    {
      "name": "Omar K.",
      "vehicle": "Taxi - g-8890f",
      "line": "Line 12",
      "status": "Offline",
    },
    {
      "name": "Lina M.",
      "vehicle": "Bus - 9-88888",
      "line": "Line 15",
      "status": "Available",
    },
  ];

  List<Map<String, String>> get filteredDrivers {
    if (selectedFilter == "All") return drivers;
    return drivers.where((d) => d["status"] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavigoColors.backgroundLight,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOP BAR (back arrow + logo)
            NavigoDecorations.topBar(
              onBack: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RouteSchedule()),
              ),
            ),

            /// TITLE + SUBTITLE
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NavigoSizes.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Assignments", style: NavigoTextStyles.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    "Assign drivers & vehicles",
                    style: NavigoTextStyles.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(height: NavigoSizes.sectionGap),

            /// FILTERS
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NavigoSizes.screenPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["All", "Available", "On Trip", "Offline"]
                    .map(
                      (label) => NavigoDecorations.selectorChip(
                        label: label,
                        selected: selectedFilter == label,
                        onTap: () => setState(() => selectedFilter = label),
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: NavigoSizes.sectionGap),

            /// LIST
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: NavigoSizes.screenPadding,
                ),
                child: ListView.builder(
                  itemCount: filteredDrivers.length,
                  itemBuilder: (context, index) {
                    final driver = filteredDrivers[index];

                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: NavigoSizes.itemGap,
                      ),
                      padding: const EdgeInsets.all(NavigoSizes.cardPadding),
                      decoration: NavigoDecorations.kCardDecoration,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// LEFT — Driver info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driver["name"]!,
                                style: NavigoTextStyles.titleSmall,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                driver["vehicle"]!,
                                style: NavigoTextStyles.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Assigned: ${driver["line"]}",
                                style: NavigoTextStyles.label,
                              ),
                            ],
                          ),

                          /// RIGHT — Status + action
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _statusChip(driver["status"]!),
                              if (driver["status"] == "Available") ...[
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: NavigoDecorations
                                      .kPrimaryButtonLargeStyle
                                      .copyWith(
                                        padding: const WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 10,
                                          ),
                                        ),
                                        elevation: const WidgetStatePropertyAll(
                                          4,
                                        ),
                                        shadowColor: WidgetStatePropertyAll(
                                          NavigoColors.primaryOrange
                                              .withOpacity(0.4),
                                        ),
                                      ),
                                  child: const Text(
                                    "Assign",
                                    style: NavigoTextStyles.button,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const RouteManagerNavBar(currentIndex: 1),
    );
  }

  Widget _statusChip(String status) {
    final Color color;

    switch (status) {
      case "Available":
        color = NavigoColors.accentGreen;
        break;
      case "On Trip":
        color = NavigoColors.accentBlue;
        break;
      case "Offline":
        color = NavigoColors.accentRed;
        break;
      default:
        color = NavigoColors.textMuted;
    }

    return NavigoDecorations.statusChip(label: status, color: color);
  }
}
