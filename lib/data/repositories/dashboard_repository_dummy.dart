import 'dashboard_repository.dart';
import '../models/dashboard_summary.dart';
import '../models/transaction_summary.dart';
import '../models/transaction_type.dart';
import '../models/chart_point.dart';

class DashboardRepositoryDummy implements DashboardRepository {
  @override
  Future<DashboardSummary> getDashboardSummary() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return DashboardSummary.dummy();
  }

  @override
  Future<List<TransactionSummary>> getRecentTransactions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      TransactionSummary(
        id: '1',
        type: TransactionType.sale,
        description: 'Penjualan Produk A',
        amount: 200000,
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      TransactionSummary(
        id: '2',
        type: TransactionType.expense,
        description: 'Beli galon air',
        amount: 25000,
        date: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      TransactionSummary(
        id: '3',
        type: TransactionType.operational,
        description: 'Bayar listrik',
        amount: 350000,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Future<List<ChartPoint>> getWeeklyChart() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final today = DateTime.now();
    final dummyValues = [
      (revenue: 2800000.0, profit: 900000.0),
      (revenue: 3200000.0, profit: 1100000.0),
      (revenue: 2100000.0, profit: 600000.0),
      (revenue: 3900000.0, profit: 1450000.0),
      (revenue: 3500000.0, profit: 1200000.0),
      (revenue: 4200000.0, profit: 1600000.0),
      (revenue: 3100000.0, profit: 980000.0),
    ];

    return List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      return ChartPoint(
        date: day,
        revenue: dummyValues[i].revenue,
        profit: dummyValues[i].profit,
      );
    });
  }
}