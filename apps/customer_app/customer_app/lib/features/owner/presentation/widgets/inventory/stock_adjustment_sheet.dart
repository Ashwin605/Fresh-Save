import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/network/result.dart';
import '../../../domain/models/inventory_models.dart';
import '../../../data/repositories/inventory_repository_provider.dart';
import '../../providers/inventory_detail_provider.dart';
import '../../providers/inventory_list_provider.dart';

class StockAdjustmentSheet extends ConsumerStatefulWidget {
  final String inventoryId;
  final int currentStock;

  const StockAdjustmentSheet({
    super.key,
    required this.inventoryId,
    required this.currentStock,
  });

  @override
  ConsumerState<StockAdjustmentSheet> createState() =>
      _StockAdjustmentSheetState();
}

class _StockAdjustmentSheetState extends ConsumerState<StockAdjustmentSheet> {
  String _selectedAction = 'ADD'; // ADD, REMOVE, SET
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() async {
    final quantityText = _quantityController.text.trim();
    if (quantityText.isEmpty) return;

    final quantity = int.tryParse(quantityText);
    if (quantity == null || quantity < 0) return;

    setState(() => _isLoading = true);

    final request = AdjustStockRequest(
      action: _selectedAction,
      quantity: quantity,
      reason: _reasonController.text.trim().isNotEmpty
          ? _reasonController.text.trim()
          : null,
    );

    final repo = ref.read(inventoryRepositoryProvider);
    final result = await repo.adjustStock(widget.inventoryId, request);

    if (mounted) {
      setState(() => _isLoading = false);

      if (result is Success) {
        ref.invalidate(inventoryDetailProvider(widget.inventoryId));
        ref.invalidate(inventoryListProvider);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stock updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      } else if (result is Failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error.message ?? 'Update failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int newStock = widget.currentStock;
    final inputQuantity = int.tryParse(_quantityController.text.trim()) ?? 0;

    if (_selectedAction == 'ADD') {
      newStock = widget.currentStock + inputQuantity;
    } else if (_selectedAction == 'REMOVE') {
      newStock = widget.currentStock - inputQuantity;
      if (newStock < 0) newStock = 0;
    } else if (_selectedAction == 'SET') {
      newStock = inputQuantity;
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.lg),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Adjust Stock',
            style: AppTypography.headline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),

          Text(
            'Current Quantity: ${widget.currentStock}',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),

          // Action Segmented Control
          Row(
            children: [
              _buildActionSegment('Add', 'ADD'),
              const SizedBox(width: AppSpacing.sm),
              _buildActionSegment('Remove', 'REMOVE'),
              const SizedBox(width: AppSpacing.sm),
              _buildActionSegment('Set', 'SET'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          AppTextField(
            labelText: 'Quantity',
            keyboardType: TextInputType.number,
            controller: _quantityController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),

          AppTextField(
            labelText: 'Reason (Optional)',
            controller: _reasonController,
          ),
          const SizedBox(height: AppSpacing.md),

          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('New Quantity', style: AppTypography.title),
                Text(
                  '$newStock',
                  style: AppTypography.headline.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          AppButton.primary(
            label: 'Update Inventory',
            isLoading: _isLoading,
            onPressed:
                (inputQuantity > 0 || _selectedAction == 'SET') && !_isLoading
                ? _submit
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActionSegment(String label, String value) {
    final isSelected = _selectedAction == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedAction = value),
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.md),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.body.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
