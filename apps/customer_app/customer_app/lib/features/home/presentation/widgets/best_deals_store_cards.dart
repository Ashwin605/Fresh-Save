import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_spacing.dart';
import 'section_header.dart';

/// "Best Deals Ever!!!" cards matching reference visual structure (₹49, ₹99, ₹199 Store cards).
/// Directly routes to real backend deals filtered by price threshold.
class BestDealsStoreCards extends StatelessWidget {
  const BestDealsStoreCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Best Deals Ever!!!',
          subtitle: 'click below',
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 155,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            children: [
              _DealStoreCard(
                price: '₹49',
                sublabel: 'Deals under ₹49',
                icon: Icons.savings_outlined,
                onTap: () => context.push('/search?maxPrice=49'),
              ),
              const SizedBox(width: 12),
              _DealStoreCard(
                price: '₹99',
                sublabel: 'Deals under ₹99',
                icon: Icons.shopping_basket_outlined,
                onTap: () => context.push('/search?maxPrice=99'),
              ),
              const SizedBox(width: 12),
              _DealStoreCard(
                price: '₹199',
                sublabel: 'Deals under ₹199',
                icon: Icons.local_offer_outlined,
                onTap: () => context.push('/search?maxPrice=199'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DealStoreCard extends StatelessWidget {
  final String price;
  final String sublabel;
  final IconData icon;
  final VoidCallback onTap;

  const _DealStoreCard({
    required this.price,
    required this.sublabel,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 115,
        height: 155,
        decoration: BoxDecoration(
          color: const Color(0xFFC4DCC5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 14),
            // Price text styled like reference
            Text(
              price,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2C3E2D),
                letterSpacing: -0.5,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    color: Colors.white,
                    blurRadius: 1,
                  ),
                ],
              ),
            ),
            const Text(
              'STORE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2C3E2D),
                letterSpacing: 1.2,
              ),
            ),
            const Spacer(),
            // Clean graphical category icon container
            Container(
              height: 72,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 28,
                    color: const Color(0xFF2C3E2D),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sublabel,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C3E2D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
