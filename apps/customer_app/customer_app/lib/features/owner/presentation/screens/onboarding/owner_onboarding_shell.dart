import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../providers/onboarding_controller.dart';
import 'business_step_screen.dart';
import 'store_step_screen.dart';
import 'location_step_screen.dart';

class OwnerOnboardingShell extends ConsumerWidget {
  const OwnerOnboardingShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);

    int currentStepIndex = 0;
    switch (state.currentStep) {
      case OnboardingStep.business:
        currentStepIndex = 0;
      case OnboardingStep.store:
        currentStepIndex = 1;
      case OnboardingStep.location:
        currentStepIndex = 2;
    }

    final totalSteps = 3;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: currentStepIndex > 0
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => ref
                    .read(onboardingControllerProvider.notifier)
                    .previousStep(),
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Step ${currentStepIndex + 1} of $totalSteps',
                    style: AppTypography.label.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  LinearProgressIndicator(
                    value: (currentStepIndex + 1) / totalSteps,
                    backgroundColor: AppColors.surface,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildCurrentStep(state.currentStep),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.business:
        return const BusinessStepScreen();
      case OnboardingStep.store:
        return const StoreStepScreen();
      case OnboardingStep.location:
        return const LocationStepScreen();
    }
  }
}
