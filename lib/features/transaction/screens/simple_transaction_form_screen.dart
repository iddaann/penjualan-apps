import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/transaction.dart';
import '../../../data/models/transaction_type.dart';
import '../providers/transaction_provider.dart';

/// Form untuk tipe transaksi yang tidak punya breakdown item produk:
/// Operasional dan Pengeluaran (lihat TransactionType.hasItems).
class SimpleTransactionFormScreen extends ConsumerStatefulWidget {
  const SimpleTransactionFormScreen({super.key, required this.type});

  final TransactionType type;

  @override
  ConsumerState<SimpleTransactionFormScreen> createState() =>
      _SimpleTransactionFormScreenState();
}

class _SimpleTransactionFormScreenState
    extends ConsumerState<SimpleTransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final amount = double.parse(
      _amountController.text.replaceAll('.', '').replaceAll(',', '.'),
    );

    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: widget.type,
      date: _selectedDate,
      description: _descriptionController.text.trim(),
      totalAmount: amount,
    );

    try {
      final repo = ref.read(transactionRepositoryProvider);
      await repo.createTransaction(transaction);
      ref.invalidate(transactionListProvider);

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah ${widget.type.label}', style: AppTypography.heading),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Deskripsi', style: AppTypography.caption),
            const SizedBox(height: 6),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: widget.type == TransactionType.operational
                    ? 'Contoh: Bayar listrik'
                    : 'Contoh: Beli galon air',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Deskripsi wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text('Nominal', style: AppTypography.caption),
            const SizedBox(height: 6),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                prefixText: 'Rp ',
                hintText: '0',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nominal wajib diisi';
                }
                final parsed = double.tryParse(
                  value.replaceAll('.', '').replaceAll(',', '.'),
                );
                if (parsed == null || parsed <= 0) {
                  return 'Nominal harus lebih dari 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text('Tanggal', style: AppTypography.caption),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.inputRadius),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('d MMMM yyyy', 'id_ID').format(_selectedDate),
                      style: AppTypography.body,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}