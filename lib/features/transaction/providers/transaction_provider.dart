import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/transaction.dart';
import '../../../data/models/transaction_type.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../data/repositories/transaction_repository_dummy.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryDummy();
});

/// State filter tipe transaksi yang sedang aktif di halaman list.
/// null = tampilkan semua.
final transactionFilterProvider = StateProvider<TransactionType?>((ref) => null);

/// Otomatis re-fetch setiap kali filter berubah, karena provider ini
/// "watch" transactionFilterProvider.
final transactionListProvider = FutureProvider<List<Transaction>>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  final filter = ref.watch(transactionFilterProvider);
  return repo.getTransactions(filterType: filter);
});