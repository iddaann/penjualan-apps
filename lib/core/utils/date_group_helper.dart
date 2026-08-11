import 'package:intl/intl.dart';

/// Mengelompokkan list berdasarkan tanggal jadi label yang enak dibaca:
/// "Hari Ini", "Kemarin", atau "d MMMM yyyy" untuk tanggal lain.
class DateGroupHelper {
  DateGroupHelper._();

  static String labelFor(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'Hari Ini';
    if (diff == 1) return 'Kemarin';
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  /// Mengelompokkan list item (yang sudah terurut terbaru->terlama)
  /// menjadi Map<label, List<T>>, dengan urutan label tetap terjaga.
  static Map<String, List<T>> group<T>(
    List<T> items,
    DateTime Function(T) dateOf,
  ) {
    final Map<String, List<T>> result = {};
    for (final item in items) {
      final label = labelFor(dateOf(item));
      result.putIfAbsent(label, () => []).add(item);
    }
    return result;
  }
}