import 'package:flutter/material.dart';
import '../features/settings/data/settings_repository.dart';

/// ThemeService manages app-wide theme state with persistence
/// 
/// Features:
/// - Light/Dark mode toggle
/// - System theme respect by default
/// - Persistent across app restarts
/// - Single source of truth for theme
class ThemeService extends ChangeNotifier {
  final SettingsRepository _repo = SettingsRepository();
  
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;
  
  /// Initialize and load saved theme preference
  /// Default: Light mode on first launch
  Future<void> initialize() async {
    final savedMode = await _repo.get<String>('themeMode', 'light');
    _themeMode = _themeModeFromString(savedMode ?? 'light');
    notifyListeners();
  }
  
  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }
  
  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _repo.set('themeMode', _themeModeToString(mode));
    notifyListeners();
  }
  
  /// Reset to system theme
  Future<void> useSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }
  
  // Helper methods for persistence
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
  
  ThemeMode _themeModeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
