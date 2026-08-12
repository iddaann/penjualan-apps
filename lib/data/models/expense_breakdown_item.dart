class ExpenseBreakdownItem {
  final String label;
  final double amount;
  final double percentage;

  const ExpenseBreakdownItem({
    required this.label,
    required this.amount,
    required this.percentage,
  });

  factory ExpenseBreakdownItem.fromJson(Map<String, dynamic> json) {
    return ExpenseBreakdownItem(
      label: json['label'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}