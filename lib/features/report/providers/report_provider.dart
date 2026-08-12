import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/report_period.dart';
import '../../../data/models/report_summary.dart';
import '../../../data/models/expense_breakdown_item.dart';
import '../../../data/models/chart_point.dart';
import '../../../data/repositories/report_repository.dart';
import '../../../data/repositories/report_repository_dummy.dart';

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepositoryDummy();
});

/// Periode yang sedang dipilih di halaman Laporan. Default: Mingguan.
final reportPeriodProvider = StateProvider<ReportPeriod>((ref) {
  return ReportPeriod.weekly;
});

final reportSummaryProvider = FutureProvider<ReportSummary>((ref) {
  final repo = ref.watch(reportRepositoryProvider);
  final period = ref.watch(reportPeriodProvider);
  return repo.getSummary(period);
});

final expenseBreakdownProvider =
    FutureProvider<List<ExpenseBreakdownItem>>((ref) {
  final repo = ref.watch(reportRepositoryProvider);
  final period = ref.watch(reportPeriodProvider);
  return repo.getExpenseBreakdown(period);
});

final reportTrendChartProvider = FutureProvider<List<ChartPoint>>((ref) {
  final repo = ref.watch(reportRepositoryProvider);
  final period = ref.watch(reportPeriodProvider);
  return repo.getTrendChart(period);
});