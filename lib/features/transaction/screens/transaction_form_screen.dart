import 'package:flutter/material.dart';
import '../../../data/models/transaction_type.dart';
import 'purchase_form_screen.dart';
import 'sale_form_screen.dart';
import 'simple_transaction_form_screen.dart';

/// Entry point untuk seluruh form tambah transaksi.
///
/// SALE dan PURCHASE menggunakan form berbasis produk agar pengguna dapat
/// memilih produk dan jumlahnya. OPERATIONAL dan EXPENSE menggunakan form
/// sederhana karena keduanya tidak mempunyai item produk.
class TransactionFormScreen extends StatelessWidget {
  const TransactionFormScreen({super.key, required this.type});

  final TransactionType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TransactionType.sale:
        return const SaleFormScreen();
      case TransactionType.purchase:
        return const PurchaseFormScreen();
      case TransactionType.operational:
      case TransactionType.expense:
        return SimpleTransactionFormScreen(type: type);
    }
  }
}
