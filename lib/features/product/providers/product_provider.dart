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