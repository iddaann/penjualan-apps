import 'package:flutter/material.dart';
import '../../../data/models/dashboard_summary.dart';
import 'net_profit_card.dart';
import 'kpi_card.dart';

/// Menyusun semua kartu KPI sesuai hierarki visual Bab 8 RPS:
/// 1. Laba Bersih (paling besar, full width)
/// 2. Pendapatan & Total Biaya (sejajar, ukuran sama)
class KpiSection extends StatelessWidget {
  const KpiSection({super.key, required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final totalExpense = summary.operationalExpense + summary.otherExpense;

    return Column(
      children: [
        NetProfitCard(
          netProfit: summary.netProfit,
          profitMargin: summary.profitMargin,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: KpiCard(
                label: 'Pendapatan',
                value: summary.revenue,
                icon: Icons.arrow_downward,
                iconColor: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: KpiCard(
                label: 'Total Biaya',
                value: totalExpense,
                icon: Icons.arrow_upward,
                iconColor: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}