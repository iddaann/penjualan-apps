import 'package:flutter/material.dart';
import '../../../core/theme/app_typography.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lainnya', style: AppTypography.heading)),
      body: const Center(child: Text('Lainnya - coming soon')),
    );
  }
}