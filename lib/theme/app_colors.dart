import 'package:flutter/material.dart';

class AppColors {
  // ── Brand (Professional & Unique: Midnight & Gold) ────────────────────────
  static const primary = Color(0xFF0F172A); // Rich Slate/Navy
  static const accent = Color(0xFFF59E0B); // Amber/Gold
  static const secondary = Color(0xFF6366F1); // Indigo
  static const tertiary = Color(0xFF10B981); // Emerald

  static const primaryLight = Color(0xFF1E293B);
  static const primaryDark = Color(0xFF020617);

  static const accentLight = Color(0xFFFBBF24);
  static const accentDark = Color(0xFFD97706);

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const success = Color(0xFF10B981); // Emerald
  static const error = Color(0xFFEF4444); // Rose
  static const warning = Color(0xFFF59E0B); // Amber
  static const info = Color(0xFF3B82F6); // Blue

  // ── Neutrals (Clean & Modern) ─────────────────────────────────────────────
  static const background = Color(0xFFF8FAFC);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const textMuted = Color(0xFF94A3B8);
  static const border = Color(0xFFE2E8F0);
  static const borderStrong = Color(0xFFCBD5E1);

  // ── Glassmorphism & Effects ───────────────────────────────────────────────
  static final glassWhite = Colors.white.withValues(alpha: 0.7);
  static final glassBorder = Colors.white.withValues(alpha: 0.2);
  static final shadowColor = const Color(0xFF0F172A).withValues(alpha: 0.08);

  // ── Passenger Specific ─────────────────────────────────────────────────────
  static const passengerPrimary = primary;
  static const passengerAccent = accent;
  static const passengerSurface = Colors.white;

  // ── Driver mode (Darker Theme) ────────────────────────────────────────────
  static const driverBg = Color(0xFF020617);
  static const driverSurface = Color(0xFF0F172A);
  static const driverBorder = Color(0xFF1E293B);
  static const driverAccent = Color(0xFFF59E0B);
  static const driverAccentDark = Color(0xFFD97706);
  static const driverText = Color(0xFFF8FAFC);
  static const driverTextMuted = Color(0xFF64748B);

  // ── Legacy aliases (keep for compatibility) ────────────────────────────────
  static const primarySurface = Color(0xFFF1F5F9);
  static const successLight = Color(0xFFECFDF5);
  static const successSurface = Color(0xFFD1FAE5);
  static const errorLight = Color(0xFFFEF2F2);
  static const errorSurface = Color(0xFFFEE2E2);
  static const warningSurface = Color(0xFFFFF7ED);
  static const amber = Color(0xFFF59E0B);
  static const white = Colors.white;
  static const surfaceVariant = Color(0xFFF1F5F9);
  static const textTertiary = textMuted;
  static const red = error;
  static const redDark = Color(0xFFB91C1C);
  static const yellow = amber;
  static const yellowDark = Color(0xFFB45309);
  static const green = success;
  static const greenDark = Color(0xFF059669);
  static const orange = warning;
  static const muted = Color(0xFFF1F5F9);
  static const mutedForeground = textMuted;
  static const driverPrimary = driverBg;

  // ── Gradients ──────────────────────────────────────────────────────────────
  static const passengerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, Color(0xFFFFC107)],
  );

  static const driverGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [driverBg, driverSurface],
  );

  static const successGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [success, Color(0xFF059669)],
  );

  static const glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x4DFFFFFF), Color(0x1AFFFFFF)],
  );
}
