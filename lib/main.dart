import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Force light mode system UI on Android & iOS
  // This ensures status bar, navigation bar stay light
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Dark icons for light background
      statusBarBrightness: Brightness.light, // iOS: light status bar
      systemNavigationBarColor: Colors.white, // Android navigation bar
      systemNavigationBarIconBrightness: Brightness.dark, // Dark nav icons
    ),
  );
  
  // later: initialize local DB here
  runApp(const Mzra3tiApp());
}
