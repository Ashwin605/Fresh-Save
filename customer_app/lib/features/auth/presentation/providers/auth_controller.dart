import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';
import '../../../../core/network/app_error_mapper.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'auth_state_provider.dart';

class AuthController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  String _errorMessage(AppError error) {
    return error.message ?? AppErrorMapper.getMessage(error);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.login(email: email, password: password);

    switch (result) {
      case Success(:final data):
        // Use the user directly from the login response — no second API call needed
        ref.read(authStateProvider.notifier).login(data.user);
        state = const AsyncData(null);
      case Failure(:final error):
        state = AsyncError(
          _errorMessage(error),
          StackTrace.current,
        );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );

    switch (result) {
      case Success():
        login(email, password);
      case Failure(:final error):
        state = AsyncError(
          _errorMessage(error),
          StackTrace.current,
        );
    }
  }
}

final authControllerProvider =
    NotifierProvider.autoDispose<AuthController, AsyncValue<void>>(() {
      return AuthController();
    });

