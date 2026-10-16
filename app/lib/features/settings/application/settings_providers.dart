import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Injected in `main.dart` after SharedPreferences is initialized.
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPrefsProvider must be overridden');
});

const _kLocaleKey = 'pref_locale';
const _kThemeKey = 'pref_theme_mode';

/// Persisted app locale. `null` = follow the device locale.
class LocaleController extends StateNotifier<Locale?> {
  LocaleController(this._prefs) : super(_load(_prefs));

  final SharedPreferences _prefs;

  static Locale? _load(SharedPreferences prefs) {
    final code = prefs.getString(_kLocaleKey);
    return code == null ? null : Locale(code);
  }

  Future<void> set(Locale? locale) async {
    state = locale;
    if (locale == null) {
      await _prefs.remove(_kLocaleKey);
    } else {
      await _prefs.setString(_kLocaleKey, locale.languageCode);
    }
  }
}

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale?>(
  (ref) => LocaleController(ref.watch(sharedPrefsProvider)),
);

/// Persisted theme mode (system / light / dark).
class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController(this._prefs) : super(_load(_prefs));

  final SharedPreferences _prefs;

  static ThemeMode _load(SharedPreferences prefs) {
    final name = prefs.getString(_kThemeKey);
    return ThemeMode.values.firstWhere(
      (m) => m.name == name,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_kThemeKey, mode.name);
  }
}

final themeModeControllerProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) => ThemeModeController(ref.watch(sharedPrefsProvider)),
);
