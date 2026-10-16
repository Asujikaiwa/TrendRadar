import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../application/trend_providers.dart';
import '../../domain/trend.dart';
import 'growth_badge.dart';
import 'sparkline.dart';

/// Feed row for a single [Trend]. Tappable -> detail screen.
class TrendCard extends ConsumerWidget {
  const TrendCard({super.key, required this.trend, required this.onTap});

  final Trend trend;
  final VoidCallback onTap;

  IconData get _categoryIcon => switch (trend.category) {
        TrendCategory.product => Icons.shopping_bag_outlined,
        TrendCategory.keyword => Icons.search_rounded,
        TrendCategory.hashtag => Icons.tag_rounded,
        TrendCategory.content => Icons.play_circle_outline_rounded,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isSaved = ref.watch(
      savedTrendsProvider.select((s) => s.contains(trend.id)),
    );

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.peach.withValues(alpha: 0.14),
                    child: Icon(_categoryIcon,
                        size: 20, color: AppColors.peach),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trend.title,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          trend.category.name,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        ref.read(savedTrendsProvider.notifier).toggle(trend.id),
                    icon: Icon(
                      isSaved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isSaved
                          ? AppColors.peach
                          : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    // Accessibility: describe the toggle for screen readers.
                    tooltip: isSaved ? 'Saved' : 'Save',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                trend.summary,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.75)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  GrowthBadge(growthPercent: trend.growthPercent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ExcludeSemantics(
                      child: Sparkline(
                        data: trend.interest,
                        color: AppColors.peach,
                        height: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
