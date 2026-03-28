import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_prefs_provider.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final Ref _ref;

  ThemeNotifier(this._ref) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final prefs = _ref.read(preferencesServiceProvider);
    state = prefs.isDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final isDarkNow = state == ThemeMode.dark;
    final prefs = _ref.read(preferencesServiceProvider);
    await prefs.saveThemeMode(!isDarkNow);
    state = !isDarkNow ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ref);
});
