class Trip {
  final String tripId;
  final String driverId;
  final String routeId;

  final String from;
  final String to;

  final DateTime date;

  final List<String> passengersIds; // list of passenger IDs
  final List<String> path; // list of stops (or coordinates as strings)

  final double estimatedFare;
  final String status; // e.g. upcoming, ongoing, completed, cancelled

  Trip({
    required this.tripId,
    required this.driverId,
    required this.routeId,
    required this.from,
    required this.to,
    required this.date,
    required this.passengersIds,
    required this.path,
    required this.estimatedFare,
    required this.status,
  });

  // ✅ Convert to Firestore
  Map<String, dynamic> toMap() {
    return {
      "tripId": tripId,
      "driverId": driverId,
      "routeId": routeId,
      "from": from,
      "to": to,
      "date": date.toIso8601String(),
      "passengersIds": passengersIds,
      "path": path,
      "estimatedFare": estimatedFare,
      "status": status,
    };
  }

  // ✅ From Firestore
  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      tripId: map["tripId"] ?? "",
      driverId: map["driverId"] ?? "",
      routeId: map["routeId"] ?? "",
      from: map["from"] ?? "",
      to: map["to"] ?? "",
      date: DateTime.parse(map["date"]),
      passengersIds: List<String>.from(map["passengersIds"] ?? []),
      path: List<String>.from(map["path"] ?? []),
      estimatedFare: (map["estimatedFare"] ?? 0).toDouble(),
      status: map["status"] ?? "upcoming",
    );
  }
}