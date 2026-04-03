import 'package:flutter/material.dart';
import 'DriverBottomNavBar.dart';

class DriverRequestsScreen extends StatefulWidget {
  const DriverRequestsScreen({super.key});

  @override
  State<DriverRequestsScreen> createState() => _DriverRequestsScreenState();
}

class _DriverRequestsScreenState extends State<DriverRequestsScreen> {
  String searchText = "";
  bool nearbyOnly = false;

  late List<Map<String, dynamic>> requests;

  @override
  void initState() {
    super.initState();
    requests = [
      {
        "passenger": "Cileen",
        "route": "Birzeit → Ramallah",
        "pickup": "Birzeit – Main Gate",
        "dropoff": "Ramallah – Al-Manara",
        "isNearby": true,
      },
      {
        "passenger": "Ahmad",
        "route": "Al-Bireh → Ramallah",
        "pickup": "Al-Bireh – Roundabout",
        "dropoff": "Ramallah – Al-Manara",
        "isNearby": true,
      },
      {
        "passenger": "Rawan",
        "route": "Birzeit → Nablus",
        "pickup": "Birzeit – Campus Gate",
        "dropoff": "Nablus – City Center",
        "isNearby": false,
      },
    ];
  }

  List<Map<String, dynamic>> get filteredRequests {
    return requests.where((request) {
      final passenger = request["passenger"].toString().toLowerCase();
      final pickup = request["pickup"].toString().toLowerCase();
      final dropoff = request["dropoff"].toString().toLowerCase();
      final route = request["route"].toString().toLowerCase();
      final query = searchText.toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          passenger.contains(query) ||
          pickup.contains(query) ||
          dropoff.contains(query) ||
          route.contains(query);

      final matchesNearby = !nearbyOnly || request["isNearby"] == true;

      return matchesSearch && matchesNearby;
    }).toList();
  }

  void _removeRequest(Map<String, dynamic> request, String actionText) {
    setState(() {
      requests.remove(request);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Request $actionText")));
  }

  Widget buildRequestCard(Map<String, dynamic> request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Passenger: ${request["passenger"]}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            request["route"],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "Pickup: ${request["pickup"]}",
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 4),
          Text(
            "Drop-off: ${request["dropoff"]}",
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _removeRequest(request, "Declined");
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Decline",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _removeRequest(request, "Accepted");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Accept",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      bottomNavigationBar: const DriverBottomNavBar(currentIndex: 2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Trip Requests",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              /// SEARCH + NEARBY FILTER
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search passenger, pickup, route...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        nearbyOnly = !nearbyOnly;
                      });
                    },
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: nearbyOnly
                            ? Colors.orange.withOpacity(0.15)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: nearbyOnly
                              ? Colors.orange
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.near_me,
                            size: 18,
                            color: nearbyOnly ? Colors.orange : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Nearby",
                            style: TextStyle(
                              color: nearbyOnly ? Colors.orange : Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: filteredRequests.isEmpty
                    ? const Center(
                        child: Text(
                          "No requests found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredRequests.length,
                        itemBuilder: (context, index) {
                          return buildRequestCard(filteredRequests[index]);
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
