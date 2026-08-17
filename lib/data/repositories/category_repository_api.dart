import 'category_repository.dart';
import '../models/product_category.dart';
import '../../core/network/api_client.dart';

/// Implementasi CategoryRepository yang manggil backend Golang beneran,
/// menggantikan CategoryRepositoryDummy.
class CategoryRepositoryApi implements CategoryRepository {
  @override
  Future<List<ProductCategory>> getAllCategories() async {
    final data = await ApiClient.get('/categories');
    final List<dynamic> list = data as List<dynamic>;
    return list.map((json) {
      return ProductCategory(
        id: json['id'].toString(),
        name: json['name'] as String,
      );
    }).toList();
  }

  @override
  Future<void> addCategory(String name) async {
    await ApiClient.post('/categories', {'name': name});
  }

  @override
  Future<void> deleteCategory(String id) async {
    await ApiClient.delete('/categories/$id');
  }
}