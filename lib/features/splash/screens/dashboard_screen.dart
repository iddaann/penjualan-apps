import 'package:flutter/material.dart';
import '../../../core/theme/app_typography.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard', style: AppTypography.heading)),
      body: const Center(child: Text('Dashboard - coming soon')),
    );
  }
}