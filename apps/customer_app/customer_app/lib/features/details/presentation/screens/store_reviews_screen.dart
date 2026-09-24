import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/network/result.dart';
import '../../data/repositories/shop_ratings_repository.dart';
import '../../domain/models/rating_models.dart';
import 'package:intl/intl.dart';

class StoreReviewsScreen extends ConsumerStatefulWidget {
  final String storeId;

  const StoreReviewsScreen({super.key, required this.storeId});

  @override
  ConsumerState<StoreReviewsScreen> createState() => _StoreReviewsScreenState();
}

class _StoreReviewsScreenState extends ConsumerState<StoreReviewsScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ShopRating> _reviews = [];
  ShopRatingSummary? _summary;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;
  int _page = 1;
  static const int _limit = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchSummary();
    _fetchPage(1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && !_isLoadingMore && _hasMore) {
        setState(() => _isLoadingMore = true);
        _fetchPage(_page + 1);
      }
    }
  }

  Future<void> _fetchSummary() async {
    final repo = ref.read(shopRatingsRepositoryProvider);
    final result = await repo.getRatingSummary(widget.storeId);
    if (mounted && result is Success<ShopRatingSummary>) {
      setState(() => _summary = result.data);
    }
  }

  Future<void> _fetchPage(int page) async {
    final repo = ref.read(shopRatingsRepositoryProvider);
    final result = await repo.getRatings(widget.storeId, page: page, limit: _limit);

    if (!mounted) return;

    if (result is Success<List<ShopRating>>) {
      final newReviews = result.data;
      setState(() {
        if (page == 1) {
          _reviews = newReviews;
        } else {
          _reviews.addAll(newReviews);
        }
        _hasMore = newReviews.length == _limit;
        _page = page;
        _isLoading = false;
        _isLoadingMore = false;
        _errorMessage = null;
      });
    } else if (result is Failure<List<ShopRating>>) {
      setState(() {
        _errorMessage = result.error.message;
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
      _hasMore = true;
      _errorMessage = null;
    });
    await _fetchSummary();
    await _fetchPage(1);
  }

  Widget _buildDistributionBar(String star, int count, int total) {
    final percent = total > 0 ? (count / total) : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text('$star ⭐', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 30,
            child: Text('$count', style: AppTypography.caption, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Customer Reviews'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading && _reviews.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _errorMessage != null && _reviews.isEmpty
              ? AppErrorView(message: _errorMessage!, onRetry: _refresh)
              : RefreshIndicator(
                  onRefresh: _refresh,
                  color: AppColors.primary,
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: _reviews.length + (_summary != null ? 1 : 0) + (_isLoadingMore ? 1 : 0),
                    separatorBuilder: (context, index) => const Divider(height: AppSpacing.xl),
                    itemBuilder: (context, index) {
                      if (_summary != null && index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${_summary!.averageRating}', style: AppTypography.headline.copyWith(fontSize: 48)),
                                const SizedBox(width: AppSpacing.sm),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: List.generate(5, (i) {
                                          return Icon(
                                            i < _summary!.averageRating.round() ? Icons.star : Icons.star_border,
                                            color: Colors.amber,
                                            size: 20,
                                          );
                                        }),
                                      ),
                                      const SizedBox(height: 4),
                                      Text('${_summary!.totalRatings} ratings', style: AppTypography.caption),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            _buildDistributionBar('5', _summary!.distribution['5'] ?? 0, _summary!.totalRatings),
                            _buildDistributionBar('4', _summary!.distribution['4'] ?? 0, _summary!.totalRatings),
                            _buildDistributionBar('3', _summary!.distribution['3'] ?? 0, _summary!.totalRatings),
                            _buildDistributionBar('2', _summary!.distribution['2'] ?? 0, _summary!.totalRatings),
                            _buildDistributionBar('1', _summary!.distribution['1'] ?? 0, _summary!.totalRatings),
                            const SizedBox(height: AppSpacing.md),
                          ],
                        );
                      }

                      final reviewIndex = _summary != null ? index - 1 : index;

                      if (reviewIndex >= _reviews.length) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                      }

                      final review = _reviews[reviewIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(review.customerName, style: AppTypography.body),
                              Text(DateFormat.yMMMd().format(review.createdAt), style: AppTypography.caption),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < review.rating ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 16,
                              );
                            }),
                          ),
                          if (review.review != null && review.review!.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Text(review.review!, style: AppTypography.body),
                          ],
                        ],
                      );
                    },
                  ),
                ),
    );
  }
}
