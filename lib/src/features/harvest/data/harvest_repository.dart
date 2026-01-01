import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/harvest.dart';

class HarvestRepository {
  static const String _key = 'harvests_v1';

  Future<List<Harvest>> getAll() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> arr = json.decode(raw) as List<dynamic>;
    final items = arr.map((e) => Harvest.fromMap(Map<String, dynamic>.from(e as Map))).toList();
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  Future<void> addHarvest(Harvest h) async {
    final list = await getAll();
    list.add(h);
    await _saveList(list);
  }

  Future<void> updateHarvest(Harvest h) async {
    final list = await getAll();
    final idx = list.indexWhere((it) => it.id == h.id);
    if (idx >= 0) list[idx] = h;
    await _saveList(list);
  }

  Future<void> deleteHarvest(String id) async {
    final list = await getAll();
    list.removeWhere((it) => it.id == id);
    await _saveList(list);
  }

  Future<void> _saveList(List<Harvest> items) async {
    final sp = await SharedPreferences.getInstance();
    final raw = json.encode(items.map((e) => e.toMap()).toList());
    await sp.setString(_key, raw);
  }

  Future<double> totalRevenue() async {
    final list = await getAll();
    return list.fold<double>(0.0, (p, Harvest h) => p + h.revenue);
  }

  Future<double> totalQuantity() async {
    final list = await getAll();
    return list.fold<double>(0.0, (p, Harvest h) => p + h.quantity);
  }
}
