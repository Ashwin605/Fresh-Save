import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import 'owner_reservation_repository.dart';
import 'owner_reservation_repository_impl.dart';

final ownerReservationRepositoryProvider = Provider<OwnerReservationRepository>(
  (ref) {
    final dioClient = ref.watch(dioProvider);
    return OwnerReservationRepositoryImpl(dioClient);
  },
);
