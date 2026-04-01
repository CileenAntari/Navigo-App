import 'package:flutter/material.dart';
import 'RouteManagerNavBar.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> allReports = [
    {
      "from": "Lara Shaltal",
      "date": "28 Mar",
      "message":
          "The bus was overcrowded and the driver skipped my stop. Please look into this issue."
    },
    {
      "from": "Omar Saleh",
      "date": "10 Mar",
      "message":
          "I faced a problem with the bus timing today. The trip was delayed for more than 30 minutes."
    },
    {
      "from": "Ahmad Khaled",
      "date": "28 Jan",
      "message":
          "I would like to report that the bus arrived very late today and the driver did not follow the scheduled route."
    },
  ];

  List<bool> selected = [];

  @override
  void initState() {
    super.initState();
    selected = List<bool>.filled(allReports.length, false);
  }

  List<Map<String, String>> get filteredReports {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) return allReports;
    return allReports.where((report) {
      return report["from"]!.toLowerCase().contains(query) ||
          report["date"]!.toLowerCase().contains(query);
    }).toList();
  }

  void sendToAdmin() {
    final selectedReports = <Map<String, String>>[];
    for (int i = 0; i < filteredReports.length; i++) {
      if (selected[i]) {
        selectedReports.add(filteredReports[i]);
      }
    }

    if (selectedReports.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No reports selected!")),
      );
    } else {
      for (var report in selectedReports) {
        print("Sent report from ${report["from"]} to admin.");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reports sent to admin successfully!")),
      );

      // Clear selection
      setState(() {
        selected = List<bool>.filled(allReports.length, false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final reports = filteredReports;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Reports",
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
              const SizedBox(height: 20),

              /// Search Box
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search (Date/Name)",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (_) {
                  setState(() {});
                },
              ),

              const SizedBox(height: 20),

              /// Reports List
              Expanded(
                child: ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: selected[index],
                            onChanged: (value) {
                              setState(() {
                                selected[index] = value!;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "From: ${report["from"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(report["message"]!),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              report["date"]!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// Send Button
              ElevatedButton(
                onPressed: sendToAdmin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Send to Admin"),
              ),
            ],
          ),
        ),
      ),

      /// Navigation Bar
      bottomNavigationBar: const RouteManagerNavBar(
        currentIndex: 2, // Reports tab
      ),
    );
  }
}