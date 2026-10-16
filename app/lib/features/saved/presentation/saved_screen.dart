import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/widgets/async_states.dart';
import '../../trends/application/trend_providers.dart';
import '../../trends/domain/trend.dart';
import '../../trends/presentation/widgets/trend_card.dart';

/// Saved tab — trends the user bookmarked. Offline-first target: this list is
/// served from the local Drift cache in the persistence milestone.
class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final savedIds = ref.watch(savedTrendsProvider);
    final feed = ref.watch(trendingFeedProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.savedTitle)),
      body: feed.when(
        loading: () => const FeedSkeleton(itemCount: 3),
        error: (_, __) =>
            ErrorState(onRetry: () => ref.invalidate(trendingFeedProvider)),
        data: (all) {
          final saved =
              all.where((Trend t) => savedIds.contains(t.id)).toList();
          if (saved.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border_rounded,
              message: s.savedEmpty,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: saved.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => TrendCard(
              trend: saved[i],
              onTap: () => context.push('/trend/${saved[i].id}'),
            ),
          );
        },
      ),
    );
  }
}
