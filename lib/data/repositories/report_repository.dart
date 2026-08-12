import 'package:sellora_app/data/models/expense_breakdown_item.dart';

import '../models/report_period.dart';
import '../models/report_summary.dart';
import '../models/expense_breakdown_item.dart';
import '../models/chart_point.dart';

abstract class ReportRepository {
  Future<ReportSummary> getSummary(ReportPeriod period);
  Future<List<ExpenseBreakdownItem>> getExpenseBreakdown(ReportPeriod period);
  Future<List<ChartPoint>> getTrendChart(ReportPeriod period);
}