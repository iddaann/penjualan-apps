class ChartPoint {
  final DateTime date;
  final double revenue;
  final double profit;

  const ChartPoint({
    required this.date,
    required this.revenue,
    required this.profit,
  });

  factory ChartPoint.fromJson(Map<String, dynamic> json) {
    return ChartPoint(
      date: DateTime.parse(json['date'] as String),
      revenue: (json['revenue'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
    );
  }
}