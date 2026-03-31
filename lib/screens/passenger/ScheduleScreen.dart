import 'package:flutter/material.dart';

// ✅ IMPORT NAV BAR
import 'PassengerBottomNavBar.dart';

class ScheduleScreen extends StatefulWidget {
  final String? selectedLine;

  const ScheduleScreen({super.key, this.selectedLine});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String? _selectedLine;
  String? _vehicleType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _seatCount = 1;

  final List<String> _vehicles = ['Bus', 'Mini Bus'];

  @override
  void initState() {
    super.initState();
    _selectedLine = widget.selectedLine;
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => _selectedTime = picked);
  }

  String _formatDate() =>
      _selectedDate == null
          ? "Select date"
          : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";

  String _formatTime() =>
      _selectedTime == null
          ? "Select time"
          : "${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}";

  void _incrementSeat() {
    if (_seatCount < 10) {
      setState(() => _seatCount++);
    }
  }

  void _decrementSeat() {
    if (_seatCount > 1) {
      setState(() => _seatCount--);
    }
  }

  void _confirmSchedule() {
    if (_selectedLine == null ||
        _vehicleType == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Ride Scheduled: $_seatCount seat(s) 🚀")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ✅ NAV BAR
      bottomNavigationBar: const PassengerBottomNavBar(
        currentIndex: 1,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              const Text(
                "Schedule Ride",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// VEHICLE TYPE
              Row(
                children: _vehicles
                    .map((v) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(v),
                              selected: _vehicleType == v,
                              selectedColor: Colors.orange,
                              onSelected: (_) =>
                                  setState(() => _vehicleType = v),
                            ),
                          ),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 20),

              /// SELECTED LINE
              Text(
                "Selected Line: ${_selectedLine ?? 'None'}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// SEAT SELECTOR
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.orange, width: 1.5),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Number of Seats",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _decrementSeat,
                          icon: const Icon(Icons.remove_circle_outline,
                              size: 32),
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          '$_seatCount',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          onPressed: _incrementSeat,
                          icon:
                              const Icon(Icons.add_circle_outline, size: 32),
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// DATE PICKER
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Colors.grey),
                ),
                leading:
                    const Icon(Icons.calendar_today, color: Colors.orange),
                title: Text(_formatDate()),
                onTap: _pickDate,
              ),

              const SizedBox(height: 15),

              /// TIME PICKER
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Colors.grey),
                ),
                leading:
                    const Icon(Icons.access_time, color: Colors.orange),
                title: Text(_formatTime()),
                onTap: _pickTime,
              ),

              const SizedBox(height: 25),

              /// CONFIRM BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _confirmSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Confirm Schedule",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}