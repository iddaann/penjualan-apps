import 'transaction_repository.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../models/transaction_item.dart';

class TransactionRepositoryDummy implements TransactionRepository {
  // Simpan di memory supaya transaksi baru yang ditambah kelihatan
  // langsung di list, walau nanti hilang kalau app di-restart.
  final List<Transaction> _dummyData = [
    Transaction(
      id: 't1',
      type: TransactionType.sale,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      totalAmount: 200000,
      items: const [
        TransactionItem(
          productId: 'p1',
          productName: 'Kopi Susu Gula Aren',
          quantity: 10,
          unitPrice: 18000,
        ),
        TransactionItem(
          productId: 'p3',
          productName: 'Es Teh Manis',
          quantity: 5,
          unitPrice: 8000,
        ),
      ],
    ),
    Transaction(
      id: 't2',
      type: TransactionType.expense,
      date: DateTime.now().subtract(const Duration(hours: 5)),
      description: 'Beli galon air',
      totalAmount: 25000,
    ),
    Transaction(
      id: 't3',
      type: TransactionType.operational,
      date: DateTime.now().subtract(const Duration(days: 1)),
      description: 'Bayar listrik',
      totalAmount: 350000,
    ),
    Transaction(
      id: 't4',
      type: TransactionType.purchase,
      date: DateTime.now().subtract(const Duration(days: 2)),
      totalAmount: 450000,
      items: const [
        TransactionItem(
          productId: 'p2',
          productName: 'Roti Bakar Coklat Keju',
          quantity: 30,
          unitPrice: 7500,
        ),
        TransactionItem(
          productId: 'p4',
          productName: 'Kentang Goreng',
          quantity: 20,
          unitPrice: 6000,
        ),
      ],
    ),
  ];

  @override
  Future<List<Transaction>> getTransactions({TransactionType? filterType}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final sorted = [..._dummyData]..sort((a, b) => b.date.compareTo(a.date));
    if (filterType == null) return sorted;
    return sorted.where((t) => t.type == filterType).toList();
  }

  @override
  Future<void> createTransaction(Transaction transaction) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _dummyData.insert(0, transaction);
  }
}