import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/journal_entry.dart';

class JournalRepository {
  static const String _key = 'journal_v1';

  Future<List<JournalEntry>> getAll() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> arr = json.decode(raw) as List<dynamic>;
    final items = arr.map((e) => JournalEntry.fromMap(Map<String, dynamic>.from(e as Map))).toList();
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  Future<void> addEntry(JournalEntry e) async {
    final list = await getAll();
    list.add(e);
    await _saveList(list);
  }

  Future<void> updateEntry(JournalEntry e) async {
    final list = await getAll();
    final idx = list.indexWhere((it) => it.id == e.id);
    if (idx >= 0) list[idx] = e;
    await _saveList(list);
  }

  Future<void> deleteEntry(String id) async {
    final list = await getAll();
    list.removeWhere((it) => it.id == id);
    await _saveList(list);
  }

  Future<void> _saveList(List<JournalEntry> items) async {
    final sp = await SharedPreferences.getInstance();
    final raw = json.encode(items.map((e) => e.toMap()).toList());
    await sp.setString(_key, raw);
  }
}