import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/expense_breakdown_item.dart';

/// Kombinasi kategori produk (Minuman, Makanan, dst dari Pembelian) dan
/// tipe transaksi non-produk (Operasional, Pengeluaran Lain).
class ExpenseBreakdownList extends StatelessWidget {
  const ExpenseBreakdownList({super.key, required this.items});

  final List<ExpenseBreakdownItem> items;

  static const _colors = [
    AppColors.primary,
    AppColors.success,
    AppColors.warning,
    AppColors.danger,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Breakdown Pengeluaran', style: AppTypography.body),
          const SizedBox(height: 4),
          Text(
            'Per kategori produk & tipe transaksi',
            style: AppTypography.caption,
          ),
          const SizedBox(height: 14),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text('Belum ada data', style: AppTypography.caption),
              ),
            )
          else
            ...items.asMap().entries.map((entry) {
              final item = entry.value;
              final color = _colors[entry.key % _colors.length];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(item.label, style: AppTypography.caption),
                          ],
                        ),
                        Text(
                          '${CurrencyFormatter.format(item.amount)} (${item.percentage.toStringAsFixed(0)}%)',
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: item.percentage / 100,
                        minHeight: 6,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}