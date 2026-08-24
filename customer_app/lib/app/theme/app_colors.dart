import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand (Deep Forest Green & Vibrant Mint)
  static const Color primary = Color(0xFF1E4620); 
  static const Color primaryLight = Color(0xFF2E6331);
  static const Color primaryDark = Color(0xFF112A12);
  static const Color onPrimary = Color(0xFFFFFFFF);
  
  static const Color secondary = Color(0xFF00C853); // Vibrant Mint
  static const Color secondaryLight = Color(0xFF5EFB82);
  static const Color onSecondary = Color(0xFF000000);

  static const Color accent = Color(0xFFC29B72); // Warm neutral accent

  // Neutral / Grayscale
  static const Color neutral50 = Color(0xFFF9FAFA);
  static const Color neutral100 = Color(0xFFF3F5F4);
  static const Color neutral200 = Color(0xFFE5E8E6);
  static const Color neutral300 = Color(0xFFD2D6D3);
  static const Color neutral400 = Color(0xFFA5A9A7);
  static const Color neutral500 = Color(0xFF7A807C);
  static const Color neutral600 = Color(0xFF5C625E);
  static const Color neutral700 = Color(0xFF454B47);
  static const Color neutral800 = Color(0xFF2C322E);
  static const Color neutral900 = Color(0xFF1A1C1E);

  // Backgrounds & Surfaces
  static const Color background = neutral50; 
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = neutral100;
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color border = neutral200;
  static const Color divider = neutral200;
  static const Color inputBackground = neutral100;

  // Glass/Translucency
  static const Color glassFill = Color(0xB3FFFFFF); // 70% white
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white
  static const Color overlayDark = Color(0x801A1C1E); // 50% dark

  // Text
  static const Color textPrimary = neutral900;
  static const Color textSecondary = neutral600;
  static const Color textDisabled = neutral400;

  // Semantic Status
  static const Color success = Color(0xFF2E7D32); // Emerald
  static const Color successLight = Color(0xFFE8F5E9);
  
  static const Color warning = Color(0xFFF57C00); // Amber
  static const Color warningLight = Color(0xFFFFF3E0);
  
  static const Color error = Color(0xFFD32F2F); // Rose
  static const Color errorLight = Color(0xFFFFEBEE);
  
  static const Color info = Color(0xFF1976D2); // Blue
  static const Color infoLight = Color(0xFFE3F2FD);
}
