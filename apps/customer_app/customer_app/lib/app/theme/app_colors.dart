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

  // Reference UI colors
  static const Color addButtonRed = Color(0xFFE53935);
  static const Color priceGreen = Color(0xFF1B5E20);
  static const Color saveBadgeGreen = Color(0xFF4CAF50);
  static const Color coinGold = Color(0xFFD4A017);
  static const Color sectionDotGreen = Color(0xFF66BB6A);

  // Budget tile border colors
  static const Color budgetBlue = Color(0xFF90CAF9);
  static const Color budgetGreen = Color(0xFFA5D6A7);
  static const Color budgetGold = Color(0xFFFFD54F);
  static const Color budgetPink = Color(0xFFEF9A9A);

  // Category tile pastel backgrounds
  static const Color pastelOrange = Color(0xFFFFF3E0);
  static const Color pastelPink = Color(0xFFFCE4EC);
  static const Color pastelGreen = Color(0xFFE8F5E9);
  static const Color pastelBlue = Color(0xFFE3F2FD);
  static const Color pastelPurple = Color(0xFFF3E5F5);
  static const Color pastelYellow = Color(0xFFFFFDE7);
  static const Color pastelTeal = Color(0xFFE0F2F1);
  static const Color pastelRed = Color(0xFFFFEBEE);

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
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = neutral100;
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = neutral200;
  static const Color inputBackground = neutral100;

  // Glass/Translucency
  static const Color glassFill = Color(0xB3FFFFFF); // 70% white
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white
  static const Color overlayDark = Color(0x801A1C1E); // 50% dark

  // Text
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
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

  // WhatsApp
  static const Color whatsApp = Color(0xFF25D366);
}
