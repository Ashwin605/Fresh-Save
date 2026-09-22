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
import '../../../../core/network/result.dart';
import '../../data/repositories/auth_repository_impl.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    FocusScope.of(context).unfocus();
    final otp = _otpController.text.trim();
    final password = _passwordController.text.trim();

    if (otp.isEmpty || password.isEmpty) {
      AppSnackbar.show(
        context,
        message: 'Please enter the reset code and a new password.',
        variant: SnackbarVariant.error,
      );
      return;
    }

    if (password.length < 8) {
      AppSnackbar.show(
        context,
        message: 'Password must be at least 8 characters long.',
        variant: SnackbarVariant.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await ref.read(authRepositoryProvider).resetPassword(
      email: widget.email,
      otp: otp,
      newPassword: password,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.when(
      success: (_) {
        AppSnackbar.show(
          context,
          message: 'Your password has been successfully reset. Please log in.',
          variant: SnackbarVariant.success,
        );
        // Navigate back to login
        while (context.canPop()) {
          context.pop();
        }
        context.pushReplacement('/login');
      },
      failure: (error) {
        AppSnackbar.show(
          context,
          message: error.message ?? 'Invalid or expired reset code.',
          variant: SnackbarVariant.error,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Dynamic Background Texture
          Positioned(
            top: -50,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.15),
                    AppColors.background.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ).animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            ).scaleXY(end: 1.1, duration: const Duration(seconds: 4), curve: Curves.easeInOutSine),
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
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Icon
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.secondary, AppColors.secondary],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withValues(alpha: 0.3),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                                spreadRadius: -4,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.password_rounded, color: Colors.white, size: 40),
                          ),
                        ),
                      ).animate().fade(duration: AppAnimations.medium).slideY(begin: -0.2, end: 0),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Header Texts
                      Text(
                        'Reset Password',
                        textAlign: TextAlign.center,
                        style: AppTypography.display.copyWith(
                          fontSize: 32,
                        ),
                      ).animate().fade(duration: AppAnimations.medium, delay: 100.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Enter the 6-digit code sent to ${widget.email} and your new password.',
                        textAlign: TextAlign.center,
                        style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                      ).animate().fade(duration: AppAnimations.medium, delay: 200.ms).slideY(begin: 0.2, end: 0),
                      
                      const SizedBox(height: AppSpacing.xxl),
                      
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
                              controller: _otpController,
                              labelText: '6-Digit Reset Code',
                              keyboardType: TextInputType.number,
                              prefixIcon: const Icon(Icons.pin_outlined),
                            ).animate().fade(duration: AppAnimations.medium, delay: 300.ms).slideY(begin: 0.2, end: 0),
                            const SizedBox(height: AppSpacing.lg),
                            AppTextField(
                              controller: _passwordController,
                              labelText: 'New Password',
                              obscureText: _obscurePassword,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ).animate().fade(duration: AppAnimations.medium, delay: 400.ms).slideY(begin: 0.2, end: 0),
                            const SizedBox(height: AppSpacing.xl),
                            SizedBox(
                              width: double.infinity,
                              child: AppButton.primary(
                                label: 'Reset Password',
                                isLoading: _isLoading,
                                onPressed: _submit,
                              ),
                            ).animate().fade(duration: AppAnimations.medium, delay: 500.ms).scaleXY(begin: 0.9, end: 1.0),
                          ],
                        ),
                      ).animate().fade(duration: AppAnimations.medium, delay: 300.ms).slideY(begin: 0.1, end: 0),
                      
                      const Spacer(),
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
}
