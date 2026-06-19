import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFF9C27B0); // Purple
  static const Color primaryLight = Color(0xFFE1BEE7);
  static const Color primaryDark = Color(0xFF7B1FA2);

  // Secondary Colors
  static const Color secondaryColor = Color(0xFFE91E63); // Pink
  static const Color secondaryLight = Color(0xFFF8BBD0);

  // Background Colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color surfaceColor = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Colors.white;

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF9C27B0),
    Color(0xFFE91E63),
  ];

  static const List<Color> heartGradient = [
    Color(0xFFFF4081),
    Color(0xFFFF80AB),
  ];

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Other Colors
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color shadowColor = Color(0x1A000000);
  static const Color overlayColor = Color(0x80000000);
  
  // Profile Specific Colors
  static const Color onlineIndicator = Color(0xFF4CAF50);
  static const Color offlineIndicator = Color(0xFF9E9E9E);
  static const Color verifiedBadge = Color(0xFF2196F3);
  static const Color premiumBadge = Color(0xFFFFD700);
}