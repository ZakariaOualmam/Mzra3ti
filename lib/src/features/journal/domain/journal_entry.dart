import 'dart:convert';

class JournalEntry {
  final String id;
  final DateTime date;
  String activity;
  String? photoBase64; // optional, store as base64 string

  JournalEntry({required this.id, required this.date, required this.activity, this.photoBase64});

  factory JournalEntry.create({required String activity, DateTime? date, String? photoBase64}) {
    return JournalEntry(id: DateTime.now().millisecondsSinceEpoch.toString(), date: date ?? DateTime.now(), activity: activity, photoBase64: photoBase64);
  }

  factory JournalEntry.fromMap(Map<String, dynamic> m) {
    return JournalEntry(
      id: m['id'] as String,
      date: DateTime.parse(m['date'] as String),
      activity: m['activity'] as String,
      photoBase64: m['photoBase64'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'activity': activity,
        'photoBase64': photoBase64,
      };

  String toJson() => json.encode(toMap());
  factory JournalEntry.fromJson(String s) => JournalEntry.fromMap(json.decode(s));
}
