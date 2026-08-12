import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/product_repository_dummy.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryDummy();
});

final productListProvider = FutureProvider<List<Product>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getAllProducts();
});

/// Kata kunci pencarian produk, dipakai di halaman List Produk.
final productSearchQueryProvider = StateProvider<String>((ref) => '');

/// Handle proses create/update/delete produk (idle/loading/error).
class ProductFormNotifier extends StateNotifier<AsyncValue<void>> {
  ProductFormNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<bool> save(Product product, {required bool isEdit}) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(productRepositoryProvider);
      if (isEdit) {
        await repo.updateProduct(product);
      } else {
        await repo.createProduct(product);
      }
      ref.invalidate(productListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> delete(String id) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(productRepositoryProvider);
      await repo.deleteProduct(id);
      ref.invalidate(productListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final productFormProvider =
    StateNotifierProvider<ProductFormNotifier, AsyncValue<void>>((ref) {
  return ProductFormNotifier(ref);
});