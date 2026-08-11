import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/transaction_item.dart';

/// State keranjang sementara untuk form Penjualan/Pembelian.
/// Key = productId, supaya gampang cek "produk ini udah ada di cart belum".
class CartNotifier extends StateNotifier<Map<String, TransactionItem>> {
  CartNotifier() : super({});

  void addOrUpdate(TransactionItem item) {
    state = {...state, item.productId: item};
  }

  void remove(String productId) {
    final newState = {...state};
    newState.remove(productId);
    state = newState;
  }

  void updateQuantity(String productId, int quantity) {
    final existing = state[productId];
    if (existing == null) return;
    if (quantity <= 0) {
      remove(productId);
      return;
    }
    addOrUpdate(
      TransactionItem(
        productId: existing.productId,
        productName: existing.productName,
        quantity: quantity,
        unitPrice: existing.unitPrice,
      ),
    );
  }

  void clear() => state = {};

  double get total =>
      state.values.fold(0, (sum, item) => sum + item.subtotal);
}

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, TransactionItem>>((ref) {
  return CartNotifier();
});

/// Total harga seluruh item di cart, auto-update setiap cart berubah.
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.values.fold(0, (sum, item) => sum + item.subtotal);
});