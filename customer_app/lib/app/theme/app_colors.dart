import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand
  static const Color primary = Color(0xFF235347); // Deep natural green
  static const Color primaryLight = Color(0xFF417A6A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFC29B72); // Warm neutral

  // Backgrounds
  static const Color background = Color(0xFFF7F8F7); // Soft off-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEFEFEF);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE6E8E6);

  // Glass/Translucency
  static const Color glassFill = Color(0x99FFFFFF); // 60% white
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white

  // Text
  static const Color textPrimary = Color(0xFF212523); // Charcoal
  static const Color textSecondary = Color(0xFF6D726F); // Muted gray
  static const Color textDisabled = Color(0xFFA5A9A7);

  // Status (Restrained/Muted)
  static const Color success = Color(0xFF4A7C59); // Muted green
  static const Color warning = Color(0xFFD98E36); // Warm amber
  static const Color error = Color(0xFFC75D53); // Muted red
  static const Color info = Color(0xFF4B7B96); // Restrained blue
}
