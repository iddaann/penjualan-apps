import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/dashboard_summary.dart';
import '../../../data/models/transaction_summary.dart';
import '../../../data/models/chart_point.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../../data/repositories/dashboard_repository_dummy.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryDummy();
});

final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return repo.getDashboardSummary();
});

final recentTransactionsProvider =
    FutureProvider<List<TransactionSummary>>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return repo.getRecentTransactions();
});

final weeklyChartProvider = FutureProvider<List<ChartPoint>>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return repo.getWeeklyChart();
});