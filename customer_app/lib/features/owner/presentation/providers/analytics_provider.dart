import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/analytics_models.dart';
import '../../data/repositories/analytics_repository_impl.dart';
import 'owner_state_provider.dart';

enum AnalyticsDateRange { today, days7, days30, days90 }

extension AnalyticsDateRangeExt on AnalyticsDateRange {
  String get apiValue {
    switch (this) {
      case AnalyticsDateRange.today:
        return 'today';
      case AnalyticsDateRange.days7:
        return '7d';
      case AnalyticsDateRange.days30:
        return '30d';
      case AnalyticsDateRange.days90:
        return '90d';
    }
  }

  String get label {
    switch (this) {
      case AnalyticsDateRange.today:
        return 'Today';
      case AnalyticsDateRange.days7:
        return '7 Days';
      case AnalyticsDateRange.days30:
        return '30 Days';
      case AnalyticsDateRange.days90:
        return '90 Days';
    }
  }
}

class AnalyticsState {
  final bool isLoading;
  final String? error;
  final AnalyticsDashboardResponse? data;
  final AnalyticsDateRange dateRange;

  const AnalyticsState({
    this.isLoading = false,
    this.error,
    this.data,
    this.dateRange = AnalyticsDateRange.days30,
  });

  AnalyticsState copyWith({
    bool? isLoading,
    String? error,
    AnalyticsDashboardResponse? data,
    AnalyticsDateRange? dateRange,
    bool clearError = false,
  }) {
    return AnalyticsState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      data: data ?? this.data,
      dateRange: dateRange ?? this.dateRange,
    );
  }
}

class AnalyticsNotifier extends Notifier<AnalyticsState> {
  @override
  AnalyticsState build() {
    // We defer the initial fetch until the UI binds or we explicitly call refresh
    // But since it depends on activeStore, we can trigger it safely if activeStore is ready.
    Future.microtask(() => _fetch());
    return const AnalyticsState(isLoading: true);
  }

  Future<void> _fetch() async {
    final activeStore = ref.read(ownerStateProvider).activeStore;
    if (activeStore == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'No active store selected.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    final repo = ref.read(analyticsRepositoryProvider);
    final result = await repo.getAnalyticsDashboard(
      activeStore.id,
      range: state.dateRange.apiValue,
    );

    if (result is Success<AnalyticsDashboardResponse>) {
      state = state.copyWith(isLoading: false, data: result.data);
    } else if (result is Failure<AnalyticsDashboardResponse>) {
      state = state.copyWith(isLoading: false, error: result.error.message);
    }
  }

  void setDateRange(AnalyticsDateRange range) {
    if (state.dateRange == range) return;
    state = state.copyWith(dateRange: range);
    _fetch();
  }

  Future<void> refresh() async {
    await _fetch();
  }
}

final analyticsProvider = NotifierProvider<AnalyticsNotifier, AnalyticsState>(
  () {
    return AnalyticsNotifier();
  },
);
