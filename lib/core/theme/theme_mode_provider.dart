import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sellora memakai dark theme sebagai tampilan utama.
/// Provider tetap dipertahankan agar pilihan tema dapat dikembangkan nanti.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);