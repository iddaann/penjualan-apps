import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_sizes.dart';
import '../providers/report_provider.dart';
import '../widgets/period_selector.dart';
import '../widgets/report_summary_card.dart';
import '../widgets/expense_breakdown_list.dart';
import '../../dashboard/widgets/revenue_profit_chart.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(reportSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan', style: AppTypography.heading),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(reportSummaryProvider);
          ref.invalidate(expenseBreakdownProvider);
          ref.invalidate(reportTrendChartProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.spacingGrid * 2),
          children: [
            const PeriodSelector(),
            const SizedBox(height: 16),

            summaryAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => Text('Gagal memuat ringkasan: $err'),
              data: (summary) => ReportSummaryCard(summary: summary),
            ),
            const SizedBox(height: 16),

            Consumer(
              builder: (context, ref, _) {
                final chartAsync = ref.watch(reportTrendChartProvider);
                return chartAsync.when(
                  loading: () => const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, _) => Text('Gagal memuat grafik: $err'),
                  data: (points) => RevenueProfitChart(points: points),
                );
              },
            ),
            const SizedBox(height: 16),

            Consumer(
              builder: (context, ref, _) {
                final breakdownAsync = ref.watch(expenseBreakdownProvider);
                return breakdownAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, _) => Text('Gagal memuat breakdown: $err'),
                  data: (items) => ExpenseBreakdownList(items: items),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}