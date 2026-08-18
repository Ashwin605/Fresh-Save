import 'package:flutter/material.dart';
import 'app_badge.dart';

class DiscountBadge extends StatelessWidget {
  final double discountPercent;

  const DiscountBadge({super.key, required this.discountPercent});

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      label: '${discountPercent.round()}% OFF',
      variant: AppBadgeVariant.discount,
      icon: Icons.local_offer_outlined,
    );
  }
}
