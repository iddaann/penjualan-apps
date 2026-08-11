import 'package:intl/intl.dart';

/// Helper format angka jadi Rupiah, dipakai di seluruh app.
/// Contoh: 25400000 -> "Rp25.400.000"
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  static String format(double amount) {
    return _formatter.format(amount);
  }
}