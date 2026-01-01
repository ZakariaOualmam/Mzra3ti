import 'dart:convert';

class Harvest {
  final String id;
  String crop;
  double quantity; // in kg or unit
  double pricePerUnit; // DH per unit
  DateTime date;

  Harvest({required this.id, required this.crop, required this.quantity, required this.pricePerUnit, required this.date});

  double get revenue => quantity * pricePerUnit;

  factory Harvest.create({required String crop, required double quantity, required double pricePerUnit, DateTime? date}) {
    return Harvest(id: DateTime.now().millisecondsSinceEpoch.toString(), crop: crop, quantity: quantity, pricePerUnit: pricePerUnit, date: date ?? DateTime.now());
  }

  factory Harvest.fromMap(Map<String, dynamic> m) {
    return Harvest(
      id: m['id'] as String,
      crop: m['crop'] as String,
      quantity: (m['quantity'] as num).toDouble(),
      pricePerUnit: (m['pricePerUnit'] as num).toDouble(),
      date: DateTime.parse(m['date'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'crop': crop,
        'quantity': quantity,
        'pricePerUnit': pricePerUnit,
        'date': date.toIso8601String(),
      };

  String toJson() => json.encode(toMap());
  factory Harvest.fromJson(String s) => Harvest.fromMap(json.decode(s));
}
