import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

abstract class AppAnimations {
  // Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);

  // Curves
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve emphasizeCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.easeOutBack;

  // Staggering
  static const Duration staggerAmount = Duration(milliseconds: 100);

  // Common Animate Effects
  static List<Effect> get fadeSlideIn => [
        FadeEffect(duration: medium, curve: defaultCurve),
        SlideEffect(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
          duration: medium,
          curve: defaultCurve,
        ),
      ];

  static List<Effect> get fadeScaleIn => [
        FadeEffect(duration: medium, curve: defaultCurve),
        ScaleEffect(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1.0, 1.0),
          duration: medium,
          curve: defaultCurve,
        ),
      ];
}
