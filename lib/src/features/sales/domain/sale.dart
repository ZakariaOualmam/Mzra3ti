/// Sale Model
class Sale {
  final int? id;
  final DateTime date;
  final String customerName;
  final String customerPhone;
  final String product;
  final double quantity;
  final double pricePerUnit;
  final double totalAmount;
  final String paymentMethod; // Cash, Bank Transfer, Check
  final String status; // Paid, Pending, Partial
  final String? notes;

  Sale({
    this.id,
    required this.date,
    required this.customerName,
    required this.customerPhone,
    required this.product,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'customerName': customerName,
      'customerPhone': customerPhone,
      'product': product,
      'quantity': quantity,
      'pricePerUnit': pricePerUnit,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'status': status,
      'notes': notes,
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      date: DateTime.parse(map['date']),
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
      product: map['product'],
      quantity: map['quantity'],
      pricePerUnit: map['pricePerUnit'],
      totalAmount: map['totalAmount'],
      paymentMethod: map['paymentMethod'],
      status: map['status'],
      notes: map['notes'],
    );
  }
}

/// Customer Model
class Customer {
  final String name;
  final String phone;
  final double totalPurchases;
  final int purchaseCount;

  Customer({
    required this.name,
    required this.phone,
    required this.totalPurchases,
    required this.purchaseCount,
  });
}
