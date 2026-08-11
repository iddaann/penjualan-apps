import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/product.dart';
import '../../../data/models/transaction_item.dart';
import '../providers/cart_provider.dart';

/// Satu baris produk di daftar pilih produk.
/// [isPurchase] = true berarti dipakai di form Pembelian: pakai costPrice,
/// tidak ada batas maksimal qty (karena pembelian menambah stok, bukan
/// mengurangi). Default false = form Penjualan (pakai sellPrice, qty
/// dibatasi stok yang tersedia).
class ProductPickerTile extends ConsumerWidget {
  const ProductPickerTile({
    super.key,
    required this.product,
    this.isPurchase = false,
  });

  final Product product;
  final bool isPurchase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartItem = cart[product.id];
    final qty = cartItem?.quantity ?? 0;
    final price = isPurchase ? product.costPrice : product.sellPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: qty > 0 ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTypography.body),
                const SizedBox(height: 2),
                Text(
                  '${CurrencyFormatter.format(price)} / ${product.unit}',
                  style: AppTypography.caption,
                ),
                Text(
                  'Stok: ${product.stock}',
                  style: AppTypography.caption.copyWith(
                    color: (!isPurchase && product.stock <= 5)
                        ? AppColors.danger
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (qty == 0)
            IconButton.filled(
              onPressed: () {
                ref.read(cartProvider.notifier).addOrUpdate(
                      TransactionItem(
                        productId: product.id,
                        productName: product.name,
                        quantity: 1,
                        unitPrice: price,
                      ),
                    );
              },
              icon: const Icon(Icons.add, size: 18),
            )
          else
            Row(
              children: [
                IconButton(
                  onPressed: () => ref
                      .read(cartProvider.notifier)
                      .updateQuantity(product.id, qty - 1),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$qty', style: AppTypography.body),
                IconButton(
                  onPressed: () {
                    // Penjualan dibatasi stok, Pembelian tidak.
                    if (!isPurchase && qty >= product.stock) return;
                    ref
                        .read(cartProvider.notifier)
                        .updateQuantity(product.id, qty + 1);
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
        ],
      ),
    );
  }
}