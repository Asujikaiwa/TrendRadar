import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendradar/app.dart';
import 'package:trendradar/features/settings/application/settings_providers.dart';
import 'package:trendradar/features/trends/application/trend_providers.dart';
import 'package:trendradar/features/trends/data/trend_repository.dart';

void main() {
  testWidgets('App boots and renders the trending feed', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
          trendRepositoryProvider.overrideWithValue(MockTrendRepository()),
        ],
        child: const TrendRadarApp(),
      ),
    );

    // Initial frame shows the skeleton while the mock repo's latency elapses.
    await tester.pump();

    // Let the fake latency (350ms) resolve, then settle animations.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // The bottom navigation and at least one seeded trend should be present.
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('ชุดชงมัทฉะ'), findsWidgets);
  });
}
