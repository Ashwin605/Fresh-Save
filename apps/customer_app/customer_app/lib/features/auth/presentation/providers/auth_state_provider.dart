import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../../../core/network/result.dart';
import '../../domain/models/auth_models.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/storage/token_storage.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

/// Represents the current authentication state of the application.
/// Used to drive navigation (e.g., redirecting unauthenticated users to the Login screen)
/// and conditionally render UI elements based on the [user]'s role.
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({this.status = AuthStatus.unknown, this.user, this.error});

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Manages the [AuthState] across the entire app.
/// This Notifier handles restoring sessions on app startup,
/// logging in/out, and responding to token expiration events.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Listen to Firebase Auth state directly. This ensures synchronization.
    firebase.FirebaseAuth.instance.userChanges().listen((fbUser) {
      if (fbUser == null) {
        state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
      } else {
        _handleFirebaseUser(fbUser);
      }
    });
    
    // We start as unknown, let the listener above populate the state.
    return const AuthState();
  }

  Future<void> _handleFirebaseUser(firebase.User fbUser) async {
    final isGoogleUser = fbUser.providerData.any(
      (info) => info.providerId == 'google.com',
    );

    if (!fbUser.emailVerified && !isGoogleUser) {
      await firebase.FirebaseAuth.instance.signOut();
      state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
      return;
    }

    final repo = ref.read(authRepositoryProvider);
    final result = await repo.getCurrentUser();
    
    if (result is Success<User>) {
      state = state.copyWith(status: AuthStatus.authenticated, user: result.data);
    } else {
      await firebase.FirebaseAuth.instance.signOut();
      state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
    }
  }

  void login(User user) {
    // We no longer manually manage state here, as the userChanges listener will catch the sign in.
    // However, if we need to optimistic UI update, we can update it here.
    state = state.copyWith(status: AuthStatus.authenticated, user: user);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    // userChanges listener will catch this and update state automatically.
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(clearError: true);
    final result = await ref
        .read(authRepositoryProvider)
        .changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
    if (result is Success<void>) {
      return true;
    } else if (result is Failure<void>) {
      state = state.copyWith(error: result.error.message);
      return false;
    }
    return false;
  }

  Future<bool> registerBusiness({
    required String ownerName,
    required String email,
    required String password,
    String? phone,
    required String businessName,
    required String storeName,
    required String storeAddress,
    double? latitude,
    double? longitude,
  }) async {
    state = state.copyWith(clearError: true);
    final result = await ref.read(authRepositoryProvider).registerBusiness(
          ownerName: ownerName,
          email: email,
          password: password,
          phone: phone,
          businessName: businessName,
          storeName: storeName,
          storeAddress: storeAddress,
          latitude: latitude,
          longitude: longitude,
        );

    if (result is Success<User>) {
      // Return true without logging in, user must sign in afterwards
      return true;
    } else if (result is Failure<User>) {
      state = state.copyWith(error: result.error.message);
      return false;
    }
    return false;
  }
}


final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
