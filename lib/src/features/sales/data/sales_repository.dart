import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../domain/sale.dart';

class SalesRepository {
  static const _key = 'sales_data';

  Future<List<Sale>> list() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) => Sale.fromMap(jsonDecode(s))).toList();
  }

  Future<void> add(Sale sale) async {
    final all = await list();
    final newSale = Sale(
      id: all.isEmpty ? 1 : all.map((e) => e.id!).reduce((a, b) => a > b ? a : b) + 1,
      date: sale.date,
      customerName: sale.customerName,
      customerPhone: sale.customerPhone,
      product: sale.product,
      quantity: sale.quantity,
      pricePerUnit: sale.pricePerUnit,
      totalAmount: sale.totalAmount,
      paymentMethod: sale.paymentMethod,
      status: sale.status,
      notes: sale.notes,
    );
    all.add(newSale);
    await _save(all);
  }

  Future<void> update(Sale sale) async {
    final all = await list();
    final index = all.indexWhere((e) => e.id == sale.id);
    if (index != -1) {
      all[index] = sale;
      await _save(all);
    }
  }

  Future<void> delete(int id) async {
    final all = await list();
    all.removeWhere((e) => e.id == id);
    await _save(all);
  }

  Future<void> _save(List<Sale> sales) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = sales.map((s) => jsonEncode(s.toMap())).toList();
    await prefs.setStringList(_key, encoded);
  }

  /// Get customers with their purchase history
  Future<List<Customer>> getCustomers() async {
    final sales = await list();
    final Map<String, List<Sale>> customerSales = {};

    for (var sale in sales) {
      final key = '${sale.customerName}_${sale.customerPhone}';
      if (!customerSales.containsKey(key)) {
        customerSales[key] = [];
      }
      customerSales[key]!.add(sale);
    }

    return customerSales.entries.map((entry) {
      final customerSalesList = entry.value;
      final totalPurchases = customerSalesList.fold<double>(
        0.0,
        (sum, sale) => sum + sale.totalAmount,
      );

      return Customer(
        name: customerSalesList.first.customerName,
        phone: customerSalesList.first.customerPhone,
        totalPurchases: totalPurchases,
        purchaseCount: customerSalesList.length,
      );
    }).toList()
      ..sort((a, b) => b.totalPurchases.compareTo(a.totalPurchases));
  }

  /// Get sales statistics
  Future<Map<String, dynamic>> getStats() async {
    final sales = await list();
    
    double totalSales = 0.0;
    double paidAmount = 0.0;
    double pendingAmount = 0.0;

    for (var sale in sales) {
      totalSales += sale.totalAmount;
      if (sale.status == 'Paid') {
        paidAmount += sale.totalAmount;
      } else if (sale.status == 'Pending') {
        pendingAmount += sale.totalAmount;
      }
    }

    return {
      'totalSales': totalSales,
      'paidAmount': paidAmount,
      'pendingAmount': pendingAmount,
      'totalCount': sales.length,
    };
  }

  /// Get total revenue from all sales
  Future<double> totalRevenue() async {
    final sales = await list();
    return sales.fold<double>(0.0, (sum, sale) => sum + sale.totalAmount);
  }
}
