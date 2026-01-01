import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'core/constants.dart';
import 'core/styles.dart';
import 'services/language_service.dart';
import 'services/theme_service.dart';
import 'features/expenses/presentation/screens/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/farms/presentation/screens/add_farm_screen.dart';
import 'features/expenses/presentation/screens/home_screen.dart';
import 'features/irrigation/presentation/screens/irrigation_screen.dart';
import 'features/expenses/presentation/screens/expenses_screen.dart';
import 'features/harvest/presentation/screens/harvest_screen.dart';
import 'features/journal/presentation/screens/journal_screen.dart';
import 'features/reports/presentation/screens/reports_screen.dart';
import 'features/weather/presentation/screens/weather_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';

class Mzra3tiApp extends StatelessWidget {
  const Mzra3tiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageService()),
        ChangeNotifierProvider(create: (_) => ThemeService()..initialize()),
      ],
      child: Consumer2<LanguageService, ThemeService>(
        builder: (context, languageService, themeService, child) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            
            // Professional theme configuration
            theme: AppStyles.lightTheme,
            darkTheme: AppStyles.darkTheme,
            themeMode: themeService.themeMode,
            
            // Smooth animated theme transitions
            themeAnimationDuration: Duration(milliseconds: 300),
            themeAnimationCurve: Curves.easeInOut,
            
            locale: languageService.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar'), // Darija (Arabic)
              Locale('en'), // English
              Locale('fr'), // French
            ],
            initialRoute: '/',
            routes: {
              '/': (ctx) => const SplashScreen(),
              '/onboarding': (ctx) => const OnboardingScreen(),
              '/login': (ctx) => const LoginScreen(),
              '/register': (ctx) => const RegisterScreen(),
              '/profile': (ctx) => const ProfileScreen(),
              '/farms/add': (ctx) => const AddFarmScreen(),
              '/home': (ctx) => const Mzra3tiHomeScreen(),
              '/irrigations': (ctx) => const IrrigationScreen(),
              '/expenses': (ctx) => const ExpensesScreen(),
              '/harvests': (ctx) => const HarvestScreen(),
              '/journal': (ctx) => const JournalScreen(),
              '/reports': (ctx) => const ReportsScreen(),
              '/weather': (ctx) => const WeatherScreen(),
              '/settings': (ctx) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
