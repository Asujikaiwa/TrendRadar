import 'package:flutter/material.dart';

import 'app_strings.dart';

/// Minimal, dependency-free localization delegate.
///
/// Exposes a typed [AppStrings] table for the active locale via
/// `AppLocalizations.of(context)`. Supported locales: th (default), en, zh.
class AppLocalizations {
  const AppLocalizations(this.strings);

  final AppStrings strings;

  static const supportedLocales = <Locale>[
    Locale('th'),
    Locale('en'),
    Locale('zh'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// Retrieves the current locale's strings. Falls back to Thai if a widget is
  /// somehow built without the delegate in scope (defensive; should not happen).
  static AppStrings of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)
            ?.strings ??
        kStringsTh;
  }

  static AppStrings _resolve(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return kStringsEn;
      case 'zh':
        return kStringsZh;
      case 'th':
      default:
        return kStringsTh;
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales
      .any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(AppLocalizations._resolve(locale));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
