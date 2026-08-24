import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../providers/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  int _completedSteps = 0;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateProgress);
    _emailController.addListener(_updateProgress);
    _passwordController.addListener(_updateProgress);
  }

  void _updateProgress() {
    int steps = 0;
    if (_nameController.text.trim().isNotEmpty) steps++;
    if (_emailController.text.trim().isNotEmpty) steps++;
    if (_passwordController.text.length >= 8) steps++;
    if (steps != _completedSteps) {
      setState(() => _completedSteps = steps);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      AppSnackbar.show(
        context,
        message: 'Please fill in all required fields.',
        variant: SnackbarVariant.error,
      );
      return;
    }

    if (password.length < 8) {
      AppSnackbar.show(
        context,
        message: 'Password must be at least 8 characters.',
        variant: SnackbarVariant.error,
      );
      return;
    }

    ref.read(authControllerProvider.notifier).register(
          name: name,
          email: email,
          password: password,
          phone: phone.isNotEmpty ? phone : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final screenSize = MediaQuery.of(context).size;

    ref.listen<AsyncValue<void>>(authControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (error, _) {
          AppSnackbar.show(
            context,
            message: error.toString(),
            variant: SnackbarVariant.error,
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Dynamic Background Texture
          Positioned(
            top: -50,
            left: -80,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryLight.withValues(alpha: 0.15),
                    AppColors.background.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ).animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            ).scaleXY(end: 1.1, duration: const Duration(seconds: 4), curve: Curves.easeInOutSine),
          ),
          Positioned(
            bottom: 100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.10),
                    AppColors.background.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ).animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            ).scaleXY(begin: 1.05, end: 0.95, duration: const Duration(seconds: 5), curve: Curves.easeInOutSine),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                      ).animate().fade(duration: AppAnimations.medium),
                      const SizedBox(height: AppSpacing.md),
                      
                      // Logo
                      Center(
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.primary, AppColors.primaryLight],
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                                spreadRadius: -4,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.person_add_rounded, color: Colors.white, size: 34),
                          ),
                        ),
                      ).animate().fade(duration: AppAnimations.medium).slideY(begin: -0.2, end: 0),
                      
                      const SizedBox(height: AppSpacing.lg),
                      
                      // Header Texts
                      Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: AppTypography.display.copyWith(fontSize: 30),
                      ).animate().fade(duration: AppAnimations.medium, delay: 100.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Join FreshSave & start saving today',
                        textAlign: TextAlign.center,
                        style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                      ).animate().fade(duration: AppAnimations.medium, delay: 200.ms).slideY(begin: 0.2, end: 0),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Progress Indicator
                      _buildProgressIndicator().animate().fade(duration: AppAnimations.medium, delay: 300.ms),
                      
                      const SizedBox(height: AppSpacing.lg),
                      
                      // Form Card
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            AppTextField(
                              controller: _nameController,
                              labelText: 'Full Name',
                              prefixIcon: const Icon(Icons.person_outline_rounded),
                            ).animate().fade(duration: AppAnimations.medium, delay: 350.ms).slideY(begin: 0.2, end: 0),
                            const SizedBox(height: AppSpacing.md),
                            
                            AppTextField(
                              controller: _emailController,
                              labelText: 'Email Address',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.email_outlined),
                            ).animate().fade(duration: AppAnimations.medium, delay: 400.ms).slideY(begin: 0.2, end: 0),
                            const SizedBox(height: AppSpacing.md),
                            
                            AppTextField(
                              controller: _phoneController,
                              labelText: 'Phone Number (Optional)',
                              keyboardType: TextInputType.phone,
                              prefixIcon: const Icon(Icons.phone_outlined),
                            ).animate().fade(duration: AppAnimations.medium, delay: 450.ms).slideY(begin: 0.2, end: 0),
                            const SizedBox(height: AppSpacing.md),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextField(
                                  controller: _passwordController,
                                  labelText: 'Password',
                                  obscureText: _obscurePassword,
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                      color: AppColors.textSecondary,
                                    ),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                if (_passwordController.text.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 4.0, right: 4.0),
                                    child: _buildPasswordStrength(),
                                  ),
                              ],
                            ).animate().fade(duration: AppAnimations.medium, delay: 500.ms).slideY(begin: 0.2, end: 0),
                            const SizedBox(height: AppSpacing.xl),
                            
                            SizedBox(
                              width: double.infinity,
                              child: AppButton.primary(
                                label: 'Create Account',
                                isLoading: authState.isLoading,
                                onPressed: _submit,
                              ),
                            ).animate().fade(duration: AppAnimations.medium, delay: 600.ms).scaleXY(begin: 0.9, end: 1.0),
                          ],
                        ),
                      ).animate().fade(duration: AppAnimations.medium, delay: 300.ms).slideY(begin: 0.1, end: 0),
                      
                      const Spacer(),
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                          ),
                          GestureDetector(
                            onTap: () => context.pushReplacement('/login'),
                            child: Text(
                              'Log In',
                              style: AppTypography.body.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fade(duration: AppAnimations.medium, delay: 700.ms),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildProgressDot(0)),
            const SizedBox(width: 8),
            Expanded(child: _buildProgressDot(1)),
            const SizedBox(width: 8),
            Expanded(child: _buildProgressDot(2)),
          ],
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: Text(
            _completedSteps == 0
                ? 'Fill in your details to get started'
                : _completedSteps == 1
                    ? 'Almost there...'
                    : _completedSteps == 2
                        ? 'Just one more step!'
                        : 'Ready to go! 🎉',
            key: ValueKey(_completedSteps),
            style: AppTypography.label.copyWith(
              color: _completedSteps == 3
                  ? AppColors.success
                  : AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressDot(int index) {
    final isActive = _completedSteps > index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildPasswordStrength() {
    final password = _passwordController.text;
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    Color strengthColor;
    String strengthText;
    switch (strength) {
      case 0:
      case 1:
        strengthColor = AppColors.error;
        strengthText = 'Weak';
        break;
      case 2:
        strengthColor = AppColors.warning;
        strengthText = 'Fair';
        break;
      case 3:
        strengthColor = AppColors.info;
        strengthText = 'Good';
        break;
      default:
        strengthColor = AppColors.success;
        strengthText = 'Strong';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                height: 4,
                margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                decoration: BoxDecoration(
                  color: index < strength ? strengthColor : AppColors.border.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            strengthText,
            key: ValueKey(strengthText),
            style: AppTypography.label.copyWith(color: strengthColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
