import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../notifications/domain/models/notification_models.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';

class OwnerNotificationCard extends ConsumerWidget {
  final AppNotification notification;

  const OwnerNotificationCard({super.key, required this.notification});

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.reservationCreated:
      case NotificationType.reservationConfirmed:
      case NotificationType.reservationRejected:
      case NotificationType.reservationCancelled:
      case NotificationType.reservationReady:
      case NotificationType.reservationCompleted:
      case NotificationType.reservationExpired:
        return Icons.receipt_long_outlined;
      case NotificationType.offerActivated:
      case NotificationType.offerSoldOut:
      case NotificationType.offerExpired:
        return Icons.local_offer_outlined;
      case NotificationType.inventoryExpiringSoon:
      case NotificationType.inventoryCritical:
      case NotificationType.inventoryExpired:
        return Icons.inventory_2_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    // Mark as read if unread
    if (!notification.isRead) {
      ref.read(notificationListProvider.notifier).markAsRead(notification.id);
    }

    // Navigate to respective entity
    final data = notification.data;
    switch (notification.type) {
      case NotificationType.reservationCreated:
      case NotificationType.reservationConfirmed:
      case NotificationType.reservationRejected:
      case NotificationType.reservationCancelled:
      case NotificationType.reservationReady:
      case NotificationType.reservationCompleted:
      case NotificationType.reservationExpired:
        final reservationId = data['reservationId'] as String?;
        if (reservationId != null) {
          context.push('/owner/reservations/$reservationId');
        }
        break;
      case NotificationType.offerActivated:
      case NotificationType.offerSoldOut:
      case NotificationType.offerExpired:
        final offerId = data['offerId'] as String?;
        if (offerId != null) {
          context.push('/owner/offers/$offerId');
        }
        break;
      case NotificationType.inventoryExpiringSoon:
      case NotificationType.inventoryCritical:
      case NotificationType.inventoryExpired:
        final inventoryId = data['inventoryId'] as String?;
        if (inventoryId != null) {
          context.push('/owner/inventory/$inventoryId');
        }
        break;
      default:
        // No default navigation
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUnread = !notification.isRead;

    return InkWell(
      onTap: () => _handleTap(context, ref),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: isUnread
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.2))
              : null,
          boxShadow: isUnread
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: isUnread
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForType(notification.type),
                color: isUnread ? AppColors.primary : AppColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTypography.title.copyWith(
                            color: isUnread
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: isUnread
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        timeago.format(notification.createdAt),
                        style: AppTypography.label.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    notification.body,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isUnread) ...[
              const SizedBox(width: AppSpacing.sm),
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.sm),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
