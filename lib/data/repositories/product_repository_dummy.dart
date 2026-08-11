import 'product_repository.dart';
import '../models/product.dart';

class ProductRepositoryDummy implements ProductRepository {
  @override
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      Product(
        id: 'p1',
        name: 'Kopi Susu Gula Aren',
        category: 'Minuman',
        sellPrice: 18000,
        costPrice: 9000,
        stock: 42,
        unit: 'cup',
      ),
      Product(
        id: 'p2',
        name: 'Roti Bakar Coklat Keju',
        category: 'Makanan',
        sellPrice: 15000,
        costPrice: 7500,
        stock: 20,
        unit: 'pcs',
      ),
      Product(
        id: 'p3',
        name: 'Es Teh Manis',
        category: 'Minuman',
        sellPrice: 8000,
        costPrice: 3000,
        stock: 60,
        unit: 'cup',
      ),
      Product(
        id: 'p4',
        name: 'Kentang Goreng',
        category: 'Makanan',
        sellPrice: 12000,
        costPrice: 6000,
        stock: 15,
        unit: 'porsi',
      ),
    ];
  }
}