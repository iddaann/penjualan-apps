import 'product_repository.dart';
import '../models/product.dart';

class ProductRepositoryDummy implements ProductRepository {
  // Non-const & non-final list supaya bisa ditambah/diubah/dihapus.
  final List<Product> _dummyData = [
    const Product(
      id: 'p1',
      name: 'Kopi Susu Gula Aren',
      category: 'Minuman',
      sellPrice: 18000,
      costPrice: 9000,
      stock: 42,
      unit: 'cup',
    ),
    const Product(
      id: 'p2',
      name: 'Roti Bakar Coklat Keju',
      category: 'Makanan',
      sellPrice: 15000,
      costPrice: 7500,
      stock: 20,
      unit: 'pcs',
    ),
    const Product(
      id: 'p3',
      name: 'Es Teh Manis',
      category: 'Minuman',
      sellPrice: 8000,
      costPrice: 3000,
      stock: 60,
      unit: 'cup',
    ),
    const Product(
      id: 'p4',
      name: 'Kentang Goreng',
      category: 'Makanan',
      sellPrice: 12000,
      costPrice: 6000,
      stock: 15,
      unit: 'porsi',
    ),
  ];

  @override
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_dummyData);
  }

  @override
  Future<void> createProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _dummyData.add(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _dummyData.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _dummyData[index] = product;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _dummyData.removeWhere((p) => p.id == id);
  }
}