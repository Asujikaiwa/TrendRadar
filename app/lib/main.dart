import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'features/settings/application/settings_providers.dart';
import 'features/trends/application/trend_providers.dart';
import 'features/trends/data/trend_repository.dart';

/// Composition root.
///
/// This is the ONE place where concrete implementations are bound to provider
/// interfaces via [ProviderScope] overrides. Everything downstream depends only
/// on abstractions, which is what makes the mock→Supabase swap a local change.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  final prefs = await SharedPreferences.getInstance();

  // Select the data source. Today it's always the mock; once SUPABASE_URL /
  // SUPABASE_ANON_KEY are provided at build time, this branch selects the real
  // repository instead (added in the backend milestone).
  final TrendRepository trendRepo = MockTrendRepository();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        trendRepositoryProvider.overrideWithValue(trendRepo),
      ],
      child: const TrendRadarApp(),
    ),
  );

  // config drives flavor/endpoint selection in the backend milestone.
  assert(() {
    debugPrint('TrendRadar starting — flavor=${config.flavor.name}, '
        'mock=${config.useMockData}');
    return true;
  }());
}
