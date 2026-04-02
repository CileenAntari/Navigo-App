class ScheduleModel {
  final String scheduleId;
  final String routeId;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int numberOfSeats;

  ScheduleModel({
    required this.scheduleId,
    required this.routeId,
    required this.departureTime,
    required this.arrivalTime,
    required this.numberOfSeats,
  });

  // Convert to Firestore
  Map<String, dynamic> toMap() {
    return {
      "scheduleId": scheduleId,
      "routeId": routeId,
      "departureTime": departureTime.toIso8601String(),
      "arrivalTime": arrivalTime.toIso8601String(),
      "numberOfSeats": numberOfSeats,
    };
  }

  // From Firestore
  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      scheduleId: map["scheduleId"] ?? "",
      routeId: map["routeId"] ?? "",
      departureTime: DateTime.parse(map["departureTime"]),
      arrivalTime: DateTime.parse(map["arrivalTime"]),
      numberOfSeats: map["numberOfSeats"] ?? 0,
    );
  }
}