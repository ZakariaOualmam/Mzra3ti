import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../domain/crop_calendar.dart';

class CropCalendarRepository {
  static const _key = 'crop_calendar_data';

  Future<List<CropCalendarEntry>> list() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) => CropCalendarEntry.fromMap(jsonDecode(s))).toList();
  }

  Future<void> add(CropCalendarEntry entry) async {
    final all = await list();
    final newEntry = CropCalendarEntry(
      id: all.isEmpty ? 1 : all.map((e) => e.id!).reduce((a, b) => a > b ? a : b) + 1,
      cropName: entry.cropName,
      cropType: entry.cropType,
      plantingDate: entry.plantingDate,
      expectedHarvestDate: entry.expectedHarvestDate,
      growthDaysEstimate: entry.growthDaysEstimate,
      season: entry.season,
      reminderEnabled: entry.reminderEnabled,
      notes: entry.notes,
    );
    all.add(newEntry);
    await _save(all);
  }

  Future<void> update(CropCalendarEntry entry) async {
    final all = await list();
    final index = all.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      all[index] = entry;
      await _save(all);
    }
  }

  Future<void> delete(int id) async {
    final all = await list();
    all.removeWhere((e) => e.id == id);
    await _save(all);
  }

  Future<void> _save(List<CropCalendarEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = entries.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(_key, encoded);
  }

  Future<List<CropCalendarEntry>> getUpcoming() async {
    final all = await list();
    return all.where((e) => e.daysUntilHarvest >= 0).toList()
      ..sort((a, b) => a.daysUntilHarvest.compareTo(b.daysUntilHarvest));
  }

  Future<List<CropCalendarEntry>> getReadyToHarvest() async {
    final all = await list();
    return all.where((e) => e.isReadyToHarvest).toList();
  }

  Future<Map<String, int>> getStatsBySeason() async {
    final all = await list();
    final Map<String, int> stats = {
      'الربيع': 0,
      'الصيف': 0,
      'الخريف': 0,
      'الشتاء': 0,
    };
    
    for (var entry in all) {
      stats[entry.season] = (stats[entry.season] ?? 0) + 1;
    }
    
    return stats;
  }
}
