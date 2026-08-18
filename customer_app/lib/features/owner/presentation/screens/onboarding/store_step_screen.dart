import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../providers/onboarding_controller.dart';

class StoreStepScreen extends ConsumerStatefulWidget {
  const StoreStepScreen({super.key});

  @override
  ConsumerState<StoreStepScreen> createState() => _StoreStepScreenState();
}

class _StoreStepScreenState extends ConsumerState<StoreStepScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingControllerProvider);
    _nameController = TextEditingController(
      text: state.storeName.isEmpty ? state.businessName : state.storeName,
    );
    _descriptionController = TextEditingController(
      text: state.storeDescription,
    );
    _phoneController = TextEditingController(text: state.storePhone);
    _emailController = TextEditingController(text: state.storeEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _next() {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = 'Required');
      return;
    }
    setState(() => _nameError = null);

    ref
        .read(onboardingControllerProvider.notifier)
        .updateStoreInfo(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
        );
    ref.read(onboardingControllerProvider.notifier).nextStep();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Store Profile', style: AppTypography.headline),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Set up your first storefront. Customers will see this information in the app.',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),

          AppTextField(
            controller: _nameController,
            labelText: 'Storefront Name *',
            errorText: _nameError,
          ),
          const SizedBox(height: AppSpacing.md),

          AppTextField(
            controller: _descriptionController,
            labelText: 'Store Description (Optional)',
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.xl),

          Text('Public Contact', style: AppTypography.title),
          const SizedBox(height: AppSpacing.md),

          AppTextField(
            controller: _phoneController,
            labelText: 'Public Phone Number',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppSpacing.md),

          AppTextField(
            controller: _emailController,
            labelText: 'Public Email',
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: AppSpacing.xxl),
          AppButton.primary(label: 'Continue', onPressed: _next),
        ],
      ),
    );
  }
}
