class Irrigation {
  int? id;
  DateTime date;
  double? waterQuantity; // liters (optional)

  Irrigation({this.id, required this.date, this.waterQuantity});

  factory Irrigation.fromMap(Map<String, dynamic> m) => Irrigation(
        id: m['id'] as int?,
        date: DateTime.parse(m['date'] as String),
        waterQuantity: m['waterQuantity'] == null ? null : (m['waterQuantity'] as num).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'waterQuantity': waterQuantity,
      };
}
