class Trip {
  final String from;
  final String to;
  final DateTime date;

  Trip({
    required this.from,
    required this.to,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "from": from,
      "to": to,
      "date": date.toIso8601String(),
    };
  }
}