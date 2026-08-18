import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';

class SecurityState {
  final bool isUpdating;
  final String? error;
  final bool isSuccess;

  const SecurityState({
    this.isUpdating = false,
    this.error,
    this.isSuccess = false,
  });

  SecurityState copyWith({bool? isUpdating, String? error, bool? isSuccess}) {
    return SecurityState(
      isUpdating: isUpdating ?? this.isUpdating,
      error: error, // explicit override, allows null
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class SecurityNotifier extends Notifier<SecurityState> {
  @override
  SecurityState build() {
    return const SecurityState();
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isUpdating: true, error: null, isSuccess: false);

    final dio = ref.read(dioProvider);
    try {
      await dio.post(
        '/auth/change-password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
      state = state.copyWith(isUpdating: false, isSuccess: true);
    } catch (e) {
      final error = ApiErrorHandler.handle(e);
      state = state.copyWith(isUpdating: false, error: error.message);
    }
  }

  void resetState() {
    state = const SecurityState();
  }
}

final securityProvider = NotifierProvider<SecurityNotifier, SecurityState>(() {
  return SecurityNotifier();
});
