import 'package:flutter/material.dart';

class AddScheduleSlotScreen extends StatefulWidget {
  const AddScheduleSlotScreen({super.key});

  @override
  State<AddScheduleSlotScreen> createState() => _AddScheduleSlotScreenState();
}

class _AddScheduleSlotScreenState extends State<AddScheduleSlotScreen> {
  String selectedType = "bus";

  final TextEditingController slotIdController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();

  String? seats;

  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  DateTime? selectedDate;

  List<String> selectedDays = [];
  List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  Future<void> pickTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromTime = picked;
        } else {
          toTime = picked;
        }
      });
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return "Select";
    return time.format(context);
  }

  String formatDate(DateTime? date) {
    if (date == null) return "Select date";
    return "${date.day}/${date.month}/${date.year}";
  }

  void saveSlot() {
    final slot = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "start": formatTime(fromTime),
      "end": formatTime(toTime),
      "frequency": "Every ${frequencyController.text} minutes",
      "date": formatDate(selectedDate),
      "line": "L-${slotIdController.text}",
      "type": selectedType,
      "seats": seats ?? "",
    };

    Navigator.pop(context, slot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Schedule Slot",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  buildTypeButton("bus", "Bus"),
                  const SizedBox(width: 10),
                  buildTypeButton("micro", "Micro Bus"),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Slot ID"),
                    Row(
                      children: [
                        const Text("L-"),
                        Expanded(
                          child: TextField(
                            controller: slotIdController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: buildPickerBox(
                            "From",
                            formatTime(fromTime),
                            () => pickTime(true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildPickerBox(
                            "To",
                            formatTime(toTime),
                            () => pickTime(false),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    const Text("Frequency"),

                    Row(
                      children: [
                        const Text("Every "),
                        Expanded(
                          child: TextField(
                            controller: frequencyController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const Text(" minutes"),
                      ],
                    ),

                    const SizedBox(height: 15),

                    const Text("Date"),
                    buildPickerBox("", formatDate(selectedDate), pickDate),

                    if (selectedType == "bus") ...[
                      const SizedBox(height: 15),

                      const Text("Seats"),

                      DropdownButtonFormField<String>(
                        initialValue: seats,
                        items: const [
                          DropdownMenuItem(value: "45", child: Text("45")),
                          DropdownMenuItem(value: "14", child: Text("14")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            seats = value;
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: saveSlot,
                child: const Text("Save Slot"),
              ),

              const SizedBox(height: 10),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        ),
      ),

      /*bottomNavigationBar: RouteManagerNavBar(
        currentIndex:1,
        onTap:(index){},
      ),*/
    );
  }

  Widget buildTypeButton(String type, String label) {
    final isSelected = selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label),
      ),
    );
  }

  Widget buildPickerBox(String label, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != "") Text(label),

        GestureDetector(
          onTap: onTap,

          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(value),
          ),
        ),
      ],
    );
  }
}
