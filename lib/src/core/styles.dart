import 'package:flutter/material.dart';

/// Production-grade theme system with Material 3 design
/// 
/// Features:
/// - Professional color palettes (inspired by Google Material Design)
/// - Proper contrast ratios for accessibility (WCAG AA compliant)
/// - Soft dark surfaces (not pure black)
/// - Consistent text hierarchy
/// - Semantic color naming
class AppStyles {
  // ============================================================================
  // COLOR PALETTE - Light Theme
  // ============================================================================
  
  // Primary colors - Agricultural green theme
  static const Color _lightPrimary = Color(0xFF2E7D32); // Green 800
  static const Color _lightOnPrimary = Color(0xFFFFFFFF);
  static const Color _lightPrimaryContainer = Color(0xFFA5D6A7); // Green 200
  static const Color _lightOnPrimaryContainer = Color(0xFF1B5E20); // Green 900
  
  // Secondary colors - Warm accent
  static const Color _lightSecondary = Color(0xFFEF6C00); // Orange 800
  static const Color _lightOnSecondary = Color(0xFFFFFFFF);
  static const Color _lightSecondaryContainer = Color(0xFFFFCC80); // Orange 200
  static const Color _lightOnSecondaryContainer = Color(0xFFE65100); // Orange 900
  
  // Surface colors - Soft neutrals (NO pure white)
  static const Color _lightSurface = Color(0xFFFAFAFA); // Soft off-white surface
  static const Color _lightSurfaceVariant = Color(0xFFF0F0F0); // Slightly darker variant
  static const Color _lightOnSurface = Color(0xFF1C1B1F); // Near black
  static const Color _lightOnSurfaceVariant = Color(0xFF49454F); // Medium grey
  
  // Background - Even softer than surface for depth
  static const Color _lightBackground = Color(0xFFF5F5F5);
  static const Color _lightOnBackground = Color(0xFF1C1B1F);
  
  // Error colors
  static const Color _lightError = Color(0xFFB3261E);
  static const Color _lightOnError = Color(0xFFFFFFFF);
  static const Color _lightErrorContainer = Color(0xFFF9DEDC);
  static const Color _lightOnErrorContainer = Color(0xFF410E0B);
  
  // Outline
  static const Color _lightOutline = Color(0xFF79747E);
  static const Color _lightOutlineVariant = Color(0xFFCAC4D0);
  
  // ============================================================================
  // COLOR PALETTE - Dark Theme
  // ============================================================================
  
  // Primary colors - Brighter for dark mode
  static const Color _darkPrimary = Color(0xFF81C784); // Green 300
  static const Color _darkOnPrimary = Color(0xFF003300); // Very dark green
  static const Color _darkPrimaryContainer = Color(0xFF1B5E20); // Green 900
  static const Color _darkOnPrimaryContainer = Color(0xFFA5D6A7); // Green 200
  
  // Secondary colors
  static const Color _darkSecondary = Color(0xFFFFB74D); // Orange 300
  static const Color _darkOnSecondary = Color(0xFF4A2800);
  static const Color _darkSecondaryContainer = Color(0xFFE65100); // Orange 900
  static const Color _darkOnSecondaryContainer = Color(0xFFFFCC80); // Orange 200
  
  // Surface colors - Soft dark (NO pure black)
  static const Color _darkSurface = Color(0xFF2C2C2E); // Softer dark surface (iOS-inspired)
  static const Color _darkSurfaceVariant = Color(0xFF3A3A3C); // Elevated surface
  static const Color _darkOnSurface = Color(0xFFE6E1E5); // Off white
  static const Color _darkOnSurfaceVariant = Color(0xFFCAC4D0); // Light grey
  
  // Background - Darker than surface for proper hierarchy
  static const Color _darkBackground = Color(0xFF1C1C1E);
  static const Color _darkOnBackground = Color(0xFFE6E1E5);
  
  // Error colors
  static const Color _darkError = Color(0xFFF2B8B5);
  static const Color _darkOnError = Color(0xFF601410);
  static const Color _darkErrorContainer = Color(0xFF8C1D18);
  static const Color _darkOnErrorContainer = Color(0xFFF9DEDC);
  
