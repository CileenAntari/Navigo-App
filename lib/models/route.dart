class RouteModel {
  final String routeId;
  final String startPoint;
  final String endPoint;
  final double price;
  final List<String> vehicleTypes; // bus, microbus

  RouteModel({
    required this.routeId,
    required this.startPoint,
    required this.endPoint,
    required this.price,
    required this.vehicleTypes,
  });

  // 🔹 Convert to Firestore
  Map<String, dynamic> toMap() {
    return {
      "routeId": routeId,
      "startPoint": startPoint,
      "endPoint": endPoint,
      "price": price,
      "vehicleTypes": vehicleTypes,
    };
  }

  // 🔹 From Firestore
  factory RouteModel.fromMap(Map<String, dynamic> map) {
    return RouteModel(
      routeId: map['routeId'] ?? '',
      startPoint: map['startPoint'] ?? '',
      endPoint: map['endPoint'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      vehicleTypes: List<String>.from(map['vehicleTypes'] ?? []),
    );
  }
}