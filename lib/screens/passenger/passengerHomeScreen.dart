import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'schedulescreen.dart';
import 'RouteDetailsScreen.dart';
import 'PassengerBottomNavBar.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() =>
      _PassengerHomeScreenState();
}

class _PassengerHomeScreenState
    extends State<PassengerHomeScreen> {
  GoogleMapController? _mapController;
  LatLng _initialPosition =
      const LatLng(31.7683, 35.2137);

  final TextEditingController _searchController =
      TextEditingController();

  String? _selectedLine;

  final List<String> _lines = [
    'Birzeit <-----> Ramallah'
  ];

  List<String> _filteredLines = [];

  @override
  void initState() {
    super.initState();
    _filteredLines = List.from(_lines);
    _getUserLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// ================= LOCATION =================
  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission =
          await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission ==
              LocationPermission.deniedForever) return;

      Position position =
          await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng newPosition =
          LatLng(position.latitude, position.longitude);

      setState(() {
        _initialPosition = newPosition;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(newPosition),
      );
    } catch (e) {
      debugPrint("Location error: $e");
    }
  }

  /// ================= SEARCH =================
  void _filterLines(String query) {
    setState(() {
      _filteredLines = _lines
          .where((line) =>
              line.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  /// ================= NAVIGATION =================
  void _openSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ScheduleScreen(selectedLine: _selectedLine),
      ),
    );
  }

  void _openTrips() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RouteDetailsScreen(),
      ),
    );
  }

  void _confirmRide() {
    if (_selectedLine == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please select a line")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ride Confirmed 🚀")),
    );
  }

  /// ================= BUILD =================
  @override
Widget build(BuildContext context) {
  return Scaffold(
    /// ✅ ONLY currentIndex
    bottomNavigationBar: const PassengerBottomNavBar(
      currentIndex: 0,
    ),

    body: Stack(
      children: [
        /// MAP
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 15,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (controller) => _mapController = controller,
        ),

        /// TOP UI
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          /// SEARCH
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Search or select a line",
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: _filterLines,
                          ),

                          /// DROPDOWN
                          if (_filteredLines.isNotEmpty &&
                              _searchController.text.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              constraints:
                                  const BoxConstraints(maxHeight: 150),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView.builder(
                                itemCount: _filteredLines.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(_filteredLines[index]),
                                    onTap: () {
                                      setState(() {
                                        _selectedLine =
                                            _filteredLines[index];
                                        _searchController.text =
                                            _selectedLine!;
                                        _filteredLines = [];
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// LOCATION BUTTON
                    FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.orange,
                      onPressed: _getUserLocation,
                      child: const Icon(Icons.my_location),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// CHIPS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ChoiceChip(label: Text("Now"), selected: true),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text("Schedule"),
                      selected: false,
                      onSelected: (_) => _openSchedule(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        /// BOTTOM PANEL
        Positioned(
          bottom: 80, // 👈 adjusted for nav bar height
          left: 0,
          right: 0,
          child: Container(
            height: 180,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(25)),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 10),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                Text(
                  "Line: ${_selectedLine ?? 'Not selected'}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _confirmRide,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text("Confirm Ride"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}}