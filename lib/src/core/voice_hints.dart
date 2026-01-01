import 'package:flutter/foundation.dart';

/// Small wrapper to allow future integration with a Text-to-Speech engine (flutter_tts).
///
/// Current implementation is a no-op unless `enabled` is set to true, in which case
/// it will print a debug line. This keeps the app "future-ready" while not adding
/// a runtime dependency now.
class VoiceHints {
  VoiceHints._internal();
  static final VoiceHints instance = VoiceHints._internal();

  /// When true, `speak` will attempt to give audio feedback. By default false.
  bool enabled = false;

  /// Speak a short hint (if enabled). Replace debugPrint with a real TTS call later.
  void speak(String text) {
    if (!enabled) return;
    // TODO: integrate `flutter_tts` or other TTS package here.
    debugPrint('VoiceHint: $text');
  }
}