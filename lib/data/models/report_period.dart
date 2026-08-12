/// Tiga periode laporan yang didukung: Harian, Mingguan, Bulanan.
enum ReportPeriod { daily, weekly, monthly }

extension ReportPeriodX on ReportPeriod {
  String get label {
    switch (this) {
      case ReportPeriod.daily:
        return 'Harian';
      case ReportPeriod.weekly:
        return 'Mingguan';
      case ReportPeriod.monthly:
        return 'Bulanan';
    }
  }

  /// Rentang tanggal untuk periode ini, dihitung dari hari ini.
  DateTimeRange get range {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (this) {
      case ReportPeriod.daily:
        return DateTimeRange(start: today, end: today);
      case ReportPeriod.weekly:
        final start = today.subtract(Duration(days: today.weekday - 1));
        return DateTimeRange(start: start, end: start.add(const Duration(days: 6)));
      case ReportPeriod.monthly:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 0);
        return DateTimeRange(start: start, end: end);
    }
  }
}

/// Kelas ringan pengganti Flutter's DateTimeRange supaya model ini
/// tidak perlu import package:flutter di layer data.
class DateTimeRange {
  final DateTime start;
  final DateTime end;
  const DateTimeRange({required this.start, required this.end});
}