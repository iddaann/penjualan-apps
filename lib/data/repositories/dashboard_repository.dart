import '../models/dashboard_summary.dart';
import '../models/transaction_summary.dart';
import '../models/chart_point.dart';

/// Kontrak (interface) untuk sumber data Dashboard.
/// UI cuma tahu ada method ini, tidak peduli datanya dari mana
/// (dummy sekarang, REST API Golang nanti).
abstract class DashboardRepository {
  Future<DashboardSummary> getDashboardSummary();
  Future<List<TransactionSummary>> getRecentTransactions();
  Future<List<ChartPoint>> getWeeklyChart();
}