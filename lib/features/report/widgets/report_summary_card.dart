import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/report_summary.dart';

/// Rincian lengkap Pendapatan -> HPP -> Laba Kotor -> Biaya -> Laba Bersih.
/// Beda dari KpiSection Dashboard: ini menampilkan alur perhitungan
/// lengkap (Bab 15 RPS), bukan cuma angka akhir.
class ReportSummaryCard extends StatelessWidget {
  const ReportSummaryCard({super.key, required this.summary});

  final ReportSummary summary;

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
          Text('Ringkasan ${summary.periodLabel}', style: AppTypography.body),
          const SizedBox(height: 12),
          _row('Pendapatan', summary.revenue, isPositive: true),
          _row('HPP (Harga Pokok Penjualan)', -summary.cogs),
          const Divider(height: 20),
          _row('Laba Kotor', summary.grossProfit, isBold: true),
          _row('Biaya Operasional', -summary.operationalExpense),
          _row('Beban Lainnya', -summary.otherExpense),
          const Divider(height: 20),
          _row('Laba Bersih', summary.netProfit,
              isBold: true, isHighlight: true),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Margin: ${summary.profitMargin.toStringAsFixed(1)}%',
              style: AppTypography.caption,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
    String label,
    double value, {
    bool isPositive = false,
    bool isBold = false,
    bool isHighlight = false,
  }) {
    final color = isHighlight
        ? (value >= 0 ? AppColors.success : AppColors.danger)
        : AppColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? AppTypography.body.copyWith(fontWeight: FontWeight.w600)
                : AppTypography.caption,
          ),
          Text(
            '${value < 0 ? '-' : ''}${CurrencyFormatter.format(value.abs())}',
            style: (isBold ? AppTypography.body : AppTypography.caption)
                .copyWith(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}