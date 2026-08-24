import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../notifications/domain/models/notification_models.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../widgets/owner_notification_card.dart';

enum NotificationFilter { all, unread, reservations, offers, inventory }

class OwnerNotificationScreen extends ConsumerStatefulWidget {
  const OwnerNotificationScreen({super.key});

  @override
  ConsumerState<OwnerNotificationScreen> createState() =>
      _OwnerNotificationScreenState();
}

class _OwnerNotificationScreenState
    extends ConsumerState<OwnerNotificationScreen> {
  final ScrollController _scrollController = ScrollController();
  NotificationFilter _currentFilter = NotificationFilter.all;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial fetch handled by provider build
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationListProvider.notifier).loadMore();
    }
  }

  void _onFilterChanged(NotificationFilter filter) {
    setState(() {
      _currentFilter = filter;
    });

    bool? unread;
    NotificationType? type;

    switch (filter) {
      case NotificationFilter.all:
        break;
      case NotificationFilter.unread:
        unread = true;
        break;
      case NotificationFilter.reservations:
        // We can't map a generic "reservations" to a single NotificationType since the backend has multiple.
        // For now we map to created or let backend handle if it supports an array, but the DTO only takes a single enum.
        // Actually, if backend doesn't support category grouping natively, we'll just show all reservations.
        // Let's pass the most common one or just skip filtering by type if backend doesn't support grouping.
        // Since we updated the DTO to handle one type, we will omit the filter here to avoid breaking unless we use a specific type.
        // Wait, DTO takes a single NotificationType. We will just use 'all' for now if complex, or pass null.
        // Or we just don't support the specific category filter if it's too complex, but the prompt says:
        // "Potential: All, Unread, Reservations, Offers, Inventory".
        // If the backend doesn't support category filtering perfectly via `type`, we'll just stick to All/Unread which works flawlessly.
        break;
      case NotificationFilter.offers:
        break;
      case NotificationFilter.inventory:
        break;
    }

    ref
        .read(notificationListProvider.notifier)
        .setFilter(unread: unread, type: type);
  }

  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Mark all as read',
            icon: const Icon(Icons.done_all, color: AppColors.textPrimary),
            onPressed: () {
              ref.read(notificationListProvider.notifier).markAllAsRead();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFilters(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.read(notificationListProvider.notifier).refresh();
              },
              child: notificationsState.when(
                data: (notifications) {
                  // Client-side category filtering as fallback if backend `type` enum is too specific
                  final filteredList = _applyLocalCategoryFilter(notifications);

                  if (filteredList.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 100),
                        Center(
                          child: Text(
                            "You're all caught up.",
                            style: AppTypography.body,
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount:
                        filteredList.length +
                        (ref.read(notificationListProvider.notifier).hasMore
                            ? 1
                            : 0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      if (index == filteredList.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.md),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return OwnerNotificationCard(
                        notification: filteredList[index],
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => AppErrorView(
                  message: error.toString(),
                  onRetry: () =>
                      ref.read(notificationListProvider.notifier).refresh(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: NotificationFilter.values.map((filter) {
            final isSelected = _currentFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ChoiceChip(
                label: Text(
                  filter.name[0].toUpperCase() + filter.name.substring(1),
                  style: AppTypography.label.copyWith(
                    color: isSelected
                        ? AppColors.surface
                        : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.background,
                onSelected: (_) => _onFilterChanged(filter),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<AppNotification> _applyLocalCategoryFilter(
    List<AppNotification> notifications,
  ) {
    if (_currentFilter == NotificationFilter.all ||
        _currentFilter == NotificationFilter.unread) {
      return notifications;
    }

    return notifications.where((n) {
      switch (_currentFilter) {
        case NotificationFilter.reservations:
          return n.type == NotificationType.reservationCreated ||
              n.type == NotificationType.reservationConfirmed ||
              n.type == NotificationType.reservationRejected ||
              n.type == NotificationType.reservationCancelled ||
              n.type == NotificationType.reservationReady ||
              n.type == NotificationType.reservationCompleted ||
              n.type == NotificationType.reservationExpired;
        case NotificationFilter.offers:
          return n.type == NotificationType.offerActivated ||
              n.type == NotificationType.offerSoldOut ||
              n.type == NotificationType.offerExpired;
        case NotificationFilter.inventory:
          return n.type == NotificationType.inventoryExpiringSoon ||
              n.type == NotificationType.inventoryCritical ||
              n.type == NotificationType.inventoryExpired;
        default:
          return true;
      }
    }).toList();
  }
}
