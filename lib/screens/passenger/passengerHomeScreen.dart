import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../theme/app_theme.dart';
import 'schedulescreen.dart';
import 'PassengerBottomNavBar.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  GoogleMapController? _mapController;
  LatLng _initialPosition = const LatLng(31.7683, 35.2137);

  final TextEditingController _searchController = TextEditingController();

  String? _selectedLine;
  bool _isLocating = false;

  final List<String> _lines = ['Birzeit <-----> Ramallah'];
  List<String> _filteredLines = [];

  @override
  void initState() {
    super.initState();
    _filteredLines = List.from(_lines);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserLocation();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // ================= LOCATION =================
  Future<void> _getUserLocation() async {
    if (_isLocating) return;
    setState(() => _isLocating = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      Position position =
          await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception("Location timeout"),
          );

      if (!mounted) return;

      final newPosition = LatLng(position.latitude, position.longitude);
      setState(() => _initialPosition = newPosition);
      _mapController?.animateCamera(CameraUpdate.newLatLng(newPosition));
    } catch (e) {
      debugPrint("Location error: $e");
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  // ================= SEARCH =================
  void _filterLines(String query) {
    setState(() {
      _filteredLines = _lines
          .where((line) => line.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // ================= NAVIGATION =================
  void _openSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScheduleScreen(selectedLine: _selectedLine),
      ),
    );
  }

  void _confirmRide() {
    if (_selectedLine == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a line")));
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Ride Confirmed 🚀")));
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavigoColors.backgroundLight,
      bottomNavigationBar: const PassengerBottomNavBar(currentIndex: 0),
      body: Stack(
        children: [
          // ── MAP ──────────────────────────────────────────
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

          // ── TOP UI ───────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ── HEADER: Title + Logo ──────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center, // ← add this
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:
                            MainAxisAlignment.center, // ← add this
                        children: [
                          Text("Navigo", style: NavigoTextStyles.titleLarge),
                          Text(
                            "Where would you like to go?",
                            style: NavigoTextStyles.bodySmall,
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
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
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── SEARCH BAR + LOCATION BUTTON ──────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.black),
                              decoration: NavigoDecorations.kInputDecoration
                                  .copyWith(
                                    hintText: "Search or select a line",
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: NavigoColors.primaryOrange,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: NavigoColors.primaryOrange,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                              onChanged: _filterLines,
                            ),

                            if (_filteredLines.isNotEmpty &&
                                _searchController.text.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                constraints: const BoxConstraints(
                                  maxHeight: 150,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: NavigoColors.lightorange,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: NavigoColors.primaryOrange
                                        .withOpacity(0.4),
                                  ),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _filteredLines.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: const Icon(
                                        Icons.directions_bus,
                                        color: NavigoColors.primaryOrange,
                                        size: 20,
                                      ),
                                      title: Text(
                                        _filteredLines[index],
                                        style: NavigoTextStyles.bodyMedium,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _selectedLine = _filteredLines[index];
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

                      _isLocating
                          ? Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: NavigoColors.primaryOrange,
                                shape: BoxShape.circle,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              ),
                            )
                          : FloatingActionButton.small(
                              backgroundColor: NavigoColors.primaryOrange,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              onPressed: _getUserLocation,
                              child: const Icon(Icons.my_location),
                            ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildChip(label: "Now", selected: true),
                      const SizedBox(width: 10),
                      _buildChip(
                        label: "Schedule",
                        selected: false,
                        onTap: _openSchedule,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── BOTTOM PANEL ─────────────────────────────────
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: NavigoColors.lightorange,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 16),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      const Icon(
                        Icons.directions_bus,
                        color: NavigoColors.primaryOrange,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Line: ${_selectedLine ?? 'Not selected'}",
                        style: NavigoTextStyles.bodyMedium.copyWith(
                          color: NavigoColors.textGray,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _confirmRide,
                      style: NavigoDecorations.kPrimaryButtonLargeStyle,
                      child: const Text(
                        "Confirm Ride",
                        style: NavigoTextStyles.button,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? NavigoColors.primaryOrange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: NavigoColors.primaryOrange, width: 1.5),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: NavigoColors.primaryOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : NavigoColors.primaryOrange,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
