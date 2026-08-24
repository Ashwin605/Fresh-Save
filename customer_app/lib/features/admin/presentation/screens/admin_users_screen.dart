import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../../core/widgets/layout/admin_data_table.dart';
import '../providers/admin_users_provider.dart';
import '../../data/admin_repository.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  int _currentPage = 1;

  void _suspendUser(String id) async {
    try {
      await ref.read(adminRepositoryProvider).suspendUser(id, 'Admin action');
      if (!mounted) return;
      AppSnackbar.show(context, message: 'User suspended successfully');
      ref.invalidate(adminUsersProvider(_currentPage));
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, message: e.toString(), variant: SnackbarVariant.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(adminUsersProvider(_currentPage));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Management',
              style: AppTypography.display.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            GlassSurface(
              child: usersState.when(
                loading: () => const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SizedBox(
                  height: 400,
                  child: Center(child: Text('Error: $err', style: TextStyle(color: AppColors.error))),
                ),
                data: (data) {
                  final List users = data['data'] ?? [];
                  final total = data['total'] as int? ?? 0;
                  final totalPages = (total / 20).ceil();

                  return AdminDataTable(
                    currentPage: _currentPage,
                    totalPages: totalPages,
                    onPageChanged: (page) => setState(() => _currentPage = page),
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Role')),
                      DataColumn(label: Text('Joined')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: users.map<DataRow>((user) {
                      return DataRow(
                        cells: [
                          DataCell(Text(user['name'] ?? 'N/A')),
                          DataCell(Text(user['email'] ?? 'N/A')),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                user['role'] ?? 'CUSTOMER',
                                style: AppTypography.label.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataCell(Text(
                            user['createdAt'] != null 
                              ? DateFormat('MMM d, yyyy').format(DateTime.parse(user['createdAt'])) 
                              : 'N/A'
                          )),
                          DataCell(
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                              onSelected: (value) {
                                if (value == 'suspend') {
                                  _suspendUser(user['id']);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'suspend',
                                  child: Text('Suspend User', style: TextStyle(color: AppColors.error)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
