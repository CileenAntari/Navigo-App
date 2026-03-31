class PaymentMethod {
  final String type; // cash / card
  final String? details;

  PaymentMethod({
    required this.type,
    this.details,
  });

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "details": details,
    };
  }
}