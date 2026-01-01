import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../core/styles.dart';
import '../../../../services/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();

    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for animation and check if user is logged in
    await Future.delayed(Duration(milliseconds: 1600));
    
    if (!mounted) return;

    final userService = UserService();
    final isLoggedIn = await userService.isLoggedIn();

    if (isLoggedIn) {
      // User is logged in, go directly to home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // User not logged in, show onboarding/login
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final green = AppStyles.primaryGreen;

    return Scaffold(
      backgroundColor: green,
      body: SafeArea(
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                  ),
                  child: Center(
                    child: Icon(Icons.grass, color: green, size: 56),
                  ),
                ),
                SizedBox(height: 18),
                Text(l10n.appName, style: AppStyles.headerTitle.copyWith(color: Colors.white)),
                SizedBox(height: 6),
                Text(l10n.splashSlogan, style: AppStyles.headerSubtitle.copyWith(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