  // Outline
  static const Color _darkOutline = Color(0xFF938F99);
  static const Color _darkOutlineVariant = Color(0xFF49454F);
  
  // ============================================================================
  // LIGHT THEME
  // ============================================================================
  
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color scheme - Single source of truth
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: _lightPrimary,
      onPrimary: _lightOnPrimary,
      primaryContainer: _lightPrimaryContainer,
      onPrimaryContainer: _lightOnPrimaryContainer,
      secondary: _lightSecondary,
      onSecondary: _lightOnSecondary,
      secondaryContainer: _lightSecondaryContainer,
      onSecondaryContainer: _lightOnSecondaryContainer,
      tertiary: Color(0xFF6750A4), // Purple accent
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFE8DEF8),
      onTertiaryContainer: Color(0xFF21005D),
      error: _lightError,
      onError: _lightOnError,
      errorContainer: _lightErrorContainer,
      onErrorContainer: _lightOnErrorContainer,
      background: _lightBackground,
      onBackground: _lightOnBackground,
      surface: _lightSurface,
      onSurface: _lightOnSurface,
      surfaceVariant: _lightSurfaceVariant,
      onSurfaceVariant: _lightOnSurfaceVariant,
      outline: _lightOutline,
      outlineVariant: _lightOutlineVariant,
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF313033),
      onInverseSurface: Color(0xFFF4EFF4),
      inversePrimary: _darkPrimary,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: _lightBackground,
    
    // AppBar theme - Rich colored background for brand contrast
    appBarTheme: AppBarTheme(
      backgroundColor: _lightPrimary,
      foregroundColor: brandWhite,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 3,
      shadowColor: _lightPrimary.withOpacity(0.3),
      titleTextStyle: TextStyle(
        color: _lightOnPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(color: _lightOnPrimary, size: 24),
    ),
    
    // Card theme
    cardTheme: CardThemeData(
      color: _lightSurface,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _lightOutlineVariant, width: 0.5),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    
    // Text theme - Professional typography hierarchy
    textTheme: TextTheme(
      // Display styles
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25, color: _lightOnSurface),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, letterSpacing: 0, color: _lightOnSurface),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, letterSpacing: 0, color: _lightOnSurface),
      
      // Headline styles
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: 0, color: _lightOnSurface),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, letterSpacing: 0, color: _lightOnSurface),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0, color: _lightOnSurface),
      
      // Title styles
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 0, color: _lightOnSurface),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15, color: _lightOnSurface),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: _lightOnSurface),
      
      // Body styles
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: _lightOnSurface),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: _lightOnSurface),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: _lightOnSurfaceVariant),
      
      // Label styles
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: _lightOnSurface),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: _lightOnSurface),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: _lightOnSurfaceVariant),
    ),
    
    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(48),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        backgroundColor: _lightPrimary,
        foregroundColor: _lightOnPrimary,
        disabledBackgroundColor: _lightOnSurface.withOpacity(0.12),
        disabledForegroundColor: _lightOnSurface.withOpacity(0.38),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      ),
    ),
    
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: Size.fromHeight(48),
        backgroundColor: _lightPrimary,
        foregroundColor: _lightOnPrimary,
        disabledBackgroundColor: _lightOnSurface.withOpacity(0.12),
        disabledForegroundColor: _lightOnSurface.withOpacity(0.38),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: Size.fromHeight(48),
        foregroundColor: _lightPrimary,
        side: BorderSide(color: _lightOutline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _lightPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    ),
    
    // FloatingActionButton
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _lightPrimaryContainer,
      foregroundColor: _lightOnPrimaryContainer,
      elevation: 3,
      focusElevation: 3,
      hoverElevation: 4,
      highlightElevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    
    // Bottom Navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _lightSurface,
      selectedItemColor: _lightPrimary,
      unselectedItemColor: _lightOnSurfaceVariant,
      elevation: 3,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    ),
    
    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _lightOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _lightOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _lightError),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    
    // Divider
    dividerTheme: DividerThemeData(
      color: _lightOutlineVariant,
      thickness: 1,
      space: 1,
    ),
    
    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return _lightPrimary;
        return _lightOutline;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return _lightPrimaryContainer;
        return _lightSurfaceVariant;
      }),
    ),
    
    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: _lightSurfaceVariant,
      selectedColor: _lightSecondaryContainer,
      disabledColor: _lightOnSurface.withOpacity(0.12),
      labelStyle: TextStyle(color: _lightOnSurfaceVariant),
      side: BorderSide(color: _lightOutline, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
  
  // ============================================================================
  // DARK THEME
  // ============================================================================
  
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Color scheme - Single source of truth
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: _darkPrimary,
      onPrimary: _darkOnPrimary,
      primaryContainer: _darkPrimaryContainer,
      onPrimaryContainer: _darkOnPrimaryContainer,
      secondary: _darkSecondary,
      onSecondary: _darkOnSecondary,
      secondaryContainer: _darkSecondaryContainer,
      onSecondaryContainer: _darkOnSecondaryContainer,
      tertiary: Color(0xFFCFBCFF), // Purple accent
      onTertiary: Color(0xFF381E72),
      tertiaryContainer: Color(0xFF4F378B),
      onTertiaryContainer: Color(0xFFEADDFF),
      error: _darkError,
      onError: _darkOnError,
      errorContainer: _darkErrorContainer,
      onErrorContainer: _darkOnErrorContainer,
      background: _darkBackground,
      onBackground: _darkOnBackground,
      surface: _darkSurface,
      onSurface: _darkOnSurface,
      surfaceVariant: _darkSurfaceVariant,
      onSurfaceVariant: _darkOnSurfaceVariant,
      outline: _darkOutline,
      outlineVariant: _darkOutlineVariant,
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE6E1E5),
      onInverseSurface: Color(0xFF313033),
      inversePrimary: _lightPrimary,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: _darkBackground,
    
    // AppBar theme - Dark primary background for brand contrast
    appBarTheme: AppBarTheme(
      backgroundColor: _darkPrimaryContainer,
      foregroundColor: brandWhite,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 3,
      shadowColor: Colors.black.withOpacity(0.5),
      titleTextStyle: TextStyle(
        color: _darkOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(color: _darkOnSurface, size: 24),
    ),
    
    // Card theme
    cardTheme: CardThemeData(
      color: _darkSurface,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _darkOutlineVariant, width: 0.5),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    
    // Text theme - Professional typography hierarchy
    textTheme: TextTheme(
      // Display styles
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25, color: _darkOnSurface),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, letterSpacing: 0, color: _darkOnSurface),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, letterSpacing: 0, color: _darkOnSurface),
      
      // Headline styles
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: 0, color: _darkOnSurface),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, letterSpacing: 0, color: _darkOnSurface),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0, color: _darkOnSurface),
      
      // Title styles
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 0, color: _darkOnSurface),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15, color: _darkOnSurface),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: _darkOnSurface),
      
      // Body styles
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: _darkOnSurface),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: _darkOnSurface),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: _darkOnSurfaceVariant),
      
      // Label styles
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: _darkOnSurface),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: _darkOnSurface),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: _darkOnSurfaceVariant),
    ),
    
    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(48),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.3),
        backgroundColor: _darkPrimary,
        foregroundColor: _darkOnPrimary,
        disabledBackgroundColor: _darkOnSurface.withOpacity(0.12),
        disabledForegroundColor: _darkOnSurface.withOpacity(0.38),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      ),
    ),
    
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: Size.fromHeight(48),
        backgroundColor: _darkPrimary,
        foregroundColor: _darkOnPrimary,
        disabledBackgroundColor: _darkOnSurface.withOpacity(0.12),
        disabledForegroundColor: _darkOnSurface.withOpacity(0.38),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: Size.fromHeight(48),
        foregroundColor: _darkPrimary,
        side: BorderSide(color: _darkOutline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _darkPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    ),
    
    // FloatingActionButton
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _darkPrimaryContainer,
      foregroundColor: _darkOnPrimaryContainer,
      elevation: 3,
      focusElevation: 3,
      hoverElevation: 4,
      highlightElevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    
    // Bottom Navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _darkSurface,
      selectedItemColor: _darkPrimary,
      unselectedItemColor: _darkOnSurfaceVariant,
      elevation: 3,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    ),
    
    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _darkOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _darkOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _darkError),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    
    // Divider
    dividerTheme: DividerThemeData(
      color: _darkOutlineVariant,
      thickness: 1,
      space: 1,
    ),
    
    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return _darkPrimary;
        return _darkOutline;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return _darkPrimaryContainer;
        return _darkSurfaceVariant;
      }),
    ),
    
    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: _darkSurfaceVariant,
      selectedColor: _darkSecondaryContainer,
      disabledColor: _darkOnSurface.withOpacity(0.12),
      labelStyle: TextStyle(color: _darkOnSurfaceVariant),
      side: BorderSide(color: _darkOutline, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
  
  // ============================================================================
  // BRANDING COLORS - Intentional & Fixed
  // ============================================================================
  
  /// Brand white for logo/text - slightly softened to avoid pure white glare
  /// Use this for the "Mzra3ti" branding element to maintain consistent identity
  static const Color brandWhite = Color(0xFFFAFAFA);
  
  /// Brand icon background - subtle white overlay for contrast
  static const Color brandIconBg = Color(0x26FFFFFF); // 15% white
  
  // ============================================================================
  // MODERN GRADIENT COLORS - Premium Farming App Design
  // ============================================================================
  
  /// Calm green gradient colors for farming theme
  static const List<Color> greenGradient = [
    Color(0xFF10B981), // Emerald 500
    Color(0xFF059669), // Emerald 600
    Color(0xFF047857), // Emerald 700
  ];
  
  /// Calm blue gradient colors
  static const List<Color> blueGradient = [
    Color(0xFF3B82F6), // Blue 500
    Color(0xFF2563EB), // Blue 600
    Color(0xFF1D4ED8), // Blue 700
  ];
  
  /// Emerald gradient (lighter green)
  static const List<Color> emeraldGradient = [
    Color(0xFF34D399), // Emerald 400
    Color(0xFF10B981), // Emerald 500
    Color(0xFF059669), // Emerald 600
  ];
  
  /// White to light gradient
  static const List<Color> whiteGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFF9FAFB), // Gray 50
    Color(0xFFF3F4F6), // Gray 100
  ];
  
  /// Premium shadow for cards (deep, soft)
  static List<BoxShadow> get premiumCardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 20,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 6,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
  
  /// Extra deep shadow for elevated elements
  static List<BoxShadow> get deepShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 24,
      offset: Offset(0, 12),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 8,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];
  
  /// Status indicator colors
  static const Color statusGood = Color(0xFF10B981); // Green
  static const Color statusWarning = Color(0xFFF59E0B); // Yellow/Amber
  static const Color statusAlert = Color(0xFFEF4444); // Red
  
  // ============================================================================
  // BACKWARD COMPATIBILITY & HELPER GETTERS
  // ============================================================================
  
  // Backward compatibility - default to light theme
  static final ThemeData theme = lightTheme;
  
  // Helper getters for quick access (use Theme.of(context) in widgets instead)
  static Color primaryGreen = _lightPrimary;
  static Color darkPrimaryGreen = _darkPrimary;
  
  // Reusable text styles (prefer using Theme.of(context).textTheme instead)
  static final TextStyle headerTitle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white);
  static final TextStyle headerSubtitle = TextStyle(fontSize: 14, color: Colors.white70);
  static final TextStyle cardLabel = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static final TextStyle cardValue = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  // Accessibility & icon-first UI - Enhanced for elderly users
  static const double largeIconSize = 80.0; // Increased from 72
  static const double extraLargeIconSize = 96.0; // For main features
  static final TextStyle bigValue = TextStyle(
    fontSize: 48, // Increased from 40
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );
  static final TextStyle hugeValue = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w900,
    letterSpacing: -2,
  );
  static final ButtonStyle largeRoundedButton = ElevatedButton.styleFrom(
    minimumSize: Size.fromHeight(72), // Increased from 64
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
  );
  
  // Large touch targets for accessibility
  static const double minTouchTarget = 48.0;
  static const double preferredTouchTarget = 56.0;

  // Floating action button spacing
  static const double fabBottomOffset = 64.0;
  static const double fabRightOffset = 16.0;

  // Dashboard specific (prefer using theme styles)
  static final TextStyle dashboardTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.w800);
  static final TextStyle dashboardSubtitle = TextStyle(fontSize: 14);
}
