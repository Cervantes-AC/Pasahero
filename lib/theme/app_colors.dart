import 'package:flutter/material.dart';

class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────────
  static const primary = Color(0xFF1A56DB); // vibrant blue
  static const primaryDark = Color(0xFF1347C0);
  static const primaryLight = Color(0xFF3B82F6);
  static const primarySurface = Color(0xFFEFF6FF); // blue-50

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const success = Color(0xFF16A34A);
  static const successLight = Color(0xFFF0FDF4);
  static const successSurface = Color(0xFFDCFCE7);
  static const error = Color(0xFFDC2626);
  static const errorLight = Color(0xFFFEF2F2);
  static const errorSurface = Color(0xFFFEE2E2);
  static const warning = Color(0xFFD97706);
  static const warningSurface = Color(0xFFFEF3C7);
  static const amber = Color(0xFFF59E0B);

  // ── Neutrals ───────────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const textTertiary = Color(0xFF94A3B8);
  static const surface = Color(0xFFF8FAFC);
  static const surfaceVariant = Color(0xFFF1F5F9);
  static const border = Color(0xFFE2E8F0);
  static const borderStrong = Color(0xFFCBD5E1);
  static const white = Colors.white;

  // ── Driver mode ────────────────────────────────────────────────────────────
  static const driverBg = Color(0xFF0F172A);
  static const driverSurface = Color(0xFF1E293B);
  static const driverBorder = Color(0xFF334155);
  static const driverAccent = Color(0xFFF59E0B); // amber
  static const driverAccentDark = Color(0xFFD97706);
  static const driverText = Color(0xFFF8FAFC);
  static const driverTextMuted = Color(0xFF94A3B8);

  // ── Legacy aliases (keep for compatibility) ────────────────────────────────
  static const primaryDarkLegacy = primaryDark;
  static const primaryLightLegacy = primaryLight;
  static const red = error;
  static const redDark = Color(0xFFB91C1C);
  static const yellow = amber;
  static const yellowDark = Color(0xFFB45309);
  static const green = success;
  static const greenDark = Color(0xFF15803D);
  static const orange = warning;
  static const muted = surfaceVariant;
  static const mutedForeground = textTertiary;
  static const background = surface;
  static const driverPrimary = driverBg;

  // ── Gradients ──────────────────────────────────────────────────────────────
  static const passengerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const driverGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [driverBg, driverSurface],
  );

  static const successGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [success, Color(0xFF15803D)],
  );
}
