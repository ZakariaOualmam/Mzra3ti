import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../domain/equipment.dart';

class EquipmentRepository {
  static const _key = 'equipment_data';
  static const _maintenanceKey = 'maintenance_data';

  Future<List<Equipment>> list() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) => Equipment.fromMap(jsonDecode(s))).toList();
  }

  Future<void> add(Equipment equipment) async {
    final all = await list();
    final newEquipment = Equipment(
      id: all.isEmpty ? 1 : all.map((e) => e.id!).reduce((a, b) => a > b ? a : b) + 1,
      name: equipment.name,
      type: equipment.type,
      purchaseDate: equipment.purchaseDate,
      purchasePrice: equipment.purchasePrice,
      status: equipment.status,
      lastMaintenance: equipment.lastMaintenance,
      nextMaintenance: equipment.nextMaintenance,
      notes: equipment.notes,
    );
    all.add(newEquipment);
    await _save(all);
  }

  Future<void> update(Equipment equipment) async {
    final all = await list();
    final index = all.indexWhere((e) => e.id == equipment.id);
    if (index != -1) {
      all[index] = equipment;
      await _save(all);
    }
  }

  Future<void> delete(int id) async {
    final all = await list();
    all.removeWhere((e) => e.id == id);
    await _save(all);
  }

  Future<void> _save(List<Equipment> equipment) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = equipment.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(_key, encoded);
  }

  // Maintenance Records
  Future<List<MaintenanceRecord>> listMaintenance(int equipmentId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_maintenanceKey) ?? [];
    final all = raw.map((s) => MaintenanceRecord.fromMap(jsonDecode(s))).toList();
    return all.where((m) => m.equipmentId == equipmentId).toList();
  }

  Future<void> addMaintenance(MaintenanceRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_maintenanceKey) ?? [];
    final all = raw.map((s) => MaintenanceRecord.fromMap(jsonDecode(s))).toList();
    
    final newRecord = MaintenanceRecord(
      id: all.isEmpty ? 1 : all.map((e) => e.id!).reduce((a, b) => a > b ? a : b) + 1,
      equipmentId: record.equipmentId,
      date: record.date,
      description: record.description,
      cost: record.cost,
      performedBy: record.performedBy,
    );
    
    all.add(newRecord);
    final encoded = all.map((m) => jsonEncode(m.toMap())).toList();
    await prefs.setStringList(_maintenanceKey, encoded);
  }

  Future<Map<String, dynamic>> getStats() async {
    final equipment = await list();
    
    int active = equipment.where((e) => e.status == 'Active').length;
    int maintenance = equipment.where((e) => e.status == 'Maintenance').length;
    int broken = equipment.where((e) => e.status == 'Broken').length;
    int needsMaintenance = equipment.where((e) => e.needsMaintenance()).length;
    
    double totalValue = equipment.fold(0.0, (sum, e) => sum + e.purchasePrice);

    return {
      'total': equipment.length,
      'active': active,
      'maintenance': maintenance,
      'broken': broken,
      'needsMaintenance': needsMaintenance,
      'totalValue': totalValue,
    };
  }
}
