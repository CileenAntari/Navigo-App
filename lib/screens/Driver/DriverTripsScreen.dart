import 'package:flutter/material.dart';
import 'DriverBottomNavBar.dart';
import 'TripDetailes.dart';
import 'DriverLiveTripScreen.dart';

class DriverTripsScreen extends StatefulWidget {
  const DriverTripsScreen({super.key});

  @override
  State<DriverTripsScreen> createState() => _DriverTripsScreenState();
}

class _DriverTripsScreenState extends State<DriverTripsScreen> {
  String selectedFilter = "All";

  final List<Map<String, dynamic>> trips = [
    {
      "title": "Birzeit → Ramallah (Line 12)",
      "route": "Birzeit – Main Gate\nRamallah – Al-Manara",
      "date": "2025-04-10",
      "time": "09:30",
      "status": "Upcoming",
      "tripId": "T001",
      "line": "Birzeit → Ramallah (Line 12)",
      "from": "Birzeit – Main Gate",
      "to": "Ramallah – Al-Manara",
      "duration": "20 min",
      "price": "6.00 NIS",
      "seats": "1",
      "vehicle": "Bus",
    },
    {
      "title": "Birzeit → Ramallah (Line 12)",
      "route": "Birzeit – Main Gate\nRamallah – Al-Manara",
      "date": "2026-04-01",
      "time": "09:50",
      "status": "Ongoing",
      "tripId": "T002",
      "line": "Birzeit → Ramallah (Line 12)",
      "from": "Birzeit – Main Gate",
      "to": "Ramallah – Al-Manara",
      "duration": "20 min",
      "price": "6.00 NIS",
      "seats": "1",
      "vehicle": "Bus",
    },
    {
      "title": "Birzeit → Ramallah (Line 12)",
      "route": "Birzeit – Main Gate\nRamallah – Al-Manara",
      "date": "2026-04-01",
      "time": "09:50",
      "status": "Completed",
      "tripId": "T003",
      "line": "Birzeit → Ramallah (Line 12)",
      "from": "Birzeit – Main Gate",
      "to": "Ramallah – Al-Manara",
      "duration": "20 min",
      "price": "6.00 NIS",
      "seats": "1",
      "vehicle": "Bus",
    },
    {
      "title": "Birzeit → Ramallah (Line 12)",
      "route": "Birzeit – Main Gate\nRamallah – Al-Manara",
      "date": "2026-04-01",
      "time": "09:50",
      "status": "Cancelled",
      "tripId": "T004",
      "line": "Birzeit → Ramallah (Line 12)",
      "from": "Birzeit – Main Gate",
      "to": "Ramallah – Al-Manara",
      "duration": "20 min",
      "price": "6.00 NIS",
      "seats": "1",
      "vehicle": "Bus",
    },
  ];

  List<Map<String, dynamic>> get filteredTrips {
    if (selectedFilter == "All") return trips;
    return trips.where((trip) => trip["status"] == selectedFilter).toList();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Upcoming":
        return Colors.blue;
      case "Ongoing":
        return Colors.orange;
      case "Completed":
        return Colors.green;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case "Upcoming":
        return Icons.schedule;
      case "Ongoing":
        return Icons.access_time;
      case "Completed":
        return Icons.check_circle;
      case "Cancelled":
        return Icons.cancel;
      default:
        return Icons.trip_origin;
    }
  }

  Widget buildFilterChip(String label) {
    bool isActive = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.orange.withOpacity(0.2) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.orange : Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showCompletedTripSheet(Map<String, dynamic> trip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.56,
          minChildSize: 0.45,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Trip Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          trip["status"],
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildDetailRow("Trip ID", trip["tripId"]),
                    _buildDetailRow("Line", trip["line"]),
                    _buildDetailRow("From", trip["from"]),
                    _buildDetailRow("To", trip["to"]),
                    _buildDetailRow("Date", trip["date"]),
                    _buildDetailRow("Time", trip["time"]),
                    _buildDetailRow("Duration", trip["duration"]),
                    _buildDetailRow("Price", trip["price"]),
                    _buildDetailRow("Seats", trip["seats"]),
                    _buildDetailRow("Vehicle", trip["vehicle"]),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openTripScreen(Map<String, dynamic> trip) {
    final String status = trip["status"];

    if (status == "Cancelled") {
      return;
    }

    if (status == "Ongoing") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DriverLiveTripScreen()),
      );
    } else if (status == "Upcoming") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TripDetailes(trip: trip)),
      );
    } else if (status == "Completed") {
      _showCompletedTripSheet(trip);
    }
  }

  Widget buildTripCard(Map<String, dynamic> trip) {
    Color statusColor = getStatusColor(trip["status"]);
    bool isCancelled = trip["status"] == "Cancelled";

    return GestureDetector(
      onTap: () => _openTripScreen(trip),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Opacity(
          opacity: isCancelled ? 0.75 : 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(getStatusIcon(trip["status"]), color: statusColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip["title"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip["route"],
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${trip["date"]} - ${trip["time"]}",
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trip["status"],
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const DriverBottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Trip History",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildFilterChip("All"),
                    buildFilterChip("Upcoming"),
                    buildFilterChip("Ongoing"),
                    buildFilterChip("Completed"),
                    buildFilterChip("Cancelled"),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTrips.length,
                  itemBuilder: (context, index) {
                    return buildTripCard(filteredTrips[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
