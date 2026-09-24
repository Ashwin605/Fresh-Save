import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/coupon_repository.dart';
import '../../domain/models/coupon.dart';
import '../../../../core/network/result.dart';

final availableCouponsProvider = FutureProvider.autoDispose<List<Coupon>>((ref) async {
  final repo = ref.watch(couponRepositoryProvider);
  final result = await repo.getAvailableCoupons();
  if (result is Success<List<Coupon>>) {
    return result.data;
  }
  return [];
});
