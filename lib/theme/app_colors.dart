import 'package:flutter/material.dart';

class AppColors {
  // Primary brand blue
  static const primary = Color(0xFF00409A);
  static const primaryDark = Color(0xFF003580);
  static const primaryLight = Color(0xFF1A5BB5);

  // Accent colors
  static const red = Color(0xFFFF0000);
  static const redDark = Color(0xFFE60000);
  static const yellow = Color(0xFFFFCC00);
  static const yellowDark = Color(0xFFE6B800);
  static const green = Color(0xFF22C55E);
  static const greenDark = Color(0xFF16A34A);
  static const orange = Color(0xFFF97316);

  // Driver mode accent
  static const driverPrimary = Color(0xFF0F172A);
  static const driverAccent = Color(0xFFFFCC00);

  // Neutrals
  static const muted = Color(0xFFF1F5F9);
  static const mutedForeground = Color(0xFF94A3B8);
  static const border = Color(0xFFE2E8F0);
  static const background = Color(0xFFF8FAFC);
  static const white = Colors.white;
  static const cardShadow = Color(0x0F000000);

  // Gradients
  static const passengerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const driverGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
  );

  static const successGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [green, greenDark],
  );
}
