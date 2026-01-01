class Expense {
  int? id;
  String type;
  double amount;
  DateTime date;

  Expense({this.id, required this.type, required this.amount, required this.date});

  factory Expense.fromMap(Map<String, dynamic> m) => Expense(
        id: m['id'] as int?,
        type: m['type'] as String,
        amount: (m['amount'] as num).toDouble(),
        date: DateTime.parse(m['date'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'amount': amount,
        'date': date.toIso8601String(),
      };
}
