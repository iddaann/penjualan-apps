import 'category_repository.dart';
import '../models/product_category.dart';

class CategoryRepositoryDummy implements CategoryRepository {
  final List<ProductCategory> _dummyData = [
    const ProductCategory(id: 'c1', name: 'Minuman'),
    const ProductCategory(id: 'c2', name: 'Makanan'),
  ];

  @override
  Future<List<ProductCategory>> getAllCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_dummyData);
  }

  @override
  Future<void> addCategory(String name) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _dummyData.add(
      ProductCategory(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name),
    );
  }

  @override
  Future<void> deleteCategory(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _dummyData.removeWhere((c) => c.id == id);
  }
}