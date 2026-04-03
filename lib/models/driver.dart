import 'user.dart';

class DriverModel extends UserModel {
  final String vehicle;
  final String route;
  final bool availability;
  final String licenseNumber;
  final bool isApproved;

  DriverModel({
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.phone,
    super.image,
    required super.role,
    required super.isVerified,
    required this.vehicle,
    required this.route,
    required this.availability,
    required this.licenseNumber,
    required this.isApproved,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "firstName": firstName,
      "lastName": lastName,
      "phone": phone,
      "image": image,
      "role": role,
      "isVerified": isVerified,
      "vehicle": vehicle,
      "route": route,
      "availability": availability,
      "licenseNumber": licenseNumber,
      "isApproved": isApproved,
    };
  }

  Map<String, dynamic> toDriverMap() {
    return {
      "vehicle": vehicle,
      "route": route,
      "availability": availability,
      "licenseNumber": licenseNumber,
      "isApproved": isApproved,
    };
  }

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      userId: map["userId"] ?? "",
      firstName: map["firstName"] ?? "",
      lastName: map["lastName"] ?? "",
      phone: map["phone"] ?? "",
      image: map["image"],
      role: map["role"] ?? "driver",
      isVerified: map["isVerified"] ?? false,
      vehicle: map["vehicle"] ?? "",
      route: map["route"] ?? "",
      availability: map["availability"] ?? false,
      licenseNumber: map["licenseNumber"] ?? "",
      isApproved: map["isApproved"] ?? false,
    );
  }
}
