import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette - Royal Purple & Violet matching City Bites Logo
  static const Color primary = Color(0xFF6D28D9); // Rich Violet Purple
  static const Color primaryDark = Color(0xFF5B21B6); // Deep Violet
  static const Color primaryLight = Color(0xFF8B5CF6); // Electric Lavender
  static const Color primaryContainer = Color(0xFFF3E8FF); // Soft Lavender Container

  // Secondary Palette - Deep Plum & Midnight Violet
  static const Color secondary = Color(0xFF2E1065);
  static const Color secondaryLight = Color(0xFF4C1D95);

  // Light Theme Neutrals (Soft Lavender Whites)
  static const Color lightBackground = Color(0xFFF8F4FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE9D8FD);
  static const Color lightTextPrimary = Color(0xFF2E1065);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // Dark Theme Neutrals (Midnight Purple)
  static const Color darkBackground = Color(0xFF0F0A1C);
  static const Color darkSurface = Color(0xFF19102B);
  static const Color darkCard = Color(0xFF201636);
  static const Color darkBorder = Color(0xFF352554);
  static const Color darkTextPrimary = Color(0xFFFAF5FF);
  static const Color darkTextSecondary = Color(0xFFA78BFA);

  // Accent & Functional Colors
  static const Color ratingGold = Color(0xFFFFB800);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Gradients matching logo style
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF201636), Color(0xFF2A1C47)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFFF3E8FF), Color(0xFFE9D8FD)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
