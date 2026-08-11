import 'transaction_type.dart';
import 'transaction_item.dart';

/// Model transaksi lengkap (Bab 21 RPS - tabel transactions).
/// items diisi untuk SALE/PURCHASE, kosong untuk OPERATIONAL/EXPENSE
/// (lihat TransactionType.hasItems).
class Transaction {
  final String id;
  final TransactionType type;
  final DateTime date;
  final String? description; // dipakai OPERATIONAL/EXPENSE
  final List<TransactionItem> items; // dipakai SALE/PURCHASE
  final double totalAmount;

  const Transaction({
    required this.id,
    required this.type,
    required this.date,
    this.description,
    this.items = const [],
    required this.totalAmount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      type: TransactionTypeX.fromString(json['type'] as String),
      date: DateTime.parse(json['transaction_date'] as String),
      description: json['description'] as String?,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.apiValue,
        'transaction_date': date.toIso8601String(),
        'description': description,
        'items': items.map((e) => e.toJson()).toList(),
        'total_amount': totalAmount,
      };

  /// Ringkasan untuk ditampilkan di list — kalau ada items, tampilkan
  /// jumlah jenis produk; kalau tidak, pakai description.
  String get displayDescription {
    if (items.isNotEmpty) {
      return items.length == 1
          ? items.first.productName
          : '${items.first.productName} +${items.length - 1} lainnya';
    }
    return description ?? '-';
  }
}