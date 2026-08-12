import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/product.dart';
import '../providers/product_provider.dart';

/// Form Tambah Produk (existingProduct == null) atau Edit Produk
/// (existingProduct terisi).
class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({super.key, this.existingProduct});

  final Product? existingProduct;

  bool get isEdit => existingProduct != null;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _sellPriceController;
  late final TextEditingController _costPriceController;
  late final TextEditingController _stockController;
  late final TextEditingController _unitController;

  @override
  void initState() {
    super.initState();
    final p = widget.existingProduct;
    _nameController = TextEditingController(text: p?.name ?? '');
    _categoryController = TextEditingController(text: p?.category ?? '');
    _sellPriceController =
        TextEditingController(text: p != null ? p.sellPrice.toStringAsFixed(0) : '');
    _costPriceController =
        TextEditingController(text: p != null ? p.costPrice.toStringAsFixed(0) : '');
    _stockController =
        TextEditingController(text: p != null ? p.stock.toString() : '');
    _unitController = TextEditingController(text: p?.unit ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _sellPriceController.dispose();
    _costPriceController.dispose();
    _stockController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    return null;
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    final parsed = double.tryParse(value);
    if (parsed == null || parsed < 0) return 'Harus angka valid';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      id: widget.existingProduct?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      category: _categoryController.text.trim(),
      sellPrice: double.parse(_sellPriceController.text),
      costPrice: double.parse(_costPriceController.text),
      stock: int.parse(_stockController.text),
      unit: _unitController.text.trim(),
    );

    final success = await ref
        .read(productFormProvider.notifier)
        .save(product, isEdit: widget.isEdit);

    if (success && mounted) {
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan produk')),
      );
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk?'),
        content: Text(
          'Produk "${widget.existingProduct!.name}" akan dihapus permanen. Tindakan ini tidak bisa dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text('Hapus', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref
          .read(productFormProvider.notifier)
          .delete(widget.existingProduct!.id);
      if (success && mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(productFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Produk' : 'Tambah Produk',
          style: AppTypography.heading,
        ),
        actions: [
          if (widget.isEdit)
            IconButton(
              onPressed: formState.isLoading ? null : _confirmDelete,
              icon: Icon(Icons.delete_outline, color: AppColors.danger),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildLabel('Nama Produk'),
            TextFormField(
              controller: _nameController,
              validator: _requiredValidator,
              decoration: const InputDecoration(hintText: 'Contoh: Kopi Susu'),
            ),
            const SizedBox(height: 16),
            _buildLabel('Kategori'),
            TextFormField(
              controller: _categoryController,
              validator: _requiredValidator,
              decoration: const InputDecoration(hintText: 'Contoh: Minuman'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Harga Jual'),
                      TextFormField(
                        controller: _sellPriceController,
                        keyboardType: TextInputType.number,
                        validator: _numberValidator,
                        decoration: const InputDecoration(prefixText: 'Rp '),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Harga Modal'),
                      TextFormField(
                        controller: _costPriceController,
                        keyboardType: TextInputType.number,
                        validator: _numberValidator,
                        decoration: const InputDecoration(prefixText: 'Rp '),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Stok'),
                      TextFormField(
                        controller: _stockController,
                        keyboardType: TextInputType.number,
                        validator: _numberValidator,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Satuan'),
                      TextFormField(
                        controller: _unitController,
                        validator: _requiredValidator,
                        decoration: const InputDecoration(hintText: 'pcs, cup, kg'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: formState.isLoading ? null : _submit,
              child: formState.isLoading
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: AppTypography.caption),
    );
  }
}