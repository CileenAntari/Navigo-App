class Notification {
  final String notificationId;
  final String userId;
  final String message;
  final DateTime time;

  Notification({
    required this.notificationId,
    required this.userId,
    required this.message,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      "notificationId": notificationId,
      "userId": userId,
      "message": message,
      "time": time.toIso8601String(),
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      notificationId: map["notificationId"] ?? "",
      userId: map["userId"] ?? "",
      message: map["message"] ?? "",
      time: DateTime.parse(map["time"] ?? DateTime.now().toIso8601String()),
    );
  }
}
