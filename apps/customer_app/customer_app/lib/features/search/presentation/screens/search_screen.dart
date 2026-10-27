import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../providers/search_provider.dart';
import '../../domain/models/search_state.dart';
import '../widgets/search_header.dart';
import '../widgets/search_initial_view.dart';
import '../widgets/search_results_view.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;
  final double? maxPrice;

  const SearchScreen({
    super.key,
    this.initialQuery,
    this.maxPrice,
  });

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if ((widget.initialQuery != null && widget.initialQuery!.trim().isNotEmpty) ||
          widget.maxPrice != null) {
        ref.read(searchProvider.notifier).executeSearch(
          widget.initialQuery ?? '',
          maxPrice: widget.maxPrice,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(searchProvider.select((s) => s.status));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SearchHeader(),
            Expanded(
              child: status == SearchStatus.initial
                  ? const SearchInitialView()
                  : const SearchResultsView(),
            ),
          ],
        ),
      ),
    );
  }
}
