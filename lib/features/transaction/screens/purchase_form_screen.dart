import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/transaction_type.dart';
import '../../product/providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/transaction_form_provider.dart';
import '../widgets/product_picker_tile.dart';
import '../widgets/cart_summary_bar.dart';

class PurchaseFormScreen extends ConsumerStatefulWidget {
  const PurchaseFormScreen({super.key});

  @override
  ConsumerState<PurchaseFormScreen> createState() =>
      _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends ConsumerState<PurchaseFormScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListProvider);
    final formState = ref.watch(transactionFormProvider);

    ref.listen<AsyncValue<void>>(transactionFormProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan: $err')),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pembelian', style: AppTypography.heading),
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat produk: $err')),
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('Belum ada produk. Tambah produk dulu.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductPickerTile(
                product: products[index],
                isPurchase: true,
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
              .submitWithItems(type: TransactionType.purchase);
          if (success && context.mounted) {
            context.pop();
          }
        },
      ),
    );
  }
}