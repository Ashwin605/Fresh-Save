// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../domain/models/owner_offer_models.dart';
import '../../domain/models/inventory_models.dart';
import '../providers/create_offer_controller.dart';
import '../widgets/offers/product_selection_sheet.dart';
import 'package:intl/intl.dart';

class CreateOfferScreen extends ConsumerStatefulWidget {
  const CreateOfferScreen({super.key});

  @override
  ConsumerState<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends ConsumerState<CreateOfferScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _discountController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _showInventorySelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.8,
        child: ProductSelectionSheet(
          onSelected: (OwnerInventoryItem item) {
            ref
                .read(createOfferControllerProvider.notifier)
                .selectInventory(item);
          },
        ),
      ),
    );
  }

  Future<void> _selectDateTime(bool isStart) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        final state = ref.read(createOfferControllerProvider);
        if (isStart) {
          ref
              .read(createOfferControllerProvider.notifier)
              .updateDates(
                dateTime,
                state.endsAt ?? dateTime.add(const Duration(hours: 4)),
              );
        } else {
          ref
              .read(createOfferControllerProvider.notifier)
              .updateDates(state.startsAt ?? now, dateTime);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(createOfferControllerProvider, (prev, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offer created successfully!')),
        );
        context.pop();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    final state = ref.watch(createOfferControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Create Offer', style: AppTypography.title),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step 1: Select Inventory Batch',
                style: AppTypography.title,
              ),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: _showInventorySelection,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.surfaceVariant),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          state.selectedInventory?.product.name ??
                              'Tap to select an active inventory batch',
                          style: AppTypography.body.copyWith(
                            color: state.selectedInventory == null
                                ? AppColors.textDisabled
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              if (state.selectedInventory != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Available Stock: ${state.selectedInventory!.stockQuantity}',
                  style: AppTypography.bodySmall,
                ),
                Text(
                  'Original Price: ₹${state.selectedInventory!.sellingPrice.toStringAsFixed(2)}',
                  style: AppTypography.bodySmall,
                ),
              ],

              const SizedBox(height: AppSpacing.xl),
              Text('Step 2: Pricing', style: AppTypography.title),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<DiscountType>(
                      title: const Text('Percentage'),
                      value: DiscountType.percentage,
                      groupValue: state.discountType,
                      onChanged: (val) => ref
                          .read(createOfferControllerProvider.notifier)
                          .updatePricing(val!, state.discountValue),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<DiscountType>(
                      title: const Text('Fixed Amount'),
                      value: DiscountType.fixedAmount,
                      groupValue: state.discountType,
                      onChanged: (val) => ref
                          .read(createOfferControllerProvider.notifier)
                          .updatePricing(val!, state.discountValue),
                    ),
                  ),
                ],
              ),
              AppTextField(
                controller: _discountController,
                labelText: 'Discount Value',
                hintText: state.discountType == DiscountType.percentage
                    ? 'e.g., 20 for 20%'
                    : 'e.g., 50 for ₹50 off',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  final parsed = double.tryParse(val) ?? 0;
                  ref
                      .read(createOfferControllerProvider.notifier)
                      .updatePricing(state.discountType, parsed);
                },
              ),

              const SizedBox(height: AppSpacing.xl),
              Text('Step 3: Availability Window', style: AppTypography.title),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _buildDateTimePicker(
                      'Starts At',
                      state.startsAt,
                      () => _selectDateTime(true),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildDateTimePicker(
                      'Ends At',
                      state.endsAt,
                      () => _selectDateTime(false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),
              Text('Step 4: Details (Optional)', style: AppTypography.title),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _titleController,
                labelText: 'Offer Title',
                hintText: 'e.g. End of day clearance!',
                onChanged: (val) => ref
                    .read(createOfferControllerProvider.notifier)
                    .updateDetails(val, state.description),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _descController,
                labelText: 'Description',
                hintText: 'Additional details for customers...',
                maxLines: 3,
                onChanged: (val) => ref
                    .read(createOfferControllerProvider.notifier)
                    .updateDetails(state.title, val),
              ),

              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                label: 'Publish Offer',
                isLoading: state.isLoading,
                onPressed: () {
                  ref.read(createOfferControllerProvider.notifier).submit();
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(
    String label,
    DateTime? value,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.label),
            const SizedBox(height: 4),
            Text(
              value != null
                  ? DateFormat('MMM d, h:mm a').format(value)
                  : 'Select Time',
              style: AppTypography.body.copyWith(
                color: value != null
                    ? AppColors.textPrimary
                    : AppColors.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
