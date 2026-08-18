import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../providers/onboarding_controller.dart';

class BusinessStepScreen extends ConsumerStatefulWidget {
  const BusinessStepScreen({super.key});

  @override
  ConsumerState<BusinessStepScreen> createState() => _BusinessStepScreenState();
}

class _BusinessStepScreenState extends ConsumerState<BusinessStepScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _legalNameController;
  late final TextEditingController _typeController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingControllerProvider);
    _nameController = TextEditingController(text: state.businessName);
    _legalNameController = TextEditingController(text: state.legalName);
    _typeController = TextEditingController(text: state.businessType);
    _emailController = TextEditingController(text: state.businessEmail);
    _phoneController = TextEditingController(text: state.businessPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _legalNameController.dispose();
    _typeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
        .updateBusinessInfo(
          name: _nameController.text.trim(),
          legalName: _legalNameController.text.trim(),
          type: _typeController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
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
          Text('Business Identity', style: AppTypography.headline),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tell us about your company. This information is used for verification and billing.',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),

          AppTextField(
            controller: _nameController,
            labelText: 'Business Name *',
            errorText: _nameError,
          ),
          const SizedBox(height: AppSpacing.md),

          AppTextField(
            controller: _legalNameController,
            labelText: 'Legal Name (Optional)',
          ),
          const SizedBox(height: AppSpacing.md),

          AppTextField(
            controller: _typeController,
            labelText: 'Business Type (e.g., Grocery, Cafe)',
          ),
          const SizedBox(height: AppSpacing.xl),

          Text('Contact Information', style: AppTypography.title),
          const SizedBox(height: AppSpacing.md),

          AppTextField(
            controller: _emailController,
            labelText: 'Business Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.md),

          AppTextField(
            controller: _phoneController,
            labelText: 'Business Phone',
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: AppSpacing.xxl),
          AppButton.primary(label: 'Continue', onPressed: _next),
        ],
      ),
    );
  }
}
