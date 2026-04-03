import 'package:flutter/material.dart';
import 'DriverBottomNavBar.dart';
import 'DriverLiveTripScreen.dart';

class TripDetailes extends StatelessWidget {
  final Map<String, dynamic> trip;

  const TripDetailes({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> passengers = [
      {
        "name": "Ahmad Ali",
        "pickup": "Birzeit – Main Gate",
      },
      {
        "name": "Lina Omar",
        "pickup": "Al-Bireh – Roundabout",
      },
      {
        "name": "Celine Hanna",
        "pickup": "Ramallah – Clock Square",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      bottomNavigationBar: const DriverBottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Trip Details",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Review before starting",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),

              /// SMALL TRIP INFO CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip["title"] ?? "Birzeit → Ramallah",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 0),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio:9,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 8,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _InfoItem(title: "Trip ID", value: trip["tripId"] ?? "T001"),
                        _InfoItem(title: "Vehicle", value: trip["vehicle"] ?? "Bus"),
                        _InfoItem(title: "Date", value: trip["date"] ?? "01 Apr 2026"),
                        _InfoItem(title: "Time", value: trip["time"] ?? "09:50"),
                        _InfoItem(title: "From", value: trip["from"] ?? "Birzeit"),
                        _InfoItem(title: "To", value: trip["to"] ?? "Ramallah"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Passengers",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: passengers.length,
                  itemBuilder: (context, index) {
                    return _PassengerTile(
                      passengerName: passengers[index]["name"]!,
                      pickup: passengers[index]["pickup"]!,
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DriverLiveTripScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Start Trip",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Center(
                child: Text(
                  "Starting the trip will share your live location",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$title: ",
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _PassengerTile extends StatelessWidget {
  final String passengerName;
  final String pickup;

  const _PassengerTile({
    required this.passengerName,
    required this.pickup,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  passengerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Pickup: $pickup",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}