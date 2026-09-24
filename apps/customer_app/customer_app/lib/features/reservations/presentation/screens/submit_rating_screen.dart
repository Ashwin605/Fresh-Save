import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/network/result.dart';
import '../../../details/data/repositories/shop_ratings_repository.dart';

class SubmitRatingScreen extends ConsumerStatefulWidget {
  final String orderId;
  final String shopId;

  const SubmitRatingScreen({
    super.key,
    required this.orderId,
    required this.shopId,
  });

  @override
  ConsumerState<SubmitRatingScreen> createState() => _SubmitRatingScreenState();
}

class _SubmitRatingScreenState extends ConsumerState<SubmitRatingScreen> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitRating() async {
    if (_selectedRating < 1 || _selectedRating > 5) return;

    setState(() => _isSubmitting = true);

    final repo = ref.read(shopRatingsRepositoryProvider);
    final result = await repo.createRating(
      widget.shopId,
      widget.orderId,
      _selectedRating,
      _reviewController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (result is Success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rating submitted successfully'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop(_selectedRating); // Return rating to indicate success
    } else if (result is Failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error.message ?? 'Unable to submit your rating. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Rate this shop', style: AppTypography.title),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('How was your experience?', style: AppTypography.headline, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1;
                return IconButton(
                  iconSize: 48,
                  icon: Icon(
                    starValue <= _selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() => _selectedRating = starValue);
                  },
                );
              }),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text('Tell us about your experience (Optional)', style: AppTypography.body),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              maxLength: 1000,
              decoration: InputDecoration(
                hintText: 'Write your review here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Submit Rating',
              variant: AppButtonVariant.primary,
              isLoading: _isSubmitting,
              onPressed: _selectedRating > 0 ? _submitRating : () {},
            ),
          ],
        ),
      ),
    );
  }
}
