import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../domain/models/owner_reservation_models.dart';
import '../providers/owner_reservation_list_provider.dart';
import '../widgets/reservations/owner_reservation_card.dart';

class OwnerReservationsScreen extends ConsumerStatefulWidget {
  const OwnerReservationsScreen({super.key});

  @override
  ConsumerState<OwnerReservationsScreen> createState() =>
      _OwnerReservationsScreenState();
}

class _OwnerReservationsScreenState
    extends ConsumerState<OwnerReservationsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(ownerReservationListProvider.notifier).searchByCode(value);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ownerReservationListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Reservations',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(state.filter),
          Expanded(child: _buildContent(state)),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(OwnerReservationListFilter filter) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search by Reservation Code',
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.surfaceVariant.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 16),
          // Status Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', null, filter.status),
                _buildFilterChip(
                  'Pending',
                  ReservationStatus.pending,
                  filter.status,
                ),
                _buildFilterChip(
                  'Confirmed',
                  ReservationStatus.confirmed,
                  filter.status,
                ),
                _buildFilterChip(
                  'Ready',
                  ReservationStatus.ready,
                  filter.status,
                ),
                _buildFilterChip(
                  'Completed',
                  ReservationStatus.completed,
                  filter.status,
                ),
                _buildFilterChip(
                  'Cancelled',
                  ReservationStatus.cancelled,
                  filter.status,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    ReservationStatus? status,
    ReservationStatus? currentStatus,
  ) {
    final isSelected = status == currentStatus;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.surface : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            ref
                .read(ownerReservationListProvider.notifier)
                .setStatusFilter(status);
          }
        },
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surfaceVariant,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildContent(OwnerReservationListState state) {
    if (state.isLoading && state.reservations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.reservations.isEmpty) {
      return Center(
        child: AppErrorView(
          message: state.error!,
          onRetry: () =>
              ref.read(ownerReservationListProvider.notifier).refresh(),
        ),
      );
    }

    if (state.reservations.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(ownerReservationListProvider.notifier).refresh(),
      color: AppColors.primary,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!state.isLoading &&
              !state.isPaginating &&
              scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
            ref.read(ownerReservationListProvider.notifier).loadMore();
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.reservations.length + (state.isPaginating ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.reservations.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final reservation = state.reservations[index];
            return OwnerReservationCard(
              reservation: reservation,
              onTap: () {
                context.push('/owner/reservations/${reservation.id}');
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No reservations found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search or filters.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
