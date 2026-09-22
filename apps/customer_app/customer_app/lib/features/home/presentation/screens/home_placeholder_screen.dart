import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/buttons/app_button.dart';

class HomePlaceholderScreen extends ConsumerWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome, ${authState.user?.name ?? "User"}!',
                style: AppTypography.headline,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton.secondary(
                label: 'Log Out',
                onPressed: () {
                  ref.read(authStateProvider.notifier).logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
