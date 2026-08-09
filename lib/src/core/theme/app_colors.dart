import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette - Vibrant Food Red / Orange Accent
  static const Color primary = Color(0xFFFF4B3A);
  static const Color primaryDark = Color(0xFFD93829);
  static const Color primaryLight = Color(0xFFFF7A6E);
  static const Color primaryContainer = Color(0xFFFFEBEA);

  // Secondary Palette - Deep Navy / Slate
  static const Color secondary = Color(0xFF1E2638);
  static const Color secondaryLight = Color(0xFF2C364F);

  // Light Theme Neutrals
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // Dark Theme Neutrals
  static const Color darkBackground = Color(0xFF121824);
  static const Color darkSurface = Color(0xFF1A2232);
  static const Color darkCard = Color(0xFF1E2738);
  static const Color darkBorder = Color(0xFF2D3748);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // Accent & Functional Colors
  static const Color ratingGold = Color(0xFFFFB800);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF4B3A), Color(0xFFFF7A3D)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1E2738), Color(0xFF263248)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
