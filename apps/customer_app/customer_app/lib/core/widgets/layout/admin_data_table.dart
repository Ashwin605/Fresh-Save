import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import 'app_card.dart';

class AdminDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final int currentPage;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;

  const AdminDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.currentPage = 1,
    this.totalPages = 1,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.elevated,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: AppTypography.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
              dataTextStyle: AppTypography.body.copyWith(
                color: AppColors.textPrimary,
              ),
              dividerThickness: 1,
              headingRowColor: WidgetStateProperty.all(
                AppColors.surfaceVariant.withValues(alpha: 0.3),
              ),
              columns: columns,
              rows: rows,
            ),
          ),
          if (totalPages > 1)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.surfaceVariant),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: (currentPage > 1 && onPageChanged != null)
                        ? () => onPageChanged!(currentPage - 1)
                        : null,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Page $currentPage of $totalPages',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: (currentPage < totalPages && onPageChanged != null)
                        ? () => onPageChanged!(currentPage + 1)
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
