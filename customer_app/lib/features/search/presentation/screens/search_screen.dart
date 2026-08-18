import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../providers/search_provider.dart';
import '../../domain/models/search_state.dart';
import '../widgets/search_header.dart';
import '../widgets/search_initial_view.dart';
import '../widgets/search_results_view.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
