import 'package:flutter/material.dart';

/// Stub implementation - will be replaced by platform-specific implementation
class VoiceService extends ChangeNotifier {
  bool get isEnabled => throw UnsupportedError('No implementation');
  bool get isSpeaking => throw UnsupportedError('No implementation');
  bool get isListening => throw UnsupportedError('No implementation');
  double get speechRate => throw UnsupportedError('No implementation');
  double get volume => throw UnsupportedError('No implementation');
  double get pitch => throw UnsupportedError('No implementation');
  String get currentLanguage => throw UnsupportedError('No implementation');
  
  Future<void> toggleVoiceAssistance(bool enabled) async {
    throw UnsupportedError('No implementation');
  }
  
  Future<void> speak(String text, {bool force = false}) async {
    throw UnsupportedError('No implementation');
  }
  
  Future<void> startListening(Function(String) onResult, {Function()? onError}) async {
    throw UnsupportedError('No implementation');
  }
  
  void stopListening() {
    throw UnsupportedError('No implementation');
  }
  
  void dispose() {
    super.dispose();
  }
}
