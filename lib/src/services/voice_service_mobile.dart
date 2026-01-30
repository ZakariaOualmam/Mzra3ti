import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mobile-compatible voice service (placeholder implementation)
/// For full functionality, integrate packages like speech_to_text and flutter_tts
class VoiceService extends ChangeNotifier {
  // Voice settings
  bool _isEnabled = false;
  bool _isSpeaking = false;
  bool _isListening = false;
  double _speechRate = 0.8;
  double _volume = 1.0;
  double _pitch = 1.0;
  String _currentLanguage = 'ar-MA';
  
  // Getters
  bool get isEnabled => _isEnabled;
  bool get isSpeaking => _isSpeaking;
  bool get isListening => _isListening;
  double get speechRate => _speechRate;
  double get volume => _volume;
  double get pitch => _pitch;
  String get currentLanguage => _currentLanguage;

  VoiceService() {
    _loadSettings();
  }

  /// Load voice settings from preferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isEnabled = prefs.getBool('voice_enabled') ?? false;
      _speechRate = prefs.getDouble('voice_speed') ?? 0.8;
      _volume = prefs.getDouble('voice_volume') ?? 1.0;
      _pitch = prefs.getDouble('voice_pitch') ?? 1.0;
      _currentLanguage = prefs.getString('voice_language') ?? 'ar-MA';
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading voice settings: $e');
    }
  }

  /// Save voice settings
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('voice_enabled', _isEnabled);
      await prefs.setDouble('voice_speed', _speechRate);
      await prefs.setDouble('voice_volume', _volume);
      await prefs.setDouble('voice_pitch', _pitch);
      await prefs.setString('voice_language', _currentLanguage);
    } catch (e) {
      debugPrint('Error saving voice settings: $e');
    }
  }

  /// Enable/disable voice assistance
  Future<void> toggleVoiceAssistance(bool enabled) async {
    _isEnabled = enabled;
    await _saveSettings();
    notifyListeners();
    
    if (enabled) {
      debugPrint('Voice assistance enabled (mobile implementation pending)');
    }
  }

  /// Speak text out loud (placeholder - needs flutter_tts integration)
  Future<void> speak(String text, {bool force = false}) async {
    if (!_isEnabled && !force) return;
    
    debugPrint('TTS (Mobile): $text');
    // TODO: Integrate flutter_tts package for actual speech synthesis
  }

  /// Stop speaking
  Future<void> stop() async {
    _isSpeaking = false;
    notifyListeners();
    debugPrint('Speech stopped');
  }

  /// Listen for voice input (placeholder)
  Future<String?> listen({String? locale}) async {
    if (!_isEnabled) return null;
    
    _isListening = true;
    notifyListeners();
    
    debugPrint('Speech recognition started (mobile implementation pending)');
    // TODO: Integrate speech_to_text package for actual speech recognition
    
    await Future.delayed(Duration(seconds: 1));
    _isListening = false;
    notifyListeners();
    
    return null;
  }

  /// Stop listening for speech
  Future<void> stopListening() async {
    if (_isListening) {
      _isListening = false;
      notifyListeners();
      debugPrint('Speech recognition stopped');
    }
  }

  /// Set speech rate
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.1, 2.0);
    await _saveSettings();
    notifyListeners();
  }

  /// Set volume
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _saveSettings();
    notifyListeners();
  }

  /// Set pitch
  Future<void> setPitch(double pitch) async {
    _pitch = pitch.clamp(0.5, 2.0);
    await _saveSettings();
    notifyListeners();
  }

  /// Change language
  Future<void> setLanguage(String language) async {
    _currentLanguage = language;
    await _saveSettings();
    notifyListeners();
  }

  /// Speak button/widget label when tapped
  Future<void> speakLabel(String label) async {
    if (!_isEnabled) return;
    await speak(label);
  }

  /// Announce screen name when navigating
  Future<void> announceScreen(String screenName) async {
    if (!_isEnabled) return;
    await speak('شاشة $screenName');
  }

  /// Read number value
  Future<void> speakNumber(dynamic number, String unit) async {
    if (!_isEnabled) return;
    await speak('$number $unit');
  }

  /// Speak form field label and value
  Future<void> speakField(String label, String? value) async {
    if (!_isEnabled) return;
    if (value != null && value.isNotEmpty) {
      await speak('$label: $value');
    } else {
      await speak('$label: فارغ');
    }
  }

  /// Speak validation error
  Future<void> speakError(String error) async {
    if (!_isEnabled) return;
    await speak('خطأ: $error');
  }

  /// Speak success message
  Future<void> speakSuccess(String message) async {
    if (!_isEnabled) return;
    await speak('نجح: $message');
  }

  /// Get voice command for number input
  Future<double?> getNumberInput(String prompt) async {
    await speak(prompt, force: true);
    final result = await listen();
    
    if (result == null) return null;
    
    final cleaned = result.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned);
  }

  /// Get voice command for text input
  Future<String?> getTextInput(String prompt) async {
    await speak(prompt, force: true);
    return await listen();
  }

  /// Get voice command for yes/no question
  Future<bool?> getYesNoInput(String question) async {
    await speak('$question. قل نعم أو لا', force: true);
    final result = await listen();
    
    if (result == null) return null;
    
    final lower = result.toLowerCase().trim();
    if (lower.contains('نعم') || lower.contains('yes') || lower.contains('oui')) {
      return true;
    } else if (lower.contains('لا') || lower.contains('no') || lower.contains('non')) {
      return false;
    }
    
    return null;
  }

  @override
  void dispose() {
    stop();
    stopListening();
    super.dispose();
  }
}
