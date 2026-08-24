import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../providers/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Step tracker for progress indicator
  int _completedSteps = 0;

  // Animation controllers
  late final AnimationController _bgController;
  late final AnimationController _entranceController;
  late final AnimationController _formController;
  late final AnimationController _pulseController;

  // Animations
  late final Animation<double> _bgFadeIn;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<double> _formSlideUp;
  late final Animation<double> _formFade;
  late final Animation<double> _nameFieldSlide;
  late final Animation<double> _emailFieldSlide;
  late final Animation<double> _phoneFieldSlide;
  late final Animation<double> _passwordFieldSlide;
  late final Animation<double> _buttonScale;
  late final Animation<double> _footerFade;
  late final Animation<double> _pulse;

  // Focus tracking
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    // Background fade
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bgFadeIn = CurvedAnimation(parent: _bgController, curve: Curves.easeOut);

    // Entrance animations
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
    ));
    _logoFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.25, 0.65, curve: Curves.easeOutCubic),
    ));
    _titleFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.25, 0.55, curve: Curves.easeOut),
    );

    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
    ));
    _subtitleFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
    );

    // Form animations (slightly longer for more fields)
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _formSlideUp = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _formController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    _formFade = CurvedAnimation(
      parent: _formController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    _nameFieldSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _formController,
        curve: const Interval(0.05, 0.45, curve: Curves.easeOutCubic),
      ),
    );
    _emailFieldSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _formController,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic),
      ),
    );
    _phoneFieldSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _formController,
        curve: const Interval(0.25, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    _passwordFieldSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _formController,
        curve: const Interval(0.35, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _buttonScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _formController,
        curve: const Interval(0.6, 0.9, curve: Curves.elasticOut),
      ),
    );
    _footerFade = CurvedAnimation(
      parent: _formController,
      curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
    );

    // Pulse animation for decorative orbs
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animation sequence
    _bgController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _entranceController.forward();
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _formController.forward();
    });

    // Listen to fields for progress
    _nameController.addListener(_updateProgress);
    _emailController.addListener(_updateProgress);
    _passwordController.addListener(_updateProgress);
    _nameFocus.addListener(() => setState(() {}));
    _emailFocus.addListener(() => setState(() {}));
    _phoneFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));
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
    _bgController.dispose();
    _entranceController.dispose();
    _formController.dispose();
    _pulseController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
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
          // Animated gradient background
          _buildAnimatedBackground(screenSize),

          // Floating orbs
          _buildFloatingOrbs(screenSize),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Back button
                    _buildBackButton(),

                    const SizedBox(height: 24),

                    // Logo
                    _buildAnimatedLogo(),

                    const SizedBox(height: 24),

                    // Title
                    _buildAnimatedTitle(),

                    const SizedBox(height: 32),

                    // Progress indicator
                    _buildProgressIndicator(),

                    const SizedBox(height: 28),

                    // Form Card
                    _buildFormCard(authState),

                    const SizedBox(height: 28),

                    // Footer
                    _buildFooter(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(Size screenSize) {
    return FadeTransition(
      opacity: _bgFadeIn,
      child: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEDF5F1), // Soft green-tinted white
              Color(0xFFF7F8F7), // Near white
              Color(0xFFF5F0EB), // Warm cream
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingOrbs(Size screenSize) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -50 + (_pulse.value * 15),
              left: -30 + (_pulse.value * 8),
              child: _buildOrb(
                size: 180,
                color: AppColors.primary.withValues(alpha: 0.06),
                blur: 70,
              ),
            ),
            Positioned(
              bottom: 140 - (_pulse.value * 12),
              right: -50 + (_pulse.value * 10),
              child: _buildOrb(
                size: 160,
                color: AppColors.secondary.withValues(alpha: 0.07),
                blur: 55,
              ),
            ),
            Positioned(
              top: screenSize.height * 0.5 + (_pulse.value * 6),
              left: 30 - (_pulse.value * 4),
              child: _buildOrb(
                size: 90,
                color: AppColors.primaryLight.withValues(alpha: 0.05),
                blur: 35,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrb({
    required double size,
    required Color color,
    required double blur,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color, blurRadius: blur, spreadRadius: blur / 2),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: FadeTransition(
        opacity: _logoFade,
        child: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return SlideTransition(
      position: _logoSlide,
      child: FadeTransition(
        opacity: _logoFade,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
              ],
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
            child: Icon(
              Icons.person_add_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle() {
    return Column(
      children: [
        SlideTransition(
          position: _titleSlide,
          child: FadeTransition(
            opacity: _titleFade,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primaryLight,
                ],
              ).createShader(bounds),
              child: const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.2,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SlideTransition(
          position: _subtitleSlide,
          child: FadeTransition(
            opacity: _subtitleFade,
            child: Text(
              'Join FreshSave & start saving today',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return FadeTransition(
      opacity: _formFade,
      child: Column(
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
          const SizedBox(height: 8),
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
                    : AppColors.textDisabled,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDot(int index) {
    final isActive = _completedSteps > index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      height: 4,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : AppColors.border.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildFormCard(AsyncValue<void> authState) {
    return AnimatedBuilder(
      animation: _formController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _formSlideUp.value),
          child: Opacity(
            opacity: _formFade.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                    spreadRadius: -8,
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.03),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                    spreadRadius: -12,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Name field
                  Transform.translate(
                    offset: Offset(0, _nameFieldSlide.value),
                    child: _buildGlowField(
                      focusNode: _nameFocus,
                      isFocused: _nameFocus.hasFocus,
                      child: AppTextField(
                        controller: _nameController,
                        labelText: 'Full Name',
                        prefixIcon: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.person_outline_rounded,
                            color: _nameFocus.hasFocus
                                ? AppColors.primary
                                : AppColors.textDisabled,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email field
                  Transform.translate(
                    offset: Offset(0, _emailFieldSlide.value),
                    child: _buildGlowField(
                      focusNode: _emailFocus,
                      isFocused: _emailFocus.hasFocus,
                      child: AppTextField(
                        controller: _emailController,
                        labelText: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.email_outlined,
                            color: _emailFocus.hasFocus
                                ? AppColors.primary
                                : AppColors.textDisabled,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone field
                  Transform.translate(
                    offset: Offset(0, _phoneFieldSlide.value),
                    child: _buildGlowField(
                      focusNode: _phoneFocus,
                      isFocused: _phoneFocus.hasFocus,
                      child: AppTextField(
                        controller: _phoneController,
                        labelText: 'Phone Number (Optional)',
                        keyboardType: TextInputType.phone,
                        prefixIcon: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.phone_outlined,
                            color: _phoneFocus.hasFocus
                                ? AppColors.primary
                                : AppColors.textDisabled,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  Transform.translate(
                    offset: Offset(0, _passwordFieldSlide.value),
                    child: _buildGlowField(
                      focusNode: _passwordFocus,
                      isFocused: _passwordFocus.hasFocus,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            controller: _passwordController,
                            labelText: 'Password',
                            obscureText: _obscurePassword,
                            prefixIcon: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                Icons.lock_outline_rounded,
                                color: _passwordFocus.hasFocus
                                    ? AppColors.primary
                                    : AppColors.textDisabled,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                transitionBuilder: (child, anim) =>
                                    RotationTransition(
                                  turns: Tween(begin: 0.8, end: 1.0)
                                      .animate(anim),
                                  child: FadeTransition(
                                      opacity: anim, child: child),
                                ),
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  key: ValueKey(_obscurePassword),
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          // Password strength indicator
                          if (_passwordController.text.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _buildPasswordStrength(),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Register Button
                  ScaleTransition(
                    scale: _buttonScale,
                    child: _AnimatedRegisterButton(
                      label: 'Create Account',
                      isLoading: authState.isLoading,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  height: 3,
                  margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: index < strength
                        ? strengthColor
                        : AppColors.border.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              strengthText,
              key: ValueKey(strengthText),
              style: AppTypography.caption.copyWith(
                color: strengthColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowField({
    required FocusNode focusNode,
    required bool isFocused,
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md + 2),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 16,
                  spreadRadius: -2,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Focus(
        focusNode: focusNode,
        child: child,
      ),
    );
  }

  Widget _buildFooter() {
    return FadeTransition(
      opacity: _footerFade,
      child: Column(
        children: [
          // Terms text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'By creating an account, you agree to our Terms of Service and Privacy Policy',
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(
                color: AppColors.textDisabled,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Divider with "OR"
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: AppTypography.label.copyWith(
                    color: AppColors.textDisabled,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Login link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already a member?  ',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              GestureDetector(
                onTap: () => context.pushReplacement('/login'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    'Log In',
                    style: AppTypography.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom animated button with shimmer and press effects
class _AnimatedRegisterButton extends StatefulWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _AnimatedRegisterButton({
    required this.label,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  State<_AnimatedRegisterButton> createState() =>
      _AnimatedRegisterButtonState();
}

class _AnimatedRegisterButtonState extends State<_AnimatedRegisterButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: const [
                    AppColors.primary,
                    AppColors.primaryLight,
                    AppColors.primary,
                  ],
                  stops: [
                    0.0,
                    _shimmerController.value,
                    1.0,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary
                        .withValues(alpha: _isPressed ? 0.15 : 0.35),
                    blurRadius: _isPressed ? 12 : 20,
                    offset: Offset(0, _isPressed ? 4 : 8),
                    spreadRadius: _isPressed ? -4 : -2,
                  ),
                ],
              ),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
