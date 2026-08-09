import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Tokens
  static const Color primaryLight = Color(0xFFFF5722); // Saffron Red
  static const Color primaryContainerLight = Color(0xFFFBE9E7);
  static const Color secondaryLight = Color(0xFF00897B); // Teal
  static const Color backgroundLight = Color(0xFFF8F9FA); // Soft Off-White
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceVariantLight = Color(0xFFF1F3F4);
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color errorLight = Color(0xFFD32F2F);

  // Dark Mode Tokens
  static const Color primaryDark = Color(0xFFFF7043);
  static const Color primaryContainerDark = Color(0xFF3E2723);
  static const Color secondaryDark = Color(0xFF4DB6AC);
  static const Color backgroundDark = Color(0xFF121212); // Deep Neutral Dark
  static const Color surfaceDark = Color(0xFF1E1E1E); // Dark Grey Elevation
  static const Color surfaceVariantDark = Color(0xFF2C2C2C);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color dividerDark = Color(0xFF333333);
  static const Color errorDark = Color(0xFFEF5350);

  // Accent & Functional Colors
  static const Color ratingGold = Color(0xFFFFB800);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color cardShadow = Color(0x0D000000); // 5% opacity black
  static const Color cardShadowDark = Color(0x33000000); // 20% opacity black

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF5722), Color(0xFFFF7043)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFFFF5722), Color(0xFFD84315)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient splashGradientDark = LinearGradient(
    colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
