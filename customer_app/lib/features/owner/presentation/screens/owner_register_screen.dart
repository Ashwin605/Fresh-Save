import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../auth/presentation/providers/auth_controller.dart';

class OwnerRegisterScreen extends ConsumerStatefulWidget {
  const OwnerRegisterScreen({super.key});

  @override
  ConsumerState<OwnerRegisterScreen> createState() => _OwnerRegisterScreenState();
}

class _OwnerRegisterScreenState extends ConsumerState<OwnerRegisterScreen> {
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _addressController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isDetectingLocation = false;
  double? _latitude;
  double? _longitude;

  int _completedSteps = 0;

  @override
  void initState() {
    super.initState();
    _ownerNameController.addListener(_updateProgress);
    _emailController.addListener(_updateProgress);
    _passwordController.addListener(_updateProgress);
    _businessNameController.addListener(_updateProgress);
    _storeNameController.addListener(_updateProgress);
  }

  void _updateProgress() {
    int steps = 0;
    if (_ownerNameController.text.trim().isNotEmpty) steps++;
    if (_emailController.text.trim().isNotEmpty) steps++;
    if (_passwordController.text.length >= 8) steps++;
    if (_businessNameController.text.trim().isNotEmpty) steps++;
    if (_storeNameController.text.trim().isNotEmpty) steps++;
    
    // Normalize to 0-3 for the progress bar display
    int normalizedSteps = (steps / 5 * 3).floor();
    if (normalizedSteps != _completedSteps) {
      setState(() => _completedSteps = normalizedSteps);
    }
  }

  @override
  void dispose() {
    _ownerNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _businessNameController.dispose();
    _storeNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    setState(() => _isDetectingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final geocoding = Geocoding();
      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final addressParts = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.postalCode,
        ].where((part) => part != null && part.isNotEmpty).join(', ');
        
        setState(() {
          _addressController.text = addressParts;
          _latitude = position.latitude;
          _longitude = position.longitude;
        });
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(
        context,
        message: 'Could not detect location: $e',
        variant: SnackbarVariant.error,
      );
    } finally {
      if (mounted) setState(() => _isDetectingLocation = false);
    }
  }

  void _submit() async {
    FocusScope.of(context).unfocus();
    
    final ownerName = _ownerNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final businessName = _businessNameController.text.trim();
    final storeName = _storeNameController.text.trim();
    final address = _addressController.text.trim();

    if (ownerName.isEmpty || email.isEmpty || password.isEmpty || businessName.isEmpty || storeName.isEmpty || address.isEmpty) {
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

    setState(() => _isLoading = true);

    try {
      final authNotifier = ref.read(authStateProvider.notifier);
      final result = await authNotifier.registerBusiness(
        ownerName: ownerName,
        email: email,
        password: password,
        phone: phone.isNotEmpty ? phone : null,
        businessName: businessName,
        storeName: storeName,
        storeAddress: address,
        latitude: _latitude,
        longitude: _longitude,
      );

      if (!mounted) return;
      if (result) {
        ref.read(authControllerProvider.notifier).login(email, password);
      } else {
        final errorMessage = ref.read(authStateProvider).error ?? 'Registration failed';
        AppSnackbar.show(context, message: errorMessage, variant: SnackbarVariant.error);
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, message: e.toString(), variant: SnackbarVariant.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    AppColors.primary.withValues(alpha: 0.10),
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
                    AppColors.secondary.withValues(alpha: 0.15),
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
                              colors: [AppColors.textPrimary, AppColors.textSecondary],
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.textPrimary.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                                spreadRadius: -4,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.storefront_rounded, color: Colors.white, size: 34),
                          ),
                        ),
                      ).animate().fade(duration: AppAnimations.medium).slideY(begin: -0.2, end: 0),
                      
                      const SizedBox(height: AppSpacing.lg),
                      
                      // Header Texts
                      Text(
                        'Register Business',
                        textAlign: TextAlign.center,
                        style: AppTypography.display.copyWith(fontSize: 30),
                      ).animate().fade(duration: AppAnimations.medium, delay: 100.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Join FreshSave to reach more customers',
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Owner Details', style: AppTypography.headline),
                            const SizedBox(height: AppSpacing.lg),
                            
                            AppTextField(
                              controller: _ownerNameController,
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
                            ).animate().fade(duration: AppAnimations.medium, delay: 500.ms).slideY(begin: 0.2, end: 0),
                            const SizedBox(height: AppSpacing.xxl),
                            
                            Text('Business Details', style: AppTypography.headline).animate().fade(duration: AppAnimations.medium, delay: 550.ms).slideY(begin: 0.2, end: 0),
                            const SizedBox(height: AppSpacing.lg),
                            
                            AppTextField(
                              controller: _businessNameController,
                              labelText: 'Business Name',
                              prefixIcon: const Icon(Icons.business),
                            ).animate().fade(duration: AppAnimations.medium, delay: 600.ms).slideY(begin: 0.2, end: 0),
                            const SizedBox(height: AppSpacing.md),
                            
                            AppTextField(
                              controller: _storeNameController,
                              labelText: 'Store Name (e.g. Main St Branch)',
                              prefixIcon: const Icon(Icons.storefront),
                            ).animate().fade(duration: AppAnimations.medium, delay: 650.ms).slideY(begin: 0.2, end: 0),
                            const SizedBox(height: AppSpacing.md),
                            
                            AppTextField(
                              controller: _addressController,
                              labelText: 'Store Address',
                              prefixIcon: const Icon(Icons.location_on_outlined),
                              suffixIcon: IconButton(
                                icon: _isDetectingLocation 
                                    ? const SizedBox(
                                        width: 16, 
                                        height: 16, 
                                        child: CircularProgressIndicator(strokeWidth: 2)
                                      )
                                    : const Icon(Icons.my_location, color: AppColors.primary),
                                onPressed: _isDetectingLocation ? null : _detectLocation,
                                tooltip: 'Detect Live Location',
                              ),
                            ).animate().fade(duration: AppAnimations.medium, delay: 700.ms).slideY(begin: 0.2, end: 0),
                            const SizedBox(height: AppSpacing.xxl),
                            
                            SizedBox(
                              width: double.infinity,
                              child: AppButton.primary(
                                label: 'Register Business',
                                isLoading: _isLoading,
                                onPressed: _submit,
                              ),
                            ).animate().fade(duration: AppAnimations.medium, delay: 750.ms).scaleXY(begin: 0.9, end: 1.0),
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
                            'Already registered? ',
                            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                          ),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Text(
                              'Log In',
                              style: AppTypography.body.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fade(duration: AppAnimations.medium, delay: 800.ms),
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
}
