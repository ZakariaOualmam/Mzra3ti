import 'dart:convert';

class Irrigation {
  final String id;
  final DateTime date;
  final String? note;
  final DateTime? remindAt;

  Irrigation({required this.id, required this.date, this.note, this.remindAt});

  factory Irrigation.create({required DateTime date, String? note, DateTime? remindAt}) {
    return Irrigation(id: DateTime.now().millisecondsSinceEpoch.toString(), date: date, note: note, remindAt: remindAt);
  }

  factory Irrigation.fromMap(Map<String, dynamic> m) {
    return Irrigation(
      id: m['id'] as String,
      date: DateTime.parse(m['date'] as String),
      note: m['note'] as String?,
      remindAt: m['remindAt'] != null ? DateTime.parse(m['remindAt'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'note': note,
        'remindAt': remindAt?.toIso8601String(),
      };

  String toJson() => json.encode(toMap());
  factory Irrigation.fromJson(String s) => Irrigation.fromMap(json.decode(s));
}
