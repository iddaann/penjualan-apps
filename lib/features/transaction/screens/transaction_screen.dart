import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_group_helper.dart';
import '../../../data/models/transaction_type.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_type_filter.dart';
import '../widgets/transaction_list_tile.dart';
import 'transaction_form_screen.dart';

class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key});

  Future<void> _openAddTransaction(BuildContext context) async {
    final type = await showDialog<TransactionType>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Tambah Transaksi', style: AppTypography.heading),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: TransactionType.values.map((type) {
                final color = type.isIncome
                    ? Colors.green
                    : Theme.of(dialogContext).colorScheme.primary;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.1),
                    child: Icon(type.icon, color: color),
                  ),
                  title: Text(
                    type.label,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    type.isIncome ? 'Pemasukan' : 'Pengeluaran',
                    style: AppTypography.caption,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(dialogContext).pop(type),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (type == null || !context.mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TransactionFormScreen(type: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi', style: AppTypography.heading),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTransaction(context),
        child: const Icon(Icons.add),
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
