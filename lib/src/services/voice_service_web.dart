import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;

/// Web-compatible voice service using Web Speech API
class VoiceService extends ChangeNotifier {
  // Voice settings
  bool _isEnabled = false;
  bool _isSpeaking = false;
  bool _isListening = false;
  double _speechRate = 0.8;
  double _volume = 1.0;
  double _pitch = 1.0;
  String _currentLanguage = 'ar-MA';
  
  // Web Speech API
  html.SpeechSynthesis? _speechSynthesis;
  html.SpeechRecognition? _speechRecognition;
  
  // Getters
  bool get isEnabled => _isEnabled;
  bool get isSpeaking => _isSpeaking;
  bool get isListening => _isListening;
  double get speechRate => _speechRate;
  double get volume => _volume;
  double get pitch => _pitch;
  String get currentLanguage => _currentLanguage;

  VoiceService() {
    _initWebSpeech();
    _loadSettings();
  }

  /// Initialize Web Speech API
  void _initWebSpeech() {
    try {
      _speechSynthesis = html.window.speechSynthesis;
      
      // Check if Speech Recognition is supported
      try {
        _speechRecognition = html.SpeechRecognition();
        _speechRecognition!.continuous = false;
        _speechRecognition!.interimResults = false;
        _speechRecognition!.lang = _currentLanguage;
      } catch (e) {
        debugPrint('Speech Recognition not supported: $e');
        _speechRecognition = null;
      }
    } catch (e) {
      debugPrint('Error initializing Web Speech API: $e');
    }
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
      await speak('تم تفعيل المساعد الصوتي', force: true);
    }
  }

  /// Speak text out loud using Web Speech API
  Future<void> speak(String text, {bool force = false}) async {
    if (!_isEnabled && !force) return;
    if (_speechSynthesis == null) return;
    
    try {
      // Cancel any ongoing speech
      if (_isSpeaking) {
        _speechSynthesis!.cancel();
      }
      
      final utterance = html.SpeechSynthesisUtterance(text);
      utterance.lang = _currentLanguage;
      utterance.rate = _speechRate;
      utterance.volume = _volume;
      utterance.pitch = _pitch;
      
      utterance.onStart.listen((_) {
        _isSpeaking = true;
        notifyListeners();
      });
      
      utterance.onEnd.listen((_) {
        _isSpeaking = false;
        notifyListeners();
      });
      
      utterance.onError.listen((event) {
        _isSpeaking = false;
        notifyListeners();
        debugPrint('Speech error: $event');
      });
      
      _speechSynthesis!.speak(utterance);
    } catch (e) {
      debugPrint('Error speaking: $e');
      _isSpeaking = false;
      notifyListeners();
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    try {
      if (_speechSynthesis != null) {
        _speechSynthesis!.cancel();
      }
      _isSpeaking = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping speech: $e');
    }
  }

  /// Start listening for voice input
  Future<String?> listen({String? locale}) async {
    if (_speechRecognition == null) {
      await speak('خدمة التعرف على الصوت غير متوفرة على المتصفح', force: true);
      return null;
    }
    
    try {
      String? result;
      _isListening = true;
      notifyListeners();

      _speechRecognition!.lang = locale ?? _currentLanguage;
      
      // Listen for results
      _speechRecognition!.onResult.listen((event) {
        try {
          if (event.results != null && event.results!.length > 0) {
            final resultItem = event.results![0];
            if (resultItem.length != null && resultItem.length! > 0) {
              final alternative = resultItem.item(0);
              if (alternative != null) {
                result = alternative.transcript;
              }
            }
          }
        } catch (e) {
          debugPrint('Error processing speech result: $e');
        }
      });
      
      // Listen for errors
      _speechRecognition!.onError.listen((event) {
        debugPrint('Speech recognition error: $event');
        _isListening = false;
        notifyListeners();
      });
      
      // Listen for end
      _speechRecognition!.onEnd.listen((_) {
        _isListening = false;
        notifyListeners();
      });
      
      _speechRecognition!.start();
      
      // Wait for result (with timeout)
      await Future.delayed(Duration(seconds: 5));
      
      if (_isListening) {
        await stopListening();
      }
      
      return result;
    } catch (e) {
      debugPrint('Error listening: $e');
      _isListening = false;
      notifyListeners();
      return null;
    }
  }

  /// Stop listening
  Future<void> stopListening() async {
    try {
      if (_speechRecognition != null) {
        _speechRecognition!.stop();
      }
      _isListening = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping listening: $e');
    }
  }

  /// Set speech rate
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.1, 2.0);
    await _saveSettings();
    notifyListeners();
  }

  /// Set volume
  Future<void> setVolume(double vol) async {
    _volume = vol.clamp(0.0, 1.0);
    await _saveSettings();
    notifyListeners();
  }

  /// Set pitch
  Future<void> setPitch(double p) async {
    _pitch = p.clamp(0.5, 2.0);
    await _saveSettings();
    notifyListeners();
  }

  /// Change language
  Future<void> setLanguage(String languageCode) async {
    _currentLanguage = languageCode;
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
