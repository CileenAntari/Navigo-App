import 'user.dart'; // your abstract UserModel

class DriverModel extends UserModel {
  final String vehicle;
  final String route;
  final bool availability;
  final String licenseNumber;

  DriverModel({
    required String userId,
    required String firstName,
    required String lastName,
    required String phone,
    String? image,
    required String role,
    required bool isVerified,
    required this.vehicle,
    required this.route,
    required this.availability,
    required this.licenseNumber,
  }) : super(
          userId: userId,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          image: image,
          role: role,
          isVerified: isVerified,
        );

  // Convert DriverModel to Map for Firestore
  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'image': image,
      'role': role,
      'isVerified': isVerified,
      'vehicle': vehicle,
      'route': route,
      'availability': availability,
      'licenseNumber': licenseNumber,
    };
  }

  // Create DriverModel from Firestore Map
  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      userId: map['userId'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phone: map['phone'] ?? '',
      image: map['image'],
      role: map['role'] ?? 'driver',
      isVerified: map['isVerified'] ?? false,
      vehicle: map['vehicle'] ?? '',
      route: map['route'] ?? '',
      availability: map['availability'] ?? true,
      licenseNumber: map['licenseNumber'] ?? '',
    );
  }
}