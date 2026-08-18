import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../providers/team_provider.dart';
import '../providers/owner_state_provider.dart';

class OwnerTeamScreen extends ConsumerStatefulWidget {
  const OwnerTeamScreen({super.key});

  @override
  ConsumerState<OwnerTeamScreen> createState() => _OwnerTeamScreenState();
}

class _OwnerTeamScreenState extends ConsumerState<OwnerTeamScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamState = ref.watch(teamProvider);
    final activeStore = ref.watch(ownerStateProvider).activeStore;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Team Members'),
        backgroundColor: AppColors.surface.withValues(alpha: 0.8),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          if (activeStore != null)
            IconButton(
              icon: const Icon(Icons.person_add_alt_1_outlined),
              onPressed: () => _showAddStaffSheet(context, ref),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(teamProvider.notifier).refresh(),
        child: _buildBody(context, ref, teamState),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, TeamState state) {
    if (state.isLoading && state.staff.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.staff.isEmpty) {
      return Center(
        child: AppErrorView(
          message: state.error!,
          onRetry: () => ref.read(teamProvider.notifier).refresh(),
        ),
      );
    }

    if (state.staff.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_outlined,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('No team members yet', style: AppTypography.title),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Add staff to help manage this store',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => _showAddStaffSheet(context, ref),
              child: const Text('Add Staff'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: state.staff.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final member = state.staff[index];
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              (index * 0.1).clamp(0.0, 1.0),
              1.0,
              curve: Curves.easeOutCubic,
            ),
          ),
        );
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - animation.value)),
                child: child,
              ),
            );
          },
          child: _TeamMemberCard(
            member: member,
            onRemove: () => _confirmRemove(context, ref, member),
          ),
        );
      },
    );
  }

  void _showAddStaffSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddStaffSheet(
        onSubmit: (email) async {
          final success = await ref.read(teamProvider.notifier).addStaff(email);
          if (success && context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Staff member added successfully')),
            );
          } else if (context.mounted) {
            final error = ref.read(teamProvider).error ?? 'Failed to add staff';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: AppColors.error),
            );
          }
        },
      ),
    );
  }

  void _confirmRemove(BuildContext context, WidgetRef ref, dynamic member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        title: const Text('Remove Staff'),
        content: Text(
          'Are you sure you want to remove ${member.user.name} from this store?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(teamProvider.notifier)
                  .removeStaff(member.id);
              if (success && context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Staff removed')));
              } else if (context.mounted) {
                final error =
                    ref.read(teamProvider).error ?? 'Failed to remove staff';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: Text(
              'Remove',
              style: AppTypography.label.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamMemberCard extends StatelessWidget {
  final dynamic member;
  final VoidCallback onRemove;

  const _TeamMemberCard({required this.member, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final isManager = member.role.toString().toUpperCase() == 'MANAGER';
    final roleName = isManager ? 'Manager' : 'Staff';
    final permissions = isManager
        ? 'Full store access, edit settings, manage staff'
        : 'Manage inventory, reservations, and offers';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                member.user.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    member.user.name,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isManager
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    roleName,
                    style: AppTypography.bodySmall.copyWith(
                      color: isManager
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.user.email, style: AppTypography.bodySmall),
                  const SizedBox(height: 2),
                  Text(
                    permissions,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            trailing: PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: onRemove,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.remove_circle_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text('Remove', style: TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddStaffSheet extends StatefulWidget {
  final Function(String email) onSubmit;

  const _AddStaffSheet({required this.onSubmit});

  @override
  State<_AddStaffSheet> createState() => _AddStaffSheetState();
}

class _AddStaffSheetState extends State<_AddStaffSheet> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await widget.onSubmit(_emailController.text.trim());
    if (mounted) setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.lg,
        bottom: bottomInset + AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Add Staff', style: AppTypography.title),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Enter the email address of the user to add as staff. They will be assigned the Staff role by default.',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Add to Store'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
