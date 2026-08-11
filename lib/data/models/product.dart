/// Model produk dari katalog (Bab 21 RPS - tabel products).
/// sellPrice dipakai saat transaksi Penjualan,
/// costPrice (harga modal/beli) dipakai untuk hitung HPP & saat Pembelian.
class Product {
  final String id;
  final String name;
  final String category;
  final double sellPrice;
  final double costPrice;
  final int stock;
  final String unit;

  const Product({
    required this.id,
    required this.name,
    required this.category,
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
      sellPrice: (json['sell_price'] as num).toDouble(),
      costPrice: (json['cost_price'] as num).toDouble(),
      stock: json['stock'] as int,
      unit: json['unit'] as String? ?? 'pcs',
    );
  }
}