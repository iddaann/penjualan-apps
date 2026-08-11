import 'package:flutter/material.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/transaction_type.dart';

class TransactionFormScreen extends StatelessWidget {
  const TransactionFormScreen({super.key, required this.type});

  final TransactionType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah ${type.label}', style: AppTypography.heading),
      ),
      body: Center(
        child: Text('Form ${type.label} - coming soon'),
      ),
    );
  }
}