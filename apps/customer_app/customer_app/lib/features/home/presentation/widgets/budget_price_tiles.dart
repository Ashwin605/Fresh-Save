import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';

/// "Packet in Pocket" circular budget price tiles matching reference.
class BudgetPriceTilesSection extends StatelessWidget {
  const BudgetPriceTilesSection({super.key});

  static const List<_BudgetItem> _items = [
    _BudgetItem(price: 29, borderColor: AppColors.budgetBlue, bgColor: Color(0xFFE3F2FD)),
    _BudgetItem(price: 49, borderColor: AppColors.budgetGreen, bgColor: Color(0xFFE8F5E9)),
    _BudgetItem(price: 69, borderColor: AppColors.budgetGold, bgColor: Color(0xFFFFF8E1)),
    _BudgetItem(price: 99, borderColor: AppColors.budgetPink, bgColor: Color(0xFFFFEBEE)),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = _items[index];
          return _BudgetTile(item: item);
        },
      ),
    );
  }
}

class _BudgetItem {
  final int price;
  final Color borderColor;
  final Color bgColor;

  const _BudgetItem({
    required this.price,
    required this.borderColor,
    required this.bgColor,
  });
}

class _BudgetTile extends StatelessWidget {
  final _BudgetItem item;

  const _BudgetTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push('/search?maxPrice=${item.price}');
        },
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.bgColor,
            border: Border.all(color: item.borderColor, width: 2.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '₹${item.price}',
                style: AppTypography.headline.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.priceGreen,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'STORE',
                style: AppTypography.label.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.priceGreen,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
