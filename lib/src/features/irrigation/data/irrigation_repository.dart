import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/irrigation.dart';

class IrrigationRepository {
  static const String _key = 'irrigations_v1';

  Future<List<Irrigation>> getAll() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> arr = json.decode(raw) as List<dynamic>;
    final items = arr.map((e) => Irrigation.fromMap(Map<String, dynamic>.from(e as Map))).toList();
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  Future<void> addIrrigation(Irrigation irrigation) async {
    final list = await getAll();
    list.add(irrigation);
    await _saveList(list);
  }

  Future<void> deleteIrrigation(String id) async {
    final list = await getAll();
    list.removeWhere((e) => e.id == id);
    await _saveList(list);
  }

  Future<void> updateIrrigation(Irrigation irrigation) async {
    final list = await getAll();
    final idx = list.indexWhere((e) => e.id == irrigation.id);
    if (idx >= 0) list[idx] = irrigation;
    await _saveList(list);
  }

  Future<void> _saveList(List<Irrigation> items) async {
    final sp = await SharedPreferences.getInstance();
    final raw = json.encode(items.map((e) => e.toMap()).toList());
    await sp.setString(_key, raw);
  }
}
