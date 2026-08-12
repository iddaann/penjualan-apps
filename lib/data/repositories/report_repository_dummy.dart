import 'report_repository.dart';
import '../models/report_period.dart';
import '../models/report_summary.dart';
import '../models/expense_breakdown_item.dart';
import '../models/chart_point.dart';

class ReportRepositoryDummy implements ReportRepository {
  @override
  Future<ReportSummary> getSummary(ReportPeriod period) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Angka dummy disesuaikan skalanya per periode supaya realistis.
    final multiplier = switch (period) {
      ReportPeriod.daily => 1.0,
      ReportPeriod.weekly => 7.0,
      ReportPeriod.monthly => 30.0,
    };

    final revenue = 3200000 * multiplier;
    final cogs = 1500000 * multiplier;
    final grossProfit = revenue - cogs;
    final operationalExpense = 200000 * multiplier;
    final otherExpense = 80000 * multiplier;
    final netProfit = grossProfit - operationalExpense - otherExpense;
    final margin = revenue == 0 ? 0.0 : (netProfit / revenue) * 100;

    return ReportSummary(
      periodLabel: period.label,
      revenue: revenue,
      cogs: cogs,
      grossProfit: grossProfit,
      operationalExpense: operationalExpense,
      otherExpense: otherExpense,
      netProfit: netProfit,
      profitMargin: margin,
    );
  }

  @override
  Future<List<ExpenseBreakdownItem>> getExpenseBreakdown(
    ReportPeriod period,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Dummy: breakdown per kategori produk (dari Pembelian) +
    // tipe Operasional & Pengeluaran yang tidak punya kategori produk.
    const raw = [
      ('Minuman', 1200000.0),
      ('Makanan', 900000.0),
      ('Operasional', 600000.0),
      ('Pengeluaran Lain', 300000.0),
    ];
    final total = raw.fold<double>(0, (sum, e) => sum + e.$2);

    return raw
        .map((e) => ExpenseBreakdownItem(
              label: e.$1,
              amount: e.$2,
              percentage: total == 0 ? 0 : (e.$2 / total) * 100,
            ))
        .toList();
  }

  @override
  Future<List<ChartPoint>> getTrendChart(ReportPeriod period) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final days = switch (period) {
      ReportPeriod.daily => 1,
      ReportPeriod.weekly => 7,
      ReportPeriod.monthly => 30,
    };

    final today = DateTime.now();
    return List.generate(days, (i) {
      final day = today.subtract(Duration(days: days - 1 - i));
      final base = 2000000 + (i % 5) * 400000;
      return ChartPoint(
        date: day,
        revenue: base.toDouble(),
        profit: (base * 0.35),
      );
    });
  }
}