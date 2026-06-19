import 'package:flutter/material.dart';

class AppConstants {
  // API Base URL
  static const String baseUrl = 'https://app.beatflirtevent.com/App/user';
  static const String singleProfileEndpoint = '$baseUrl/signle_user_profile';
  // Both single & couple use the same endpoint; profile_type in response differentiates
  static const String coupleProfileEndpoint = '$baseUrl/signle_user_profile';

  // Web URLs
  static const String singleProfileWebUrl =
      'https://www.beatflirtevent.com/view-single-profile';
  static const String coupleProfileWebUrl =
      'https://www.beatflirtevent.com/view-couple-profile';
  static const String signupWebUrl =
      'https://www.beatflirtevent.com/signup';
}

class AppColors {
  static const Color primary = Color(0xFFE91E63); // Pink/Red accent
  static const Color primaryDark = Color(0xFFC2185B);
  static const Color secondary = Color(0xFF1A1A2E); // Dark navy
  static const Color accent = Color(0xFFFF4081);
  static const Color background = Color(0xFF0F0F1A);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color cardDark = Color(0xFF16213E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF6C6C80);
  static const Color divider = Color(0xFF2A2A3E);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color gold = Color(0xFFFFD700);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE91E63), Color(0xFFFF5252)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  static const TextStyle tabLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );
}
