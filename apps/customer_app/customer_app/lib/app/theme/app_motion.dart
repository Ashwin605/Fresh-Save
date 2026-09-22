import 'package:flutter/animation.dart';

abstract class AppMotion {
  // Durations
  static const Duration micro = Duration(milliseconds: 150);
  static const Duration short = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration long = Duration(milliseconds: 800);

  // Curves
  static const Curve standard = Curves.easeOutCubic;
  static const Curve decelerate = Curves.easeOutQuad;
  static const Curve accelerate = Curves.easeInQuad;
  
  // Springs (simulated using standard curves or custom physics elsewhere, but we define the timing curve here)
  static const Curve spring = Curves.easeOutBack;
  static const Curve gentleSpring = Curves.easeOutQuart;
}
