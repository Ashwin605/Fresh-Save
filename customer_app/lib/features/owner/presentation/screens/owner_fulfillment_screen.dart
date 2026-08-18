import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/models/owner_reservation_models.dart';
import '../providers/owner_reservation_list_provider.dart';
import '../widgets/reservations/owner_reservation_card.dart';

class OwnerFulfillmentScreen extends ConsumerStatefulWidget {
  const OwnerFulfillmentScreen({super.key});

  @override
  ConsumerState<OwnerFulfillmentScreen> createState() =>
      _OwnerFulfillmentScreenState();
}

class _OwnerFulfillmentScreenState
    extends ConsumerState<OwnerFulfillmentScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(ownerReservationListProvider.notifier)
          .setStatusFilter(ReservationStatus.ready);
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verifyCode(String code) {
    if (code.trim().isEmpty) return;
    context.push('/owner/fulfillment/scan?code=${code.trim()}');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ownerReservationListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Fulfillment'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.push('/owner/fulfillment/scan'),
                    icon: const Icon(Icons.qr_code_scanner, size: 28),
                    label: const Text(
                      'Scan QR Code',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR ENTER CODE',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            hintText: 'e.g. FS-A1B2C3',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: _verifyCode,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => _verifyCode(_codeController.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceVariant,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Verify'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Ready for Pickup',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (state.isLoading && state.reservations.isEmpty)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.reservations.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text('No reservations ready for pickup right now.'),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final reservation = state.reservations[index];
                if (reservation.status != ReservationStatus.ready) {
                  return const SizedBox.shrink();
                }
                return OwnerReservationCard(
                  reservation: reservation,
                  onTap: () =>
                      context.push('/owner/reservations/${reservation.id}'),
                );
              }, childCount: state.reservations.length),
            ),
        ],
      ),
    );
  }
}
