import 'package:flutter/foundation.dart';

/// Build-time environment flavor. Selected via `--dart-define=FLAVOR=...`.
///
/// Keeping this in one place lets us ship a single codebase with distinct
/// bundle ids per flavor (see android/app/build.gradle & Xcode schemes) and
/// swap endpoints without touching feature code.
enum AppFlavor { dev, staging, prod }

/// Centralized, immutable runtime configuration.
///
/// SECURITY: this holds only *public* configuration (base URLs, the Supabase
/// anon/publishable key, feature-flag defaults). Real secrets (service-role
/// keys, signing keys) never ship in the binary — they live server-side.
@immutable
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.apiBaseUrl,
    required this.useMockData,
  });

  final AppFlavor flavor;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String apiBaseUrl;

  /// When true, repositories serve deterministic in-memory fixtures instead of
  /// calling the network. This keeps the app fully runnable before the backend
  /// is provisioned, and powers widget/golden tests.
  final bool useMockData;

  bool get isProd => flavor == AppFlavor.prod;

  /// Resolves configuration from compile-time `--dart-define` values, falling
  /// back to safe dev defaults so `flutter run` works out of the box.
  factory AppConfig.fromEnvironment() {
    const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    final flavor = AppFlavor.values.firstWhere(
      (f) => f.name == flavorName,
      orElse: () => AppFlavor.dev,
    );

    const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.dev.trendradar.app',
    );

    // If no backend keys were provided at build time, run against fixtures.
    final useMock = supabaseUrl.isEmpty || supabaseAnonKey.isEmpty;

    return AppConfig(
      flavor: flavor,
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
      apiBaseUrl: apiBaseUrl,
      useMockData: useMock,
    );
  }
}
