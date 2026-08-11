import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/transaction_type.dart';
import '../providers/transaction_provider.dart';

/// Baris chip filter horizontal-scroll: Semua, Penjualan, Pembelian,
/// Operasional, Pengeluaran. Tap chip -> update transactionFilterProvider,
/// yang otomatis trigger transactionListProvider fetch ulang (lihat Step 5.4.3).
class TransactionTypeFilter extends ConsumerWidget {
  const TransactionTypeFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(transactionFilterProvider);

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _FilterChip(
            label: 'Semua',
            isSelected: activeFilter == null,
            onTap: () =>
                ref.read(transactionFilterProvider.notifier).state = null,
          ),
          const SizedBox(width: 8),
          ...TransactionType.values.map((type) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _FilterChip(
                label: type.label,
                isSelected: activeFilter == type,
                onTap: () =>
                    ref.read(transactionFilterProvider.notifier).state = type,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}