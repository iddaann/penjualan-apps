import '../../core/network/api_client.dart';
import '../models/chart_point.dart';
import '../models/expense_breakdown_item.dart';
import '../models/report_period.dart';
import '../models/report_summary.dart';
import 'report_repository.dart';

class ReportRepositoryApi implements ReportRepository {
  String _periodValue(ReportPeriod period) {
    switch (period) {
      case ReportPeriod.daily: return 'daily';
      case ReportPeriod.weekly: return 'weekly';
      case ReportPeriod.monthly: return 'monthly';
    }
  }

  @override
  Future<ReportSummary> getSummary(ReportPeriod period) async {
    final data = await ApiClient.get('/reports/summary',
      query: {'period': _periodValue(period)});
    return ReportSummary.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<ExpenseBreakdownItem>> getExpenseBreakdown(ReportPeriod period) async {
    final data = await ApiClient.get('/reports/breakdown',
      query: {'period': _periodValue(period)});
    return (data as List<dynamic>)
        .map((json) => ExpenseBreakdownItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ChartPoint>> getTrendChart(ReportPeriod period) async {
    final data = await ApiClient.get('/reports/chart',
      query: {'period': _periodValue(period)});
    return (data as List<dynamic>)
        .map((json) => ChartPoint.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}