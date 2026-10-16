import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/trend_repository.dart';
import '../domain/trend.dart';

/// Binds the repository interface to a concrete implementation.
///
/// Overridden in `main.dart` (and in tests) so the rest of the app depends only
/// on the abstraction. Today it resolves to [MockTrendRepository]; swapping to
/// a Supabase implementation is a single override change here.
final trendRepositoryProvider = Provider<TrendRepository>((ref) {
  throw UnimplementedError(
    'trendRepositoryProvider must be overridden in ProviderScope',
  );
});

/// The ranked trending feed. Auto-disposes when no screen is listening.
final trendingFeedProvider = FutureProvider.autoDispose<List<Trend>>((ref) {
  return ref.watch(trendRepositoryProvider).fetchTrending();
});

/// A single trend by id, for the detail screen.
final trendByIdProvider =
    FutureProvider.autoDispose.family<Trend?, String>((ref, id) {
  return ref.watch(trendRepositoryProvider).fetchById(id);
});

/// Current search query text (driven by the search field).
final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

/// Debounced-by-widget search results for [searchQueryProvider].
final searchResultsProvider = FutureProvider.autoDispose<List<Trend>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return Future.value(const []);
  return ref.watch(trendRepositoryProvider).search(query);
});

/// In-memory set of saved trend ids.
///
/// NOTE: this is intentionally ephemeral for the MVP skeleton. It will be
/// backed by the local Drift database (offline-first) in the Saved-feature
/// milestone; the provider surface stays identical to callers.
class SavedTrendsNotifier extends StateNotifier<Set<String>> {
  SavedTrendsNotifier() : super(const {});

  void toggle(String id) {
    final next = {...state};
    if (!next.remove(id)) next.add(id);
    state = next;
  }

  bool contains(String id) => state.contains(id);
}

final savedTrendsProvider =
    StateNotifierProvider<SavedTrendsNotifier, Set<String>>(
  (ref) => SavedTrendsNotifier(),
);
