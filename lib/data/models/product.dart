/// Model produk dari katalog.
class Product {
  final String id;
  final String name;
  final String category;
  final String? categoryId;
  final double sellPrice;
  final double costPrice;
  final int stock;
  final String unit;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    this.categoryId,
    required this.sellPrice,
    required this.costPrice,
    required this.stock,
    required this.unit,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] as String,
      category: json['category'] as String? ?? '-',
      categoryId: json['category_id']?.toString(),
      sellPrice: (json['sell_price'] as num).toDouble(),
      costPrice: (json['cost_price'] as num).toDouble(),
      stock: (json['stock'] as num).toInt(),
      unit: json['unit'] as String? ?? 'pcs',
    );
  }
}