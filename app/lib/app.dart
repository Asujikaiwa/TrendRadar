import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/application/settings_providers.dart';

/// Root application widget. Wires theme, localization and routing together and
/// reacts to persisted locale/theme preferences.
class TrendRadarApp extends ConsumerStatefulWidget {
  const TrendRadarApp({super.key});

  @override
  ConsumerState<TrendRadarApp> createState() => _TrendRadarAppState();
}

class _TrendRadarAppState extends ConsumerState<TrendRadarApp> {
  // The router is created once and kept for the widget's lifetime so navigation
  // state survives rebuilds triggered by theme/locale changes.
  late final _router = createRouter();

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider);
    final themeMode = ref.watch(themeModeControllerProvider);

    return MaterialApp.router(
      title: 'TrendRadar',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
