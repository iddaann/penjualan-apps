import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/product.dart';
import '../../../data/models/transaction_type.dart';
import '../../product/providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/transaction_form_provider.dart';
import '../widgets/product_picker_tile.dart';
import '../widgets/cart_summary_bar.dart';

class SaleFormScreen extends ConsumerStatefulWidget {
  const SaleFormScreen({super.key});

  @override
  ConsumerState<SaleFormScreen> createState() =>
      _SaleFormScreenState();
}

class _SaleFormScreenState
    extends ConsumerState<SaleFormScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ref.read(productRepositoryProvider).getAllProducts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).clear();
    });
  }

  Future<void> _reloadProducts() async {
    setState(() {
      _productsFuture = ref.read(productRepositoryProvider).getAllProducts();
    });
    await _productsFuture;
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(transactionFormProvider);

    ref.listen<AsyncValue<void>>(transactionFormProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan: ' + err.toString())),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Penjualan',
            style: AppTypography.heading),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal memuat produk',
                      style: AppTypography.heading,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: AppTypography.caption,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _reloadProducts,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final products = snapshot.data ?? const <Product>[];

          if (products.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Belum ada produk. Tambahkan produk terlebih dahulu.',
                  style: AppTypography.body,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            itemCount: products.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Pilih produk (' + products.length.toString() + ' tersedia)',
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }

              return ProductPickerTile(
                product: products[index - 1],
                isPurchase: false,
              );
            },
          );
        },
      ),
      bottomNavigationBar: CartSummaryBar(
        isLoading: formState.isLoading,
        onSubmit: () async {
          final success = await ref
              .read(transactionFormProvider.notifier)
              .submitWithItems(
                type: TransactionType.sale,
              );
          if (success && context.mounted) Navigator.of(context).pop();
        },
      ),
    );
  }
}
