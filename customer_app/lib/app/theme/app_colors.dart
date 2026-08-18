import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand
  static const Color primary = Color(0xFF2B5C4B);
  static const Color primaryLight = Color(0xFF4A826D);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFD4A373);

  // Backgrounds
  static const Color background = Color(0xFFF4F6F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEDF2F0);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFEBEBEB);

  // Glass/Translucency
  static const Color glassFill = Color(0x80FFFFFF); // 50% white
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white

  // Text
  static const Color textPrimary = Color(0xFF1E2120);
  static const Color textSecondary = Color(0xFF6B726F);
  static const Color textDisabled = Color(0xFFA1A6A3);

  // Status
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);
}
