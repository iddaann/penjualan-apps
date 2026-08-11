import 'package:flutter/material.dart';
import '../../../core/theme/app_typography.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Laporan', style: AppTypography.heading)),
      body: const Center(child: Text('Laporan - coming soon')),
    );
  }
}