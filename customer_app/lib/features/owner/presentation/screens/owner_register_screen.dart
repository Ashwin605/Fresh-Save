import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class OwnerRegisterScreen extends ConsumerStatefulWidget {
  const OwnerRegisterScreen({super.key});

  @override
  ConsumerState<OwnerRegisterScreen> createState() => _OwnerRegisterScreenState();
}

class _OwnerRegisterScreenState extends ConsumerState<OwnerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _ownerName = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  String _businessName = '';
  String _storeName = '';
  String _storeAddress = '';
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isDetectingLocation = false;
  double? _latitude;
  double? _longitude;
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    setState(() => _isDetectingLocation = true);
    try {
      // Check permissions
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

      // Get location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert coordinates to address
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
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final authNotifier = ref.read(authStateProvider.notifier);
      final result = await authNotifier.registerBusiness(
        ownerName: _ownerName,
        email: _email,
        password: _password,
        phone: _phone,
        businessName: _businessName,
        storeName: _storeName,
        storeAddress: _addressController.text, // Use the controller
        latitude: _latitude,
        longitude: _longitude,
      );

      if (!mounted) return;
      if (result) {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success),
                SizedBox(width: 8),
                Text('Success'),
              ],
            ),
            content: const Text('Business registered successfully! You can now log in to your account.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  context.go('/owner/login'); // Navigate to login
                },
                child: const Text('Go to Login'),
              ),
            ],
          ),
        );
      } else {
        // Read the error from state
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    constraints: const BoxConstraints(maxWidth: 600),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.05),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Register Business Account',
                            style: AppTypography.display,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Join FreshSave to reduce food waste and reach more customers.',
                            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          
                          // Owner Details
                          Text('Owner Details', style: AppTypography.headline),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                            onSaved: (v) => _ownerName = v!,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => v!.isEmpty || !v.contains('@') ? 'Valid email required' : null,
                            onSaved: (v) => _email = v!,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Phone Number (Optional)',
                              prefixIcon: Icon(Icons.phone_outlined),
                            ),
                            keyboardType: TextInputType.phone,
                            onSaved: (v) => _phone = v ?? '',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (v) => v!.length < 8 ? 'Password must be at least 8 characters' : null,
                            onSaved: (v) => _password = v!.trim(),
                          ),
                          
                          const SizedBox(height: AppSpacing.xl),
                          
                          // Business & Store Details
                          Text('Business Details', style: AppTypography.headline),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Business Name',
                              prefixIcon: Icon(Icons.business),
                            ),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                            onSaved: (v) => _businessName = v!,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Store Name (e.g. Main St Branch)',
                              prefixIcon: Icon(Icons.storefront),
                            ),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                            onSaved: (v) => _storeName = v!,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
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
                            ),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                          
                          const SizedBox(height: AppSpacing.xxl),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text('Register Business', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

