import '../models/transaction.dart';
import '../models/transaction_type.dart';

abstract class TransactionRepository {
  /// filterType null = tampilkan semua tipe.
  Future<List<Transaction>> getTransactions({TransactionType? filterType});
  Future<void> createTransaction(Transaction transaction);
}