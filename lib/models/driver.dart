import 'user.dart';

class DriverModel extends UserModel {
  final String vehicle;
  final String route;
  final bool availability;
  final String licenseNumber;

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
  });

  // ✅ SAME as Passenger → only base user fields
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
    };
  }

  // ✅ ONLY driver-specific fields
  Map<String, dynamic> toDriverMap() {
    return {
      "vehicle": vehicle,
      "route": route,
      "availability": availability,
      "licenseNumber": licenseNumber,
    };
  }
}