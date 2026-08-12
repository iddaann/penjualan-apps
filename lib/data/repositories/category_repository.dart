import '../models/product_category.dart';

abstract class CategoryRepository {
  Future<List<ProductCategory>> getAllCategories();
  Future<void> addCategory(String name);
  Future<void> deleteCategory(String id);
}