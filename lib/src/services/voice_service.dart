// Platform-specific voice service
// Conditional exports based on platform
export 'voice_service_stub.dart'
    if (dart.library.html) 'voice_service_web.dart'
    if (dart.library.io) 'voice_service_mobile.dart';
