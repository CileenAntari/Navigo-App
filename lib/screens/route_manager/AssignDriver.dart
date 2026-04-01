import 'package:flutter/material.dart';
import 'RouteManagerNavBar.dart';

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
    backgroundColor: Colors.grey[100],

    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Assignments",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Text(
              "Assign drivers & vehicles",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// FILTERS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                filterChip("All"),
                filterChip("Available"),
                filterChip("On Trip"),
                filterChip("Offline"),
              ],
            ),

            const SizedBox(height: 20),

            /// LIST
            Expanded(
              child: ListView.builder(
                itemCount: filteredDrivers.length,
                itemBuilder: (context, index) {
                  final driver = filteredDrivers[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(driver["name"]!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(driver["vehicle"]!),
                            const SizedBox(height: 6),
                            Text("Assigned: ${driver["line"]}"),
                          ],
                        ),
                        Column(
                          children: [
                            statusChip(driver["status"]!),
                            const SizedBox(height: 8),
                            if (driver["status"] == "Available")
                              // 🔹 BEAUTIFUL ASSIGN BUTTON
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 4,
                                  shadowColor: Colors.orange.withOpacity(0.5),
                                ),
                                child: const Text(
                                  "Assign",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),

    /// ✅ CORRECT NAVBAR
    bottomNavigationBar: const RouteManagerNavBar(
      currentIndex: 1,
    ),
  );
}

  Widget filterChip(String label) {
    final isSelected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label),
      ),
    );
  }

  Widget statusChip(String status) {
    Color color;

    switch (status) {
      case "Available":
        color = Colors.green;
        break;
      case "On Trip":
        color = Colors.blue;
        break;
      case "Offline":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: color),
      ),
    );
  }
}