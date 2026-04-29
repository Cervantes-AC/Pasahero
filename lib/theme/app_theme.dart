import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import '../utils/responsive.dart';

class AppTheme {
  /// Base theme — used as-is on mobile.
  static ThemeData get light => _build();

  /// Driver mode theme — dark, professional, high-contrast.
  static ThemeData get dark => _build(
    isDark: true,
    primary: AppColors.driverAccent,
    background: AppColors.driverBg,
    surface: AppColors.driverSurface,
    textPrimary: AppColors.driverText,
    textSecondary: AppColors.driverTextMuted,
    border: AppColors.driverBorder,
  );

  /// Context-aware theme that scales button/input sizes for the current device.
  static ThemeData responsive(BuildContext context, {bool isDriver = false}) {
    final btnH = Responsive.buttonHeight(context);
    final fs = Responsive.fontScale(context);
    final r = Responsive.radius(context, base: 16);
    final inputR = Responsive.radius(context, base: 14);

    if (isDriver) {
      return _build(
        isDark: true,
        primary: AppColors.driverAccent,
        background: AppColors.driverBg,
        surface: AppColors.driverSurface,
        textPrimary: AppColors.driverText,
        textSecondary: AppColors.driverTextMuted,
        border: AppColors.driverBorder,
        buttonHeight: btnH,
        fontScale: fs,
        buttonRadius: r,
        inputRadius: inputR,
      );
    }

    return _build(
      buttonHeight: btnH,
      fontScale: fs,
      buttonRadius: r,
      inputRadius: inputR,
    );
  }

  static ThemeData _build({
    bool isDark = false,
    Color primary = AppColors.primary,
    Color background = AppColors.background,
    Color surface = AppColors.surface,
    Color textPrimary = AppColors.textPrimary,
    Color textSecondary = AppColors.textSecondary,
    Color border = AppColors.border,
    double buttonHeight = 58,
    double fontScale = 1.0,
    double buttonRadius = 18,
    double inputRadius = 16,
  }) => ThemeData(
    useMaterial3: true,
    brightness: isDark ? Brightness.dark : Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: primary,
      onPrimary: isDark ? Colors.black : Colors.white,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      surface: surface,
      onSurface: textPrimary,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: background,
    fontFamily: 'Inter',

    // Status bar
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        fontFamily: 'Inter',
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(color: textPrimary),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    ),

    // Typography
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32 * fontScale,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        letterSpacing: -1,
      ),
      displayMedium: TextStyle(
        fontSize: 28 * fontScale,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(
        fontSize: 20 * fontScale,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 16 * fontScale, color: textPrimary),
      bodyMedium: TextStyle(fontSize: 14 * fontScale, color: textSecondary),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: isDark ? Colors.black : Colors.white,
        minimumSize: Size(double.infinity, buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        elevation: 0,
        textStyle: TextStyle(
          fontSize: 16 * fontScale,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
          fontFamily: 'Inter',
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        minimumSize: Size(double.infinity, buttonHeight),
        side: BorderSide(color: primary, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        textStyle: TextStyle(
          fontSize: 16 * fontScale,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? surface : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      hintStyle: TextStyle(
        color: AppColors.textMuted,
        fontSize: 15 * fontScale,
      ),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: border),
      ),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: isDark ? border : Colors.white,
      selectedColor: primary,
      labelStyle: TextStyle(
        fontSize: 12 * fontScale,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : textPrimary,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(color: border),
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primary;
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary.withValues(alpha: 0.3);
        }
        return border;
      }),
    ),
  );
}
