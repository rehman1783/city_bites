import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette - Navy Blue & Orange matching PDF Specification
  static const Color primary = Color(0xFF0D1B2A); // Premium Navy Blue
  static const Color primaryDark = Color(0xFF0A1118); // Deep Dark Navy
  static const Color primaryLight = Color(0xFF1B263B); // Slate Navy
  static const Color primaryContainer = Color(0xFFE0E8F5); // Light Navy Tint

  // Accent & Action Colors - Vibrant Orange
  static const Color accentOrange = Color(0xFFFF6F00); // Premium Orange
  static const Color accentOrangeLight = Color(0xFFFF8F00);
  static const Color accentOrangeDark = Color(0xFFE65100);

  // Light Theme Neutrals (Soft White & Slate)
  static const Color lightBackground = Color(0xFFF8F9FA); // Soft Off-White
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0D1B2A); // Navy Text
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Dark Theme Neutrals (Deep Navy)
  static const Color darkBackground = Color(0xFF0A1118);
  static const Color darkSurface = Color(0xFF0D1B2A);
  static const Color darkCard = Color(0xFF162032);
  static const Color darkBorder = Color(0xFF2B3A4E);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Functional & Accent Colors
  static const Color ratingGold = Color(0xFFFFB800);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF6F00), Color(0xFFFF8F00)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF162032), Color(0xFF1B263B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
