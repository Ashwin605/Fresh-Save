import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/store_owner_models.dart';
import 'owner_state_provider.dart';

class ManageStoreState {
  final bool isEditMode;
  final bool isSaving;
  final String? error;

  // Edited values
  final String? editBusinessName;
  final String? editLegalName;
  final String? editBusinessType;
  final String? editBusinessEmail;
  final String? editBusinessPhone;

  final String? editStoreName;
  final String? editStoreDescription;
  final String? editStorePhone;
  final String? editStoreEmail;
  final String? editStoreAddress;

  ManageStoreState({
    this.isEditMode = false,
    this.isSaving = false,
    this.error,
    this.editBusinessName,
    this.editLegalName,
    this.editBusinessType,
    this.editBusinessEmail,
    this.editBusinessPhone,
    this.editStoreName,
    this.editStoreDescription,
    this.editStorePhone,
    this.editStoreEmail,
    this.editStoreAddress,
  });

  ManageStoreState copyWith({
    bool? isEditMode,
    bool? isSaving,
    String? error,
    bool clearError = false,
    String? editBusinessName,
    String? editLegalName,
    String? editBusinessType,
    String? editBusinessEmail,
    String? editBusinessPhone,
    String? editStoreName,
    String? editStoreDescription,
    String? editStorePhone,
    String? editStoreEmail,
    String? editStoreAddress,
  }) {
    return ManageStoreState(
      isEditMode: isEditMode ?? this.isEditMode,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
      editBusinessName: editBusinessName ?? this.editBusinessName,
      editLegalName: editLegalName ?? this.editLegalName,
      editBusinessType: editBusinessType ?? this.editBusinessType,
      editBusinessEmail: editBusinessEmail ?? this.editBusinessEmail,
      editBusinessPhone: editBusinessPhone ?? this.editBusinessPhone,
      editStoreName: editStoreName ?? this.editStoreName,
      editStoreDescription: editStoreDescription ?? this.editStoreDescription,
      editStorePhone: editStorePhone ?? this.editStorePhone,
      editStoreEmail: editStoreEmail ?? this.editStoreEmail,
      editStoreAddress: editStoreAddress ?? this.editStoreAddress,
    );
  }

  bool get hasUnsavedChanges {
    // Determine if the user has changed fields that need saving.
    return isEditMode;
  }
}

class ManageStoreController extends Notifier<ManageStoreState> {
  @override
  ManageStoreState build() {
    return ManageStoreState();
  }

  void enterEditMode() {
    final ownerState = ref.read(ownerStateProvider);
    final business = ownerState.business;
    final store = ownerState.activeStore;

    state = state.copyWith(
      isEditMode: true,
      clearError: true,
      editBusinessName: business?.name,
      editLegalName: business?.legalName,
      editBusinessType: business?.businessType,
      editBusinessEmail: business?.contactEmail,
      editBusinessPhone: business?.contactPhone,
      editStoreName: store?.name,
      editStoreDescription: store?.description,
      editStorePhone: store?.phone,
      editStoreEmail: store?.email,
      editStoreAddress: store?.address,
    );
  }

  void cancelEdit() {
    state = state.copyWith(isEditMode: false, clearError: true);
  }

  void updateField({
    String? editBusinessName,
    String? editLegalName,
    String? editBusinessType,
    String? editBusinessEmail,
    String? editBusinessPhone,
    String? editStoreName,
    String? editStoreDescription,
    String? editStorePhone,
    String? editStoreEmail,
    String? editStoreAddress,
  }) {
    state = state.copyWith(
      editBusinessName: editBusinessName,
      editLegalName: editLegalName,
      editBusinessType: editBusinessType,
      editBusinessEmail: editBusinessEmail,
      editBusinessPhone: editBusinessPhone,
      editStoreName: editStoreName,
      editStoreDescription: editStoreDescription,
      editStorePhone: editStorePhone,
      editStoreEmail: editStoreEmail,
      editStoreAddress: editStoreAddress,
    );
  }

  Future<bool> saveChanges() async {
    if (state.isSaving) return false; // Prevent double-tap

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final ownerStateNotifier = ref.read(ownerStateProvider.notifier);

      final businessUpdate = UpdateBusinessRequest(
        businessName: state.editBusinessName,
        legalName: state.editLegalName,
        businessType: state.editBusinessType,
        contactEmail: state.editBusinessEmail,
        contactPhone: state.editBusinessPhone,
      );

      final storeUpdate = UpdateStoreRequest(
        name: state.editStoreName,
        description: state.editStoreDescription,
        phone: state.editStorePhone,
        email: state.editStoreEmail,
        address: state.editStoreAddress,
      );

      // Perform updates concurrently
      await Future.wait([
        ownerStateNotifier.updateBusiness(businessUpdate),
        ownerStateNotifier.updateStore(storeUpdate),
      ]);

      state = state.copyWith(isSaving: false, isEditMode: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }
}

final manageStoreControllerProvider =
    NotifierProvider<ManageStoreController, ManageStoreState>(() {
      return ManageStoreController();
    });
