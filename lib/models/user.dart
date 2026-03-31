abstract class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String phone;
  final String? image;
  final String role;
  final bool isVerified;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.image,
    required this.role,
    required this.isVerified,
  });

  Map<String, dynamic> toMap();
}