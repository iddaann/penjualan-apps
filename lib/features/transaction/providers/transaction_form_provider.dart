import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/transaction.dart';
import '../../../data/models/transaction_type.dart';
import 'transaction_provider.dart';
import 'cart_provider.dart';

class TransactionFormNotifier extends StateNotifier<AsyncValue<void>> {
  TransactionFormNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<bool> submitWithItems({
    required TransactionType type,
  }) async {
      final cart = ref.read(cartProvider);
      if (cart.isEmpty) return false;

      state = const AsyncValue.loading();
      try {
        final repo = ref.read(transactionRepositoryProvider);
        final transaction = Transaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: type,
          date: DateTime.now(),
          items: cart.values.toList(),
          totalAmount: cart.values.fold(0, (sum, item) => sum+ item.subtotal),
        );
        await repo.createTransaction(transaction);
        ref.invalidate(transactionListProvider);

        state = const AsyncValue.data(null);
        return true;
      } catch (e,st) {
        state = AsyncValue.error(e, st);
        return false;
      }
  }
}

final transactionFormProvider = 
  StateNotifierProvider<TransactionFormNotifier, AsyncValue<void>>((ref) {
    return TransactionFormNotifier(ref);
  });