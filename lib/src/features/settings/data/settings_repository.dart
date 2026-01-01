import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const _key = 'app_settings_v1';

  Future<Map<String, dynamic>> _readAll() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null || raw.isEmpty) return {};
    try {
      return Map<String, dynamic>.from(json.decode(raw) as Map);
    } catch (_) {
      return {};
    }
  }

  Future<T?> get<T>(String key, T? defaultValue) async {
    final all = await _readAll();
    if (!all.containsKey(key)) return defaultValue;
    return all[key] as T;
  }

  Future<void> set(String key, dynamic value) async {
    final sp = await SharedPreferences.getInstance();
    final all = await _readAll();
    all[key] = value;
    await sp.setString(_key, json.encode(all));
  }

  Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_key);
  }
}
