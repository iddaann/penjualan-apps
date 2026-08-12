import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State tema aktif (light/dark). Disimpan di memory dulu — nanti bisa
/// dipersist ke local storage (shared_preferences) kalau dibutuhkan.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);