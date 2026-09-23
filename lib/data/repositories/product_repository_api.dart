import '../models/product.dart';
import '../models/product_category.dart';
import '../../core/network/api_client.dart';
import 'product_repository.dart';

class ProductRepositoryApi implements ProductRepository {
  @override
  Future<List<Product>> getAllProducts() async {
    final data = await ApiClient.get('/products');
    return (data as List<dynamic>)
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<String> _resolveCategoryId(Product product) async {
    if (product.categoryId != null && product.categoryId!.isNotEmpty) {
      return product.categoryId!;
    }
    final data = await ApiClient.get('/categories');
    final categories = (data as List<dynamic>).map((json) => ProductCategory(
      id: json['id'].toString(), name: json['name'] as String,
    )).toList();
    final match = categories.where((c) =>
      c.name.trim().toLowerCase() == product.category.trim().toLowerCase());
    if (match.isEmpty) {
      throw ApiException('Kategori "' + product.category + '" tidak ditemukan.');
    }
    return match.first.id;
  }

  Map<String, dynamic> _toRequest(Product product, String categoryId) => {
    'name': product.name,
    'category_id': int.parse(categoryId),
    'sell_price': product.sellPrice,
    'cost_price': product.costPrice,
    'stock': product.stock,
    'unit': product.unit,
  };

  @override
  Future<void> createProduct(Product product) async {
    final id = await _resolveCategoryId(product);
    await ApiClient.post('/products', _toRequest(product, id));
  }

  @override
  Future<void> updateProduct(Product product) async {
    final id = await _resolveCategoryId(product);
    await ApiClient.put('/products/' + product.id, _toRequest(product, id));
  }

  @override
  Future<void> deleteProduct(String id) async {
    await ApiClient.delete('/products/' + id);
  }
}