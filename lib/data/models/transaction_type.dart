import 'package:flutter/material.dart';

/// Empat tipe transaksi sesuai Bab 21 RPS.
/// SALE = pemasukan. PURCHASE, OPERATIONAL, EXPENSE = pengeluaran.
enum TransactionType { sale, purchase, operational, expense }

extension TransactionTypeX on TransactionType {
  String get label {
    switch (this) {
      case TransactionType.sale:
        return 'Penjualan';
      case TransactionType.purchase:
        return 'Pembelian';
      case TransactionType.operational:
        return 'Operasional';
      case TransactionType.expense:
        return 'Pengeluaran';
    }
  }

  bool get isIncome => this == TransactionType.sale;

  /// Hanya SALE dan PURCHASE yang punya breakdown item produk
  /// (lihat Bab 21: PURCHASE update stok, OPERATIONAL/EXPENSE tidak).
  bool get hasItems =>
      this == TransactionType.sale || this == TransactionType.purchase;

  IconData get icon {
    switch (this) {
      case TransactionType.sale:
        return Icons.point_of_sale;
      case TransactionType.purchase:
        return Icons.shopping_cart_outlined;
      case TransactionType.operational:
        return Icons.settings_outlined;
      case TransactionType.expense:
        return Icons.receipt_long_outlined;
    }
  }

  static TransactionType fromString(String value) {
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

  String get apiValue => name.toUpperCase();
}