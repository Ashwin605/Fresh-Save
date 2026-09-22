import '../../../../core/network/result.dart';
import '../../domain/models/analytics_models.dart';

abstract class AnalyticsRepository {
  Future<Result<AnalyticsDashboardResponse>> getAnalyticsDashboard(
    String storeId, {
    String range = '30d',
  });
}
