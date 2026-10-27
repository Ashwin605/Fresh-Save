import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../providers/admin_audit_logs_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AdminAuditLogsScreen extends ConsumerStatefulWidget {
  const AdminAuditLogsScreen({super.key});

  @override
  ConsumerState<AdminAuditLogsScreen> createState() => _AdminAuditLogsScreenState();
}

class _AdminAuditLogsScreenState extends ConsumerState<AdminAuditLogsScreen> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final auditLogsState = ref.watch(adminAuditLogsProvider(_currentPage));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Audit Logs',
              style: AppTypography.display.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Read-only record of all privileged administrative actions.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xxl),
            GlassSurface(
              child: auditLogsState.when(
                loading: () => const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SizedBox(
                  height: 400,
                  child: Center(child: Text('Error: $err', style: TextStyle(color: AppColors.error))),
                ),
                data: (data) {
                  final List logs = data['data'] ?? [];
                  final total = data['total'] as int? ?? 0;
                  final totalPages = (total / 50).ceil();

                  if (logs.isEmpty) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: Text('No audit logs found.')),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingTextStyle: AppTypography.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                          dataTextStyle: AppTypography.body.copyWith(color: AppColors.textPrimary),
                          columns: const [
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('Actor ID')),
                            DataColumn(label: Text('Action')),
                            DataColumn(label: Text('Entity Type')),
                            DataColumn(label: Text('Entity ID')),
                          ],
                          rows: logs.map<DataRow>((log) {
                            return DataRow(
                              cells: [
                                DataCell(Text(
                                  log['createdAt'] != null 
                                    ? DateFormat('MMM d, yyyy HH:mm:ss').format(DateTime.parse(log['createdAt'])) 
                                    : 'N/A'
                                )),
                                DataCell(Text(log['actorId'] ?? 'N/A')),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.textSecondary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      log['action'] ?? 'UNKNOWN',
                                      style: AppTypography.label.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataCell(Text(log['entityType'] ?? 'N/A')),
                                DataCell(Text(log['entityId'] ?? 'N/A')),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      if (totalPages > 1)
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                              ),
                              Text('Page $_currentPage of $totalPages', style: AppTypography.bodySmall),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
