import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/product_provider.dart';
import '../widgets/product_list_tile.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);
    final query = ref.watch(productSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Produk', style: AppTypography.heading),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/product/add'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: TextField(
              onChanged: (value) =>
                  ref.read(productSearchQueryProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(productListProvider),
              child: productsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Gagal memuat produk: $err')),
                data: (products) {
                  final filtered = query.isEmpty
                      ? products
                      : products
                          .where((p) =>
                              p.name.toLowerCase().contains(query.toLowerCase()))
                          .toList();

                  if (filtered.isEmpty) {
                    return ListView(
                      children: [
                        const SizedBox(height: 100),
                        Center(
                          child: Text(
                            query.isEmpty
                                ? 'Belum ada produk'
                                : 'Produk tidak ditemukan',
                            style: AppTypography.caption,
                          ),
                        ),
                      ],
                    );
                  }

                  // Grouping per kategori
                  final Map<String, List<dynamic>> grouped = {};
                  for (final p in filtered) {
                    grouped.putIfAbsent(p.category, () => []).add(p);
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                    children: grouped.entries.expand((entry) {
                      return [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            entry.key,
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ...entry.value.map(
                          (p) => ProductListTile(
                            product: p,
                            onTap: () => context.push('/product/edit/${p.id}', extra: p),
                          ),
                        ),
                      ];
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}