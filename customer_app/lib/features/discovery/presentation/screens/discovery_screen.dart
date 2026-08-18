import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../providers/discovery_provider.dart';
import '../providers/discovery_stores_provider.dart';
import '../widgets/discovery_header.dart';
import '../widgets/discovery_controls.dart';
import '../widgets/discovery_results.dart';
import '../widgets/discovery_stores_results.dart';

enum DiscoveryTab { stores, deals }

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  final ScrollController _scrollController = ScrollController();
  DiscoveryTab _currentTab = DiscoveryTab.stores;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(discoveryStoresProvider.notifier).fetchInitial();
      ref.read(discoveryProvider.notifier).fetchInitial();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_currentTab == DiscoveryTab.stores) {
        ref.read(discoveryStoresProvider.notifier).loadMore();
      } else {
        ref.read(discoveryProvider.notifier).loadMore();
      }
    }
  }

  Future<void> _onRefresh() async {
    if (_currentTab == DiscoveryTab.stores) {
      await ref.read(discoveryStoresProvider.notifier).refresh();
    } else {
      await ref.read(discoveryProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            const DiscoveryHeader(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: SegmentedButton<DiscoveryTab>(
                  segments: const [
                    ButtonSegment(
                      value: DiscoveryTab.stores,
                      icon: Icon(Icons.storefront),
                      label: Text('Nearby Stores'),
                    ),
                    ButtonSegment(
                      value: DiscoveryTab.deals,
                      icon: Icon(Icons.local_offer),
                      label: Text('Nearby Deals'),
                    ),
                  ],
                  selected: {_currentTab},
                  onSelectionChanged: (Set<DiscoveryTab> selection) {
                    setState(() {
                      _currentTab = selection.first;
                    });
                  },
                ),
              ),
            ),
            const DiscoveryControlsBar(),
            _currentTab == DiscoveryTab.stores
                ? const DiscoveryStoresResults()
                : const DiscoveryResults(),
          ],
        ),
      ),
    );
  }
}
