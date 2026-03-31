import 'user.dart';

class Passenger extends UserModel {
  final List<dynamic> tripHistory;
  final List<dynamic> paymentMethods;

  Passenger({
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.phone,
    super.image,
    required super.role,
    required super.isVerified,
    required this.tripHistory,
    required this.paymentMethods,
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
    };
  }

  Map<String, dynamic> toPassengerMap() {
    return {
      "tripHistory": tripHistory,
      "paymentMethods": paymentMethods,
    };
  }
}