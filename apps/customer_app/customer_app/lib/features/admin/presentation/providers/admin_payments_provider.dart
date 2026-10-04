import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../data/admin_payment_repository.dart';

final adminPaymentStatsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(adminPaymentRepositoryProvider);
  final result = await repo.getPaymentStats();
  if (result is Success<Map<String, dynamic>>) {
    return result.data;
  }
  throw Exception((result as Failure).error.message ?? 'Failed to load stats');
});

final adminPaymentListProvider = FutureProvider.family.autoDispose<Map<String, dynamic>, Map<String, dynamic>>((ref, params) async {
  final repo = ref.watch(adminPaymentRepositoryProvider);
  final result = await repo.getPayments(
    page: params['page'] ?? 1,
    limit: params['limit'] ?? 20,
    status: params['status'],
    search: params['search'],
  );
  if (result is Success<Map<String, dynamic>>) {
    return result.data;
  }
  throw Exception((result as Failure).error.message ?? 'Failed to load payments');
});

final adminPaymentDetailProvider = FutureProvider.family.autoDispose<Map<String, dynamic>, String>((ref, id) async {
  final repo = ref.watch(adminPaymentRepositoryProvider);
  final result = await repo.getPaymentDetails(id);
  if (result is Success<Map<String, dynamic>>) {
    return result.data;
  }
  throw Exception((result as Failure).error.message ?? 'Failed to load payment details');
});
