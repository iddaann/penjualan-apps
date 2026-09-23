import '../../core/network/api_client.dart';
import '../models/chart_point.dart';
import '../models/dashboard_summary.dart';
import '../models/transaction_summary.dart';
import 'dashboard_repository.dart';

class DashboardRepositoryApi implements DashboardRepository {
  @override
  Future<DashboardSummary> getDashboardSummary() async {
    final data = await ApiClient.get('/dashboard');
    return DashboardSummary.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<TransactionSummary>> getRecentTransactions() async {
    final data = await ApiClient.get('/transactions');
    final list = (data as List<dynamic>)
        .map((json) => TransactionSummary.fromJson(json as Map<String, dynamic>))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list.take(5).toList();
  }

  @override
  Future<List<ChartPoint>> getWeeklyChart() async {
    final data = await ApiClient.get('/reports/chart', query: {'period': 'weekly'});
    return (data as List<dynamic>)
        .map((json) => ChartPoint.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}