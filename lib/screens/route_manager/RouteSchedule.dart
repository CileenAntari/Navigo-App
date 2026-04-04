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
  ];

  void deleteSlot(String id) {
    setState(() {
      slots.removeWhere((slot) => slot["id"] == id);
    });
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

  List<Map<String, String>> get filteredSlots =>
      slots.where((s) => s["type"] == selectedType).toList();

  // ── FILTER CHIP ─────────────────────────────
  Widget filterChip(String type, String label) {
    final selected = selectedType == type;

    return NavigoDecorations.selectorChip(
      label: label,
      selected: selected,
      onTap: () => setState(() => selectedType = type),
    );
  }

  // ── SLOT CARD ─────────────────────────────
  Widget buildSlotCard(Map<String, String> slot) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: NavigoDecorations.kCardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: NavigoDecorations.iconCircleDecoration(
              NavigoColors.accentGreen.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.route,
              color: NavigoColors.accentGreen,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${slot["start"]} → ${slot["end"]}",
                  style: NavigoTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(slot["frequency"]!, style: NavigoTextStyles.bodySmall),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 13,
                      color: NavigoColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      slot["date"]!,
                      style: NavigoTextStyles.bodySmall.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          NavigoDecorations.statusChip(
            label: slot["line"]!,
            color: NavigoColors.primaryOrange,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          ),
        ],
      ),
    );
  }

  // ── BUILD ─────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavigoColors.backgroundLight,
      bottomNavigationBar: const RouteManagerNavBar(currentIndex: 0),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: NavigoDecorations.homeStyleTitleBar(
                title: "Route Manager",
                subtitle: "Route Schedule",
                avatar: CircleAvatar(
                  radius: 20,
                  backgroundColor: NavigoColors.surfaceWhite,
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
              ),
            ),

            const SizedBox(height: 16),

            /// Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  filterChip("bus", "Bus"),
                  const SizedBox(width: 8),
                  filterChip("micro", "Micro Bus"),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// Slots List
            Expanded(
              child: filteredSlots.isEmpty
                  ? Center(
                      child: Text(
                        "No Slots Found",
                        style: NavigoTextStyles.bodySmall,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredSlots.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final slot = filteredSlots[i];

                        return Dismissible(
                          key: ValueKey(slot["id"]),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            padding: const EdgeInsets.only(right: 20),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: NavigoColors.accentRed,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) {
                            deleteSlot(slot["id"]!);
                          },
                          child: buildSlotCard(slot),
                        );
                      },
                    ),
            ),

            /// Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: NavigoSizes.buttonHeight,
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
                    height: NavigoSizes.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: NavigoDecorations.kPrimaryButtonLargeStyle
                          .copyWith(
                            backgroundColor: const WidgetStatePropertyAll(
                              NavigoColors.accentGreen,
                            ),
                          ),
                      child: const Text("Publish Updates"),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
