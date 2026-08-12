import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_sizes.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/kpi_section.dart';
import '../widgets/revenue_profit_chart.dart';
import '../widgets/recent_transaction_section.dart';
import '../widgets/quick_action_button.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: AppTypography.heading),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardSummaryProvider);
          ref.invalidate(recentTransactionsProvider);
          ref.invalidate(weeklyChartProvider);
        },
        child: summaryAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text('Gagal memuat data: $err', style: AppTypography.body),
          ),
          data: (summary) {
            final chartAsync = ref.watch(weeklyChartProvider);
            final transactionsAsync = ref.watch(recentTransactionsProvider);

            return ListView(
              padding: const EdgeInsets.all(AppSizes.spacingGrid * 2),
              children: [
                KpiSection(summary: summary),
                const SizedBox(height: 24),

                // quick action
                Row(
                  children: [
                    Expanded(
                      child: QuickActionButton(
                        icon: Icons.inventory_2_outlined,
                        label: 'produk',
                        onTap: () => context.push('/product'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickActionButton(
                        icon: Icons.bar_chart_outlined,
                        label: 'laporan',
                        onTap: () => context.go('/report'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                chartAsync.when(
                  loading: () => const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, _) => Text('Gagal memuat grafik: $err'),
                  data: (points) => RevenueProfitChart(points: points),
                ),

                const SizedBox(height: 24),

                transactionsAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, _) => Text('Gagal memuat transaksi: $err'),
                  data: (transactions) =>
                      RecentTransactionsSection(transactions: transactions),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}