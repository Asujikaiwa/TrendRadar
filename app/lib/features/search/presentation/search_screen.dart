import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/widgets/async_states.dart';
import '../../trends/application/trend_providers.dart';
import '../../trends/presentation/widgets/trend_card.dart';

/// Search tab with a debounced query field.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    // Debounce so we don't hit the repository on every keystroke.
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchQueryProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                onChanged: _onChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: s.searchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _controller.clear();
                            ref.read(searchQueryProvider.notifier).state = '';
                          },
                        ),
                ),
              ),
            ),
            Expanded(
              child: query.trim().isEmpty
                  ? EmptyState(
                      icon: Icons.search_rounded, message: s.searchEmpty)
                  : results.when(
                      loading: () => const FeedSkeleton(itemCount: 3),
                      error: (_, __) => ErrorState(
                        onRetry: () =>
                            ref.invalidate(searchResultsProvider),
                      ),
                      data: (trends) => trends.isEmpty
                          ? EmptyState(
                              icon: Icons.search_off_rounded,
                              message: s.searchEmpty,
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              itemCount: trends.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, i) => TrendCard(
                                trend: trends[i],
                                onTap: () =>
                                    context.push('/trend/${trends[i].id}'),
                              ),
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
