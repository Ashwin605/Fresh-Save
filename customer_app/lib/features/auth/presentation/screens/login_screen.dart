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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
  late final Animation<double> _emailFieldSlide;
  late final Animation<double> _passwordFieldSlide;
  late final Animation<double> _buttonScale;
  late final Animation<double> _footerFade;
  late final Animation<double> _pulse;

  // Focus tracking for field glow
  final _emailFocus = FocusNode();
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

    // Entrance animations (logo + text)
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

    // Form animations
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _formSlideUp = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _formController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    _formFade = CurvedAnimation(
      parent: _formController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    _emailFieldSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _formController,
        curve: const Interval(0.1, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    _passwordFieldSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _formController,
        curve: const Interval(0.25, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _buttonScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _formController,
        curve: const Interval(0.5, 0.85, curve: Curves.elasticOut),
      ),
    );
    _footerFade = CurvedAnimation(
      parent: _formController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
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

    _emailFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _bgController.dispose();
    _entranceController.dispose();
    _formController.dispose();
    _pulseController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      AppSnackbar.show(
        context,
        message: 'Please enter your email and password.',
        variant: SnackbarVariant.error,
      );
      return;
    }

    ref.read(authControllerProvider.notifier).login(email, password);
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
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Back button
                      _buildBackButton(),

                      const SizedBox(height: 32),

                      // Logo
                      _buildAnimatedLogo(),

                      const SizedBox(height: 32),

                      // Title
                      _buildAnimatedTitle(),

                      const SizedBox(height: 40),

                      // Form Card
                      _buildFormCard(authState),

                      const SizedBox(height: 32),

                      // Footer
                      _buildFooter(),

                      const SizedBox(height: 32),
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

  Widget _buildAnimatedBackground(Size screenSize) {
    return FadeTransition(
      opacity: _bgFadeIn,
      child: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF0F7F4), // Very light green tint
              Color(0xFFF7F8F7), // Near white
              Color(0xFFF5F0EB), // Warm cream at bottom
            ],
            stops: [0.0, 0.5, 1.0],
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
            // Top-right orb
            Positioned(
              top: -60 + (_pulse.value * 20),
              right: -40 + (_pulse.value * 10),
              child: _buildOrb(
                size: 200,
                color: AppColors.primary.withValues(alpha: 0.06),
                blur: 80,
              ),
            ),
            // Bottom-left orb
            Positioned(
              bottom: 100 - (_pulse.value * 15),
              left: -60 + (_pulse.value * 12),
              child: _buildOrb(
                size: 180,
                color: AppColors.secondary.withValues(alpha: 0.08),
                blur: 60,
              ),
            ),
            // Center accent orb
            Positioned(
              top: screenSize.height * 0.35 + (_pulse.value * 8),
              right: 20 - (_pulse.value * 5),
              child: _buildOrb(
                size: 100,
                color: AppColors.primaryLight.withValues(alpha: 0.05),
                blur: 40,
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
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
                spreadRadius: -4,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.eco_rounded,
              color: Colors.white,
              size: 40,
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
                'Welcome back',
                style: TextStyle(
                  fontSize: 32,
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
              'Sign in to continue saving fresh',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
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
                  const SizedBox(height: 20),

                  // Password field
                  Transform.translate(
                    offset: Offset(0, _passwordFieldSlide.value),
                    child: _buildGlowField(
                      focusNode: _passwordFocus,
                      isFocused: _passwordFocus.hasFocus,
                      child: AppTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: _obscurePassword,
                        prefixIcon: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.lock_outline,
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
                              turns: Tween(begin: 0.8, end: 1.0).animate(anim),
                              child: FadeTransition(opacity: anim, child: child),
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
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: FadeTransition(
                      opacity: _footerFade,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Forgot password?',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Login Button
                  ScaleTransition(
                    scale: _buttonScale,
                    child: _AnimatedLoginButton(
                      label: 'Log In',
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

          // Create account link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New to FreshSave?  ',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              GestureDetector(
                onTap: () => context.pushReplacement('/register'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    'Create Account',
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
class _AnimatedLoginButton extends StatefulWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _AnimatedLoginButton({
    required this.label,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  State<_AnimatedLoginButton> createState() => _AnimatedLoginButtonState();
}

class _AnimatedLoginButtonState extends State<_AnimatedLoginButton>
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
                    color: AppColors.primary.withValues(alpha: _isPressed ? 0.15 : 0.35),
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
