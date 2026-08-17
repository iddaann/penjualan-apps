import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/product_category.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/category_repository_api.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryApi();
});

final categoryListProvider = FutureProvider<List<ProductCategory>>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.getAllCategories();
});