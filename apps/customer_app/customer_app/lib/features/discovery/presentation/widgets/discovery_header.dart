import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../location/presentation/widgets/location_status_chip.dart';
import '../../../home/presentation/widgets/search_entry_bar.dart'; // Reusing from home

class DiscoveryHeader extends ConsumerWidget {
  const DiscoveryHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      backgroundColor: AppColors.background.withAlpha(240),
      elevation: 0,
      toolbarHeight: 120, // Taller to accommodate search
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.xxl,
          ), // padding for status bar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Discover nearby', style: AppTypography.title),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => context.push('/location-selector'),
                          child: const LocationStatusChip(),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => context.push('/notifications'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const SearchEntryBar(),
            ],
          ),
        ),
      ),
    );
  }
}
