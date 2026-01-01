import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/expense.dart';

class ExpenseRepository {
  static const String _key = 'expenses_v1';

  Future<List<Expense>> getAll() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> arr = json.decode(raw) as List<dynamic>;
    final items = arr.map((e) => Expense.fromMap(Map<String, dynamic>.from(e as Map))).toList();
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  Future<void> addExpense(Expense e) async {
    final list = await getAll();
    // assign incremental id
    final nextId = (list.map((it) => it.id ?? 0).fold<int>(0, (p, n) => p > n ? p : n)) + 1;
    e.id = nextId;
    list.add(e);
    await _saveList(list);
  }

  Future<void> updateExpense(Expense e) async {
    final list = await getAll();
    final idx = list.indexWhere((it) => it.id == e.id);
    if (idx >= 0) list[idx] = e;
    await _saveList(list);
  }

  Future<void> deleteExpense(int? id) async {
    if (id == null) return;
    final list = await getAll();
    list.removeWhere((it) => it.id == id);
    await _saveList(list);
  }

  Future<void> _saveList(List<Expense> items) async {
    final sp = await SharedPreferences.getInstance();
    final raw = json.encode(items.map((e) => e.toMap()).toList());
    await sp.setString(_key, raw);
  }

  Future<double> total() async {
    final list = await getAll();
    return list.fold<double>(0.0, (p, Expense e) => p + e.amount);
  }
}
