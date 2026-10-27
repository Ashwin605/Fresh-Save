import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../providers/home_providers.dart';
import '../../domain/models/home_models.dart';
import 'section_header.dart';

/// "Stores In Spotlight" pastel category cards driven entirely by REAL categories from the backend.
class StoresInSpotlightGrid extends ConsumerWidget {
  const StoresInSpotlightGrid({super.key});

  static const List<Color> _pastelColors = [
    Color(0xFFEDE9FE), // Lavender
    Color(0xFFFCE7F3), // Pastel pink
    Color(0xFFFFE4E6), // Light rose
    Color(0xFFE0F2FE), // Sky blue
    Color(0xFFDCFCE7), // Mint
    Color(0xFFD1FAE5), // Mint light
    Color(0xFFFEF9C3), // Soft cream
    Color(0xFFFFEDD5), // Peach
    Color(0xFFCFFAFE), // Cyan
    Color(0xFFF3E8FF), // Purple light
  ];

  static IconData _iconForCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('pooja')) return Icons.temple_hindu_outlined;
    if (lower.contains('spice') || lower.contains('masala')) return Icons.grain_outlined;
    if (lower.contains('noodle') || lower.contains('pasta')) return Icons.ramen_dining_outlined;
    if (lower.contains('care') || lower.contains('oral') || lower.contains('beauty')) return Icons.health_and_safety_outlined;
    if (lower.contains('clean') || lower.contains('utensil')) return Icons.cleaning_services_outlined;
    if (lower.contains('chocolate') || lower.contains('sweet')) return Icons.cookie_outlined;
    if (lower.contains('fruit') || lower.contains('nut')) return Icons.eco_outlined;
    if (lower.contains('flour') || lower.contains('atta') || lower.contains('grain')) return Icons.bakery_dining_outlined;
    if (lower.contains('rice')) return Icons.rice_bowl_outlined;
    if (lower.contains('tea') || lower.contains('coffee') || lower.contains('drink')) return Icons.local_cafe_outlined;
    return Icons.storefront_outlined;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();

        // Get up to 10 categories to distribute into 2 rows of 5 cards
        final items = categories.take(10).toList();
        if (items.isEmpty) return const SizedBox.shrink();

        final half = (items.length / 2).ceil();
        final row1 = items.sublist(0, half);
        final row2 = items.sublist(half);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Stores In Spotlight',
              subtitle: 'Click on the Images Below',
            ),
            const SizedBox(height: AppSpacing.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: row1.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final cat = entry.value;
                      final color = _pastelColors[idx % _pastelColors.length];
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _SpotlightRealCard(category: cat, bgColor: color),
                      );
                    }).toList(),
                  ),
                  if (row2.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: row2.asMap().entries.map((entry) {
                        final idx = entry.key + half;
                        final cat = entry.value;
                        final color = _pastelColors[idx % _pastelColors.length];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: _SpotlightRealCard(category: cat, bgColor: color),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _SpotlightRealCard extends StatelessWidget {
  final Category category;
  final Color bgColor;

  const _SpotlightRealCard({
    required this.category,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/category/${category.id}');
      },
      child: Container(
        width: 100,
        height: 125,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.04),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
              child: Text(
                category.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  height: 1.15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 65,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: category.image != null && category.image!.isNotEmpty
                      ? AppNetworkImage(
                          imageUrl: category.image!,
                          fit: BoxFit.contain,
                        )
                      : Center(
                          child: Icon(
                            StoresInSpotlightGrid._iconForCategory(category.name),
                            size: 32,
                            color: Colors.black38,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
