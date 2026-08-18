import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/models/location_models.dart';
import '../providers/location_provider.dart';

class LocationSelectorScreen extends ConsumerStatefulWidget {
  const LocationSelectorScreen({super.key});

  @override
  ConsumerState<LocationSelectorScreen> createState() =>
      _LocationSelectorScreenState();
}

class _LocationSelectorScreenState
    extends ConsumerState<LocationSelectorScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  List<_LocationOption> _searchResults = [];

  // Popular city presets
  static const _popularLocations = <_LocationOption>[
    _LocationOption(
      name: 'Vellore',
      subtitle: 'Tamil Nadu, India',
      lat: 12.9165,
      lng: 79.1325,
    ),
    _LocationOption(
      name: 'Chennai',
      subtitle: 'Tamil Nadu, India',
      lat: 13.0827,
      lng: 80.2707,
    ),
    _LocationOption(
      name: 'Bangalore',
      subtitle: 'Karnataka, India',
      lat: 12.9716,
      lng: 77.5946,
    ),
    _LocationOption(
      name: 'Hyderabad',
      subtitle: 'Telangana, India',
      lat: 17.3850,
      lng: 78.4867,
    ),
    _LocationOption(
      name: 'Mumbai',
      subtitle: 'Maharashtra, India',
      lat: 19.0760,
      lng: 72.8777,
    ),
    _LocationOption(
      name: 'Delhi',
      subtitle: 'New Delhi, India',
      lat: 28.6139,
      lng: 77.2090,
    ),
    _LocationOption(
      name: 'Pune',
      subtitle: 'Maharashtra, India',
      lat: 18.5204,
      lng: 73.8567,
    ),
    _LocationOption(
      name: 'Kolkata',
      subtitle: 'West Bengal, India',
      lat: 22.5726,
      lng: 88.3639,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchResults = List.from(_popularLocations);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _searchResults = List.from(_popularLocations);
      } else {
        _searchResults = _popularLocations
            .where((loc) =>
                loc.name.toLowerCase().contains(query) ||
                loc.subtitle.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _selectLocation(_LocationOption option) {
    ref.read(locationProvider.notifier).setManualLocation(
          option.lat,
          option.lng,
          addressName: '${option.name}, ${option.subtitle.split(',').first}',
        );
    context.pop();
  }

  void _useCurrentLocation() async {
    ref.read(locationProvider.notifier).requestPermissionAndAcquire();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);
    final currentAddress = locationState.location?.addressName;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Choose Location', style: AppTypography.title),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a city...',
                hintStyle: AppTypography.body.copyWith(
                  color: AppColors.textDisabled,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: AppColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 4,
                ),
              ),
              style: AppTypography.body,
            ),
          ),

          // Use current location button
          Container(
            width: double.infinity,
            color: AppColors.surface,
            child: InkWell(
              onTap: _useCurrentLocation,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.my_location,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Use current location',
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          if (currentAddress != null)
                            Text(
                              currentAddress,
                              style: AppTypography.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    if (locationState.status == LocationStatus.detecting)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    else
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Section header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _isSearching ? 'Search Results' : 'Popular Cities',
                style: AppTypography.label.copyWith(
                  letterSpacing: 1.0,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),

          // City list
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: AppColors.textDisabled.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No cities found',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Try a different search term',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    itemCount: _searchResults.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: AppColors.border.withValues(alpha: 0.5),
                    ),
                    itemBuilder: (context, index) {
                      final option = _searchResults[index];
                      final isSelected = locationState.location != null &&
                          locationState.location!.source ==
                              LocationSource.manual &&
                          (locationState.location!.latitude - option.lat)
                                  .abs() <
                              0.01 &&
                          (locationState.location!.longitude - option.lng)
                                  .abs() <
                              0.01;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xs,
                          horizontal: AppSpacing.sm,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          option.name,
                          style: AppTypography.body.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          option.subtitle,
                          style: AppTypography.bodySmall,
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                                size: 22,
                              )
                            : null,
                        onTap: () => _selectLocation(option),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _LocationOption {
  final String name;
  final String subtitle;
  final double lat;
  final double lng;

  const _LocationOption({
    required this.name,
    required this.subtitle,
    required this.lat,
    required this.lng,
  });
}
