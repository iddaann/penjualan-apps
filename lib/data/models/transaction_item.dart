/// Satu baris item dalam transaksi Penjualan/Pembelian.
/// productName didenormalisasi (disimpan langsung) supaya riwayat
/// transaksi lama tetap tampil benar walau nama produk diubah nanti.
class TransactionItem {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  const TransactionItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  double get subtotal => quantity * unitPrice;

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      productId: json['product_id'].toString(),
      productName: json['product_name'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'quantity': quantity,
        'unit_price': unitPrice,
      };
}