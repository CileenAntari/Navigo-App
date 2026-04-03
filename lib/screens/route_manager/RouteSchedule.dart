import 'package:flutter/material.dart';
import 'AddScheduleSlotScreen.dart';
import 'RouteManagerNavBar.dart';
import '../../theme/app_theme.dart';

class RouteSchedule extends StatefulWidget {
  const RouteSchedule({super.key});

  @override
  State<RouteSchedule> createState() => _RouteScheduleState();
}

class _RouteScheduleState extends State<RouteSchedule> {
  String selectedType = "bus";

  List<Map<String, String>> slots = [
    {
      "id": "1",
      "type": "bus",
      "start": "Ramallah",
      "end": "Jerusalem",
      "frequency": "Every 30 min",
      "date": "2026-04-01",
      "line": "B1",
    },
    {
      "id": "2",
      "type": "bus",
      "start": "Bethlehem",
      "end": "Ramallah",
      "frequency": "Every 1 hour",
      "date": "2026-04-01",
      "line": "B2",
    },
    {
      "id": "3",
      "type": "micro",
      "start": "Ramallah",
      "end": "Nablus",
      "frequency": "Every 45 min",
      "date": "2026-04-01",
      "line": "M1",
    },
    {
      "id": "4",
      "type": "micro",
      "start": "Jericho",
      "end": "Ramallah",
      "frequency": "Every 1 hour",
      "date": "2026-04-01",
      "line": "M2",
    },
  ];

  void deleteSlot(String id) {
    setState(() {
      slots.removeWhere((slot) => slot["id"] == id);
    });
  }

  void showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Slot"),
        content: const Text("Remove this slot?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deleteSlot(id);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> openAddSlot() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddScheduleSlotScreen()),
    );

    if (result != null) {
      setState(() => slots.add(Map<String, String>.from(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredSlots = slots
        .where((s) => s["type"] == selectedType)
        .toList();

    return Scaffold(
      backgroundColor: NavigoColors.backgroundLight,
      bottomNavigationBar: const RouteManagerNavBar(currentIndex: 0),
      body: Stack(
        children: [
          Container(color: NavigoColors.backgroundLight),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Schedule", style: NavigoTextStyles.titleLarge),
                          Text(
                            "Manage your route slots",
                            style: NavigoTextStyles.bodySmall,
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTypeChip("bus", "Bus"),
                      const SizedBox(width: 10),
                      buildTypeChip("micro", "Micro Bus"),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: filteredSlots.isEmpty
                        ? const Center(child: Text("No Slots"))
                        : ListView.builder(
                            itemCount: filteredSlots.length,
                            itemBuilder: (_, index) {
                              final slot = filteredSlots[index];

                              return Dismissible(
                                key: ValueKey(slot["id"]),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (_) async {
                                  bool shouldDelete = false;

                                  await showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Delete Slot"),
                                      content: const Text("Remove this slot?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            shouldDelete = true;
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  return shouldDelete;
                                },
                                onDismissed: (_) {
                                  deleteSlot(slot["id"]!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Slot deleted"),
                                    ),
                                  );
                                },
                                background: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  alignment: Alignment.centerRight,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                child: buildSlotCard(slot),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: openAddSlot,
                      style: NavigoDecorations.kPrimaryButtonLargeStyle,
                      child: const Text(
                        "Add Slot",
                        style: NavigoTextStyles.button,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: NavigoDecorations.kRoleButtonStyle,
                      onPressed: () {},
                      child: const Text("Publish Updates"),
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

  Widget buildTypeChip(String type, String label) {
    final isSelected = selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? NavigoColors.primaryOrange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: NavigoColors.primaryOrange, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : NavigoColors.primaryOrange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildSlotCard(Map<String, String> slot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NavigoColors.primaryOrange, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${slot["start"]} → ${slot["end"]}",
                style: NavigoTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(slot["frequency"]!, style: NavigoTextStyles.bodySmall),
              const SizedBox(height: 6),
              Text(slot["date"]!, style: NavigoTextStyles.bodySmall),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: NavigoColors.primaryOrange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              slot["line"]!,
              style: const TextStyle(
                color: NavigoColors.primaryOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
