import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Color Tokens Extracted directly from CITY BYTES Logo (Royal Violet & Lavender)
  static const Color lightPrimary = Color(0xFF4C1D95); // Deep Royal Violet ("CITY BYTES" text & cloche)
  static const Color lightPrimaryContainer = Color(0xFFEDE9FE); // Soft Lavender Selection Tint
  static const Color lightSecondary = Color(0xFF7C3AED); // Vibrant Lavender Steam Highlight
  static const Color lightBackground = Color(0xFFF8F5FF); // Soft Lavender Off-White Scaffold
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure White Cards/AppBars
  static const Color lightSurfaceVariant = Color(0xFFF3E8FF); // Lavender Input Fills
  static const Color lightTextPrimary = Color(0xFF2E1065); // Deep Royal Purple Headings
  static const Color lightTextSecondary = Color(0xFF6B7280); // Muted Secondary Text
  static const Color lightOutline = Color(0xFFDDD6FE); // Soft Lavender Borders & Dividers

  // Dark Mode Color Tokens Extracted from Logo Night Tones
  static const Color darkPrimary = Color(0xFFA78BFA); // Light Vibrant Lavender
  static const Color darkPrimaryContainer = Color(0xFF2E1B4E); // Deep Midnight Lavender Tint
  static const Color darkSecondary = Color(0xFFC4B5FD); // Bright Lavender Accent
  static const Color darkBackground = Color(0xFF0F0A1C); // Deep Midnight Purple
  static const Color darkSurface = Color(0xFF180E29); // Elevated Midnight Violet Cards
  static const Color darkSurfaceVariant = Color(0xFF25173E); // Dark Input Fills
  static const Color darkTextPrimary = Color(0xFFF5F3FF); // Soft Lavender White Headings
  static const Color darkTextSecondary = Color(0xFF9CA3AF); // Muted Secondary Text
  static const Color darkOutline = Color(0xFF3B2563); // Dark Violet Borders & Dividers

  // Functional Utility Tokens
  static const Color ratingGold = Color(0xFFFFB800);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Logo Theme Gradients
  static const LinearGradient logoGradientLight = LinearGradient(
    colors: [Color(0xFF2E1065), Color(0xFF6D28D9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient logoGradientDark = LinearGradient(
    colors: [Color(0xFF0F0A1C), Color(0xFF2E1B4E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
