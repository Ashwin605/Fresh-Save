import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/store_owner_models.dart';
import '../../data/repositories/owner_repository_impl.dart';
import '../providers/owner_state_provider.dart';
import '../../../../core/network/result.dart';

enum OnboardingStep { business, store, location }

class OnboardingState {
  final OnboardingStep currentStep;
  final bool isLoading;
  final String? error;

  // Business form state
  final String businessName;
  final String legalName;
  final String businessType;
  final String businessEmail;
  final String businessPhone;

  // Store form state
  final String storeName;
  final String storeDescription;
  final String storePhone;
  final String storeEmail;

  // Location form state
  final String storeAddress;
  final double? latitude;
  final double? longitude;

  OnboardingState({
    this.currentStep = OnboardingStep.business,
    this.isLoading = false,
    this.error,
    this.businessName = '',
    this.legalName = '',
    this.businessType = '',
    this.businessEmail = '',
    this.businessPhone = '',
    this.storeName = '',
    this.storeDescription = '',
    this.storePhone = '',
    this.storeEmail = '',
    this.storeAddress = '',
    this.latitude,
    this.longitude,
  });

  OnboardingState copyWith({
    OnboardingStep? currentStep,
    bool? isLoading,
    String? error,
    bool clearError = false,
    String? businessName,
    String? legalName,
    String? businessType,
    String? businessEmail,
    String? businessPhone,
    String? storeName,
    String? storeDescription,
    String? storePhone,
    String? storeEmail,
    String? storeAddress,
    double? latitude,
    double? longitude,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      businessName: businessName ?? this.businessName,
      legalName: legalName ?? this.legalName,
      businessType: businessType ?? this.businessType,
      businessEmail: businessEmail ?? this.businessEmail,
      businessPhone: businessPhone ?? this.businessPhone,
      storeName: storeName ?? this.storeName,
      storeDescription: storeDescription ?? this.storeDescription,
      storePhone: storePhone ?? this.storePhone,
      storeEmail: storeEmail ?? this.storeEmail,
      storeAddress: storeAddress ?? this.storeAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return OnboardingState();
  }

  void updateBusinessInfo({
    String? name,
    String? legalName,
    String? type,
    String? email,
    String? phone,
  }) {
    state = state.copyWith(
      businessName: name,
      legalName: legalName,
      businessType: type,
      businessEmail: email,
      businessPhone: phone,
    );
  }

  void updateStoreInfo({
    String? name,
    String? description,
    String? phone,
    String? email,
  }) {
    state = state.copyWith(
      storeName: name,
      storeDescription: description,
      storePhone: phone,
      storeEmail: email,
    );
  }

  void updateLocationInfo({
    String? address,
    double? latitude,
    double? longitude,
  }) {
    state = state.copyWith(
      storeAddress: address,
      latitude: latitude,
      longitude: longitude,
    );
  }

  void nextStep() {
    if (state.currentStep == OnboardingStep.business) {
      state = state.copyWith(currentStep: OnboardingStep.store);
    } else if (state.currentStep == OnboardingStep.store) {
      state = state.copyWith(currentStep: OnboardingStep.location);
    }
  }

  void previousStep() {
    if (state.currentStep == OnboardingStep.location) {
      state = state.copyWith(currentStep: OnboardingStep.store);
    } else if (state.currentStep == OnboardingStep.store) {
      state = state.copyWith(currentStep: OnboardingStep.business);
    }
  }

  Future<void> submit() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final repo = ref.read(ownerRepositoryProvider);

    // 1. Create Business
    final businessRequest = CreateBusinessRequest(
      businessName: state.businessName,
      legalName: state.legalName.isEmpty ? null : state.legalName,
      businessType: state.businessType.isEmpty ? null : state.businessType,
      contactEmail: state.businessEmail.isEmpty ? null : state.businessEmail,
      contactPhone: state.businessPhone.isEmpty ? null : state.businessPhone,
    );

    final businessResult = await repo.createBusiness(businessRequest);
    String businessId = '';

    switch (businessResult) {
      case Success(:final data):
        businessId = data.id;
      case Failure(:final error):
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to create business: ${error.message}',
        );
        return;
    }

    // 2. Create Store
    final storeRequest = CreateStoreRequest(
      name: state.storeName,
      description: state.storeDescription.isEmpty
          ? null
          : state.storeDescription,
      phone: state.storePhone.isEmpty ? null : state.storePhone,
      email: state.storeEmail.isEmpty ? null : state.storeEmail,
      address: state.storeAddress.isEmpty ? null : state.storeAddress,
      latitude: state.latitude,
      longitude: state.longitude,
    );

    final storeResult = await repo.createStore(businessId, storeRequest);

    switch (storeResult) {
      case Success():
        // 3. Reload Owner State to trigger router redirect to Dashboard
        await ref.read(ownerStateProvider.notifier).loadOwnerContext();
      case Failure(:final error):
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to create store: ${error.message}',
        );
    }
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(() {
      return OnboardingController();
    });
