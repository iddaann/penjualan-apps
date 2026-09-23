import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';

class NetProfitCard extends StatelessWidget {
  const NetProfitCard({super.key, required this.netProfit, required this.profitMargin});
  final double netProfit;
  final double profitMargin;

  @override
  Widget build(BuildContext context) {
    final isPositive = netProfit >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppSizes.cardRadius)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 280;
          final badge = Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(isPositive ? Icons.trending_up : Icons.trending_down, size: 14, color: Colors.white),
              const SizedBox(width: 4),
              Text(profitMargin.toStringAsFixed(1) + '%', style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
            ]),
          );
          final title = Text('Laba Bersih', style: AppTypography.caption.copyWith(color: Colors.white.withValues(alpha: 0.85)));
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (compact) ...[title, const SizedBox(height: 8), Align(alignment: Alignment.centerLeft, child: badge)]
            else Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Flexible(child: title), const SizedBox(width: 8), badge]),
            const SizedBox(height: 12),
            Text(CurrencyFormatter.format(netProfit), style: AppTypography.kpi.copyWith(color: Colors.white), overflow: TextOverflow.ellipsis),
          ]);
        },
      ),
    );
  }
}