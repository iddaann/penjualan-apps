class ReportSummary {
  final String periodLabel;
  final double revenue;
  final double cogs;
  final double grossProfit;
  final double operationalExpense;
  final double otherExpense;
  final double netProfit;
  final double profitMargin;

  const ReportSummary({
    required this.periodLabel,
    required this.revenue,
    required this.cogs,
    required this.grossProfit,
    required this.netProfit,
    required this.operationalExpense,
    required this.otherExpense,
    required this.profitMargin,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      periodLabel: json['period_label'] as String,
      revenue: (json['revenue'] as num).toDouble(),
      cogs: (json['cogs'] as num).toDouble(),
      grossProfit: (json['gross_profit'] as num).toDouble(),
      operationalExpense: (json['operational_expense'] as num).toDouble(),
      otherExpense: (json['other_expense']as num).toDouble(),
      netProfit: (json['net_profit']).toDouble(),
      profitMargin: (json['profit_margin'] as num).toDouble(),
    );
  }
}