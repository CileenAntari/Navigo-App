class Vehicle {
  final String vehicleId;
  final String type;
  final String plateNumber;
  final num seatCount;

  Vehicle({
    required this.vehicleId,
    required this.type,
    required this.plateNumber,
    required this.seatCount,
  });

  Map<String, dynamic> toMap() {
    return {
      "vehicleId": vehicleId,
      "type": type,
      "plateNumber": plateNumber,
      "seatCount": seatCount,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      vehicleId: map["vehicleId"] ?? "",
      type: map["type"] ?? "",
      plateNumber: map["plateNumber"] ?? "",
      seatCount: map["seatCount"] ?? 0,
    );
  }
}
