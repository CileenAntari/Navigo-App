import 'package:flutter/material.dart';
import 'package:navigo/theme/app_theme.dart';

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
      setState(() => selectedDate = picked);
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
      backgroundColor: NavigoColors.backgroundLight,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOP BAR
            NavigoDecorations.topBar(onBack: () => Navigator.pop(context)),

            /// TITLE
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NavigoSizes.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add Schedule Slot", style: NavigoTextStyles.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    "Fill in the details for the new slot",
                    style: NavigoTextStyles.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(height: NavigoSizes.sectionGap),

            /// SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: NavigoSizes.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TYPE SELECTOR
                    Row(
                      children: [
                        NavigoDecorations.selectorChip(
                          label: "Bus",
                          selected: selectedType == "bus",
                          onTap: () => setState(() => selectedType = "bus"),
                        ),
                        const SizedBox(width: 10),
                        NavigoDecorations.selectorChip(
                          label: "Micro Bus",
                          selected: selectedType == "micro",
                          onTap: () => setState(() => selectedType = "micro"),
                        ),
                      ],
                    ),

                    const SizedBox(height: NavigoSizes.sectionGap),

                    /// FORM CARD
                    Container(
                      padding: const EdgeInsets.all(NavigoSizes.cardPadding),
                      decoration: NavigoDecorations.kCardDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// SLOT ID
                          Text("Slot ID", style: NavigoTextStyles.label),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text("L-", style: NavigoTextStyles.fieldText),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: slotIdController,
                                  keyboardType: TextInputType.number,
                                  style: NavigoTextStyles.fieldText,
                                  decoration: NavigoDecorations.kInputDecoration
                                      .copyWith(hintText: "e.g. 12"),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: NavigoSizes.itemGap),

                          /// FROM / TO TIME
                          Row(
                            children: [
                              Expanded(
                                child: _buildPickerBox(
                                  label: "From",
                                  value: formatTime(fromTime),
                                  icon: Icons.access_time,
                                  onTap: () => pickTime(true),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildPickerBox(
                                  label: "To",
                                  value: formatTime(toTime),
                                  icon: Icons.access_time_filled,
                                  onTap: () => pickTime(false),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: NavigoSizes.itemGap),

                          /// FREQUENCY
                          Text("Frequency", style: NavigoTextStyles.label),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text("Every ", style: NavigoTextStyles.fieldText),
                              Expanded(
                                child: TextField(
                                  controller: frequencyController,
                                  keyboardType: TextInputType.number,
                                  style: NavigoTextStyles.fieldText,
                                  decoration: NavigoDecorations.kInputDecoration
                                      .copyWith(hintText: "e.g. 30"),
                                ),
                              ),
                              Text(
                                " minutes",
                                style: NavigoTextStyles.fieldText,
                              ),
                            ],
                          ),

                          const SizedBox(height: NavigoSizes.itemGap),

                          /// DATE
                          Text("Date", style: NavigoTextStyles.label),
                          const SizedBox(height: 6),
                          _buildPickerBox(
                            label: "",
                            value: formatDate(selectedDate),
                            icon: Icons.calendar_today,
                            onTap: pickDate,
                          ),

                          /// SEATS (bus only)
                          if (selectedType == "bus") ...[
                            const SizedBox(height: NavigoSizes.itemGap),
                            Text("Seats", style: NavigoTextStyles.label),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: seats,
                              decoration: NavigoDecorations.kInputDecoration,
                              style: NavigoTextStyles.fieldText,
                              items: const [
                                DropdownMenuItem(
                                  value: "45",
                                  child: Text("45 seats"),
                                ),
                                DropdownMenuItem(
                                  value: "14",
                                  child: Text("14 seats"),
                                ),
                              ],
                              onChanged: (value) =>
                                  setState(() => seats = value),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: NavigoSizes.sectionGap),

                    /// SAVE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: NavigoSizes.buttonHeight,
                      child: ElevatedButton(
                        onPressed: saveSlot,
                        style: NavigoDecorations.kPrimaryButtonLargeStyle,
                        child: const Text(
                          "Save Slot",
                          style: NavigoTextStyles.button,
                        ),
                      ),
                    ),

                    const SizedBox(height: NavigoSizes.itemGap),

                    /// CANCEL BUTTON
                    /// CANCEL BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: NavigoSizes.buttonHeight,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: NavigoDecorations.kPrimaryButtonLargeStyle
                            .copyWith(
                              backgroundColor: const WidgetStatePropertyAll(
                                NavigoColors.accentRed,
                              ),
                            ),
                        child: const Text(
                          "Cancel",
                          style: NavigoTextStyles.button,
                        ),
                      ),
                    ),

                    const SizedBox(height: NavigoSizes.sectionGap),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerBox({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: NavigoTextStyles.label),
          const SizedBox(height: 6),
        ],
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: NavigoDecorations.surfaceDecoration(
              radius: NavigoSizes.inputRadius,
              color: NavigoColors.inputFill,
              bordered: false,
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: NavigoColors.accentGreen),
                const SizedBox(width: 8),
                Text(value, style: NavigoTextStyles.fieldText),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
