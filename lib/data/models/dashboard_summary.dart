/// Model untuk response GET /dashboard (lihat Bab 25 RPS - API Awal).
/// Field name persis sama dengan JSON dari backend Go supaya nanti
/// fromJson-nya tinggal mapping langsung tanpa transformasi tambahan.
class DashboardSummary {
  final double revenue;
  final double cogs;
  final double grossProfit;
  final double operationalExpense;
  final double otherExpense;
  final double netProfit;
  final double profitMargin;

  const DashboardSummary({
    required this.revenue,
    required this.cogs,
    required this.grossProfit,
    required this.operationalExpense,
    required this.otherExpense,
    required this.netProfit,
    required this.profitMargin,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      revenue: (json['revenue'] as num).toDouble(),
      cogs: (json['cogs'] as num).toDouble(),
      grossProfit: (json['gross_profit'] as num).toDouble(),
      operationalExpense: (json['operational_expense'] as num).toDouble(),
      otherExpense: (json['other_expense'] as num).toDouble(),
      netProfit: (json['net_profit'] as num).toDouble(),
      profitMargin: (json['profit_margin'] as num).toDouble(),
    );
  }

  /// Dipakai sekarang untuk dummy data, sebelum backend Go siap.
  factory DashboardSummary.dummy() {
    return const DashboardSummary(
      revenue: 25400000,
      cogs: 12200000,
      grossProfit: 13200000,
      operationalExpense: 3800000,
      otherExpense: 1000000,
      netProfit: 8400000,
      profitMargin: 33.1,
    );
  }
}