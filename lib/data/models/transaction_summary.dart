import 'transaction_type.dart';

class TransactionSummary {
  final String id;
  final TransactionType type;
  final String description;
  final double amount;
  final DateTime date;

  const TransactionSummary({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    return TransactionSummary(
      id: json['id'].toString(),
      type: _typeFromString(json['type'] as String),
      description: json['description'] as String,
      amount: (json['total_amount'] as num).toDouble(),
      date: DateTime.parse(json['transaction_date'] as String),
    );
  }

  static TransactionType _typeFromString(String value) {
    switch (value.toUpperCase()) {
      case 'SALE':
        return TransactionType.sale;
      case 'PURCHASE':
        return TransactionType.purchase;
      case 'OPERATIONAL':
        return TransactionType.operational;
      case 'EXPENSE':
        return TransactionType.expense;
      default:
        return TransactionType.sale;
    }
  }
}