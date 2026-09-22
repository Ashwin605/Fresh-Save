import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/auth_models.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/storage/token_storage.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

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

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Listen to token cleared events (e.g. from 401 interceptor)
    ref.listen(
      tokenStorageProvider.select((ts) => ts.onTokensCleared),
      (previous, next) {
        next.listen((_) {
          // Tokens were cleared (e.g. refresh failed), log out UI state
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            user: null,
          );
        });
      },
      fireImmediately: true,
    );

    Future.microtask(() => _restoreSession());
    return const AuthState();
  }

  Future<void> _restoreSession() async {
    final tokenStorage = ref.read(tokenStorageProvider);
    final accessToken = await tokenStorage.getAccessToken();

    if (accessToken == null) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }

    final repo = ref.read(authRepositoryProvider);
    final result = await repo.getCurrentUser();

    switch (result) {
      case Success(:final data):
        state = state.copyWith(status: AuthStatus.authenticated, user: data);
      case Failure():
        await repo.logout();
        state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
    }
  }

  void login(User user) {
    state = state.copyWith(status: AuthStatus.authenticated, user: user);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
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
