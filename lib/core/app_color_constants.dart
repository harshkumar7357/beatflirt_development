import 'package:flutter/material.dart';

class AppColors {

  //primary 
  // Primary Colors
  static const Color primary = Color(0xFF4A90E2);
  static const Color secondary = Color(0xFF50E3C2);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color scaffoldBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);

  // Accent Colors
  static const Color accentPink = Color(0xFFFF2D78);


  // Border 
  static const Color border = Color(0xFFF0E0E0);
  static const Color border2 = Color(0xFFE0E0E0);

  // ─── Glass Effect Helpers ─────────────────────────────────────────
  static Color glassWhite = Colors.white.withOpacity(0.08);
  static Color glassBorder = Colors.white.withOpacity(0.12);

  // ─── Shadow Presets ───────────────────────────────────────────────
  static List<BoxShadow> accentGlow({double opacity = 0.35, double blur = 16}) => [
        BoxShadow(color: accentPink.withOpacity(opacity), blurRadius: blur, offset: const Offset(0, 6)),
      ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 12)),
  ];

  // ─── Animation Durations ──────────────────────────────────────────
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration entrance = Duration(milliseconds: 600);

  // ─── Border Radii ─────────────────────────────────────────────────
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 28;
  static const double radiusPill = 36;
}
