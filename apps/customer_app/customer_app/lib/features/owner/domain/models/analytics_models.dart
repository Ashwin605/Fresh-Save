class AnalyticsKpiSummary {
  final int offersPublished;
  final int reservations;
  final int completedPickups;
  final double fulfillmentRate;
  final double surplusRescued;
  final double valueGenerated;
  final String currency;

  AnalyticsKpiSummary({
    required this.offersPublished,
    required this.reservations,
    required this.completedPickups,
    required this.fulfillmentRate,
    required this.surplusRescued,
    required this.valueGenerated,
    required this.currency,
  });

  factory AnalyticsKpiSummary.fromJson(Map<String, dynamic> json) {
    return AnalyticsKpiSummary(
      offersPublished: json['offersPublished'] ?? 0,
      reservations: json['reservations'] ?? 0,
      completedPickups: json['completedPickups'] ?? 0,
      fulfillmentRate: (json['fulfillmentRate'] as num?)?.toDouble() ?? 0.0,
      surplusRescued: (json['surplusRescued'] as num?)?.toDouble() ?? 0.0,
      valueGenerated: (json['valueGenerated'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
    );
  }
}

class TimeSeriesPoint {
  final DateTime date;
  final double value;

  TimeSeriesPoint({required this.date, required this.value});

  factory TimeSeriesPoint.fromJson(Map<String, dynamic> json) {
    return TimeSeriesPoint(
      date: DateTime.parse(json['date']),
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class AnalyticsInsight {
  final String id;
  final String title;
  final String description;
  final String type; // 'performance', 'opportunity', 'warning'
  final String? actionLabel;
  final String? actionRoute;

  AnalyticsInsight({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.actionLabel,
    this.actionRoute,
  });

  factory AnalyticsInsight.fromJson(Map<String, dynamic> json) {
    return AnalyticsInsight(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      actionLabel: json['actionLabel'] as String?,
      actionRoute: json['actionRoute'] as String?,
    );
  }
}

class AnalyticsDashboardResponse {
  final AnalyticsKpiSummary kpiSummary;
  final List<TimeSeriesPoint> performanceSeries;
  final List<AnalyticsInsight> insights;
  final DateTime lastUpdated;

  AnalyticsDashboardResponse({
    required this.kpiSummary,
    required this.performanceSeries,
    required this.insights,
    required this.lastUpdated,
  });

  factory AnalyticsDashboardResponse.fromJson(Map<String, dynamic> json) {
    return AnalyticsDashboardResponse(
      kpiSummary: AnalyticsKpiSummary.fromJson(json['kpiSummary'] ?? {}),
      performanceSeries:
          (json['performanceSeries'] as List?)
              ?.map((e) => TimeSeriesPoint.fromJson(e))
              .toList() ??
          [],
      insights:
          (json['insights'] as List?)
              ?.map((e) => AnalyticsInsight.fromJson(e))
              .toList() ??
          [],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }
}
