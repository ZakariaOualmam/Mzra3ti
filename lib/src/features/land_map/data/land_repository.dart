import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../domain/land_boundary.dart';

class LandRepository {
  static const String _keyLands = 'lands';

  Future<List<LandBoundary>> getAllLands() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_keyLands);
    if (data == null || data.isEmpty) return [];
    
    final List<dynamic> decoded = json.decode(data);
    return decoded.map((item) => LandBoundary.fromMap(item)).toList();
  }

  Future<void> saveLand(LandBoundary land) async {
    final lands = await getAllLands();
    lands.add(land);
    await _saveAll(lands);
  }

  Future<void> updateLand(LandBoundary land) async {
    final lands = await getAllLands();
    final index = lands.indexWhere((l) => l.id == land.id);
    if (index != -1) {
      lands[index] = land;
      await _saveAll(lands);
    }
  }

  Future<void> deleteLand(String id) async {
    final lands = await getAllLands();
    lands.removeWhere((l) => l.id == id);
    await _saveAll(lands);
  }

  Future<void> _saveAll(List<LandBoundary> lands) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(lands.map((l) => l.toMap()).toList());
    await prefs.setString(_keyLands, encoded);
  }
}
