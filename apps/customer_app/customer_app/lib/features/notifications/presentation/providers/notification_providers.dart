import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/notification_models.dart';
import '../../data/repositories/notification_repository.dart';

// Unread Count Provider
class UnreadCountNotifier extends Notifier<AsyncValue<int>> {
  @override
  AsyncValue<int> build() {
    _fetch();
    return const AsyncValue.loading();
  }

  Future<void> _fetch() async {
    final repo = ref.read(notificationRepositoryProvider);
    final result = await repo.getUnreadCount();
    if (result is Success<int>) {
      state = AsyncValue.data(result.data);
    } else {
      state = const AsyncValue.data(0);
    }
  }

  void refresh() {
    state = const AsyncValue.loading();
    _fetch();
  }
}

final unreadCountProvider =
    NotifierProvider<UnreadCountNotifier, AsyncValue<int>>(() {
      return UnreadCountNotifier();
    });

// Notifications List Provider
class NotificationListNotifier
    extends Notifier<AsyncValue<List<AppNotification>>> {
  int _page = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  bool? _unreadFilter;
  NotificationType? _typeFilter;

  @override
  AsyncValue<List<AppNotification>> build() {
    _fetch();
    return const AsyncValue.loading();
  }

  Future<void> _fetch() async {
    final repo = ref.read(notificationRepositoryProvider);
    final result = await repo.getNotifications(
      page: 1,
      unread: _unreadFilter,
      type: _typeFilter,
    );
    if (result is Success<List<AppNotification>>) {
      if (result.data.length < 20) {
        _hasMore = false;
      }
      state = AsyncValue.data(result.data);
    } else {
      state = AsyncValue.error(
        'Failed to load notifications',
        StackTrace.current,
      );
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    final currentList = state.value ?? [];

    _page++;
    final repo = ref.read(notificationRepositoryProvider);
    final result = await repo.getNotifications(
      page: _page,
      unread: _unreadFilter,
      type: _typeFilter,
    );
    if (result is Success<List<AppNotification>>) {
      if (result.data.length < 20) {
        _hasMore = false;
      }
      state = AsyncValue.data([...currentList, ...result.data]);
    }
  }

  void setFilter({bool? unread, NotificationType? type}) {
    _unreadFilter = unread;
    _typeFilter = type;
    refresh();
  }

  void refresh() {
    _page = 1;
    _hasMore = true;
    state = const AsyncValue.loading();
    _fetch();
    ref.read(unreadCountProvider.notifier).refresh();
  }

  Future<void> markAsRead(String id) async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markAsRead(id);

    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(
        current.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList(),
      );
    }
    ref.read(unreadCountProvider.notifier).refresh();
  }

  Future<void> markAllAsRead() async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markAllAsRead();

    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(
        current.map((n) => n.copyWith(isRead: true)).toList(),
      );
    }
    ref.read(unreadCountProvider.notifier).refresh();
  }

  Future<void> deleteNotification(String id) async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.deleteNotification(id);

    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(current.where((n) => n.id != id).toList());
    }
  }
}

final notificationListProvider =
    NotifierProvider<
      NotificationListNotifier,
      AsyncValue<List<AppNotification>>
    >(() {
      return NotificationListNotifier();
    });
