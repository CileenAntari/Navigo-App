import 'user.dart';

class RouteManagerModel extends UserModel {
  final String routeId;
  final String email; // Optional: for easier access

  RouteManagerModel({
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.phone,
    super.image,
    required super.role,
    required super.isVerified,
    required this.routeId,
    required this.email,
  });

  // same as others → ONLY base fields
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

  // only route manager fields
  Map<String, dynamic> toRouteManagerMap() {
    return {
      "routeId": routeId,
      "email": email,
    };
  }
}