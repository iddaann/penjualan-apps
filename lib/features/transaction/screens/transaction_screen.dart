import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_group_helper.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_type_filter.dart';
import '../widgets/transaction_list_tile.dart';

class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi', style: AppTypography.heading),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          const TransactionTypeFilter(),
          const SizedBox(height: 12),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(transactionListProvider);
              },
              child: transactionsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Text('Gagal memuat transaksi: $err'),
                ),
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return ListView(
                      // ListView (bukan Center) supaya pull-to-refresh
                      // tetap berfungsi walau list kosong
                      children: [
                        const SizedBox(height: 120),
                        Center(
                          child: Text(
                            'Belum ada transaksi',
                            style: AppTypography.caption,
                          ),
                        ),
                      ],
                    );
                  }

                  final grouped = DateGroupHelper.group(
                    transactions,
                    (t) => t.date,
                  );

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
                          (t) => TransactionListTile(transaction: t),
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