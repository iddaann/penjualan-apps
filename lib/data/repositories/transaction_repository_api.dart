import '../../core/network/api_client.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import 'transaction_repository.dart';

class TransactionRepositoryApi implements TransactionRepository {
  @override
  Future<List<Transaction>> getTransactions({TransactionType? filterType}) async {
    final data = await ApiClient.get('/transactions',
      query: filterType == null ? null : {'type': filterType.apiValue});
    return (data as List<dynamic>)
        .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> createTransaction(Transaction transaction) async {
    await ApiClient.post('/transactions', transaction.toJson());
  }
}