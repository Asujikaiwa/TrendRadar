import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/async_states.dart';
import '../application/trend_providers.dart';
import '../domain/trend.dart';
import 'widgets/growth_badge.dart';

/// Detail view for one trend: interest chart, related keywords, Pro gating.
class TrendDetailScreen extends ConsumerWidget {
  const TrendDetailScreen({super.key, required this.trendId});

  final String trendId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final async = ref.watch(trendByIdProvider(trendId));

    return Scaffold(
      appBar: AppBar(),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => ErrorState(
          onRetry: () => ref.invalidate(trendByIdProvider(trendId)),
        ),
        data: (trend) {
          if (trend == null) {
            return EmptyState(
              icon: Icons.help_outline_rounded,
              message: s.errorGeneric,
            );
          }
          return _DetailBody(trend: trend);
        },
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.trend});
  final Trend trend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isSaved = ref.watch(
      savedTrendsProvider.select((set) => set.contains(trend.id)),
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Text(trend.title,
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Row(children: [
          GrowthBadge(growthPercent: trend.growthPercent),
          const SizedBox(width: 8),
          Chip(label: Text(trend.category.name)),
        ]),
        const SizedBox(height: 20),
        Text(trend.summary, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 24),

        // --- Interest chart ---
        Text(s.detailInterest,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: trend.isProOnly
              ? _ProLock(message: s.proLocked, cta: s.proUnlockCta)
              : _InterestChart(data: trend.interest),
        ),
        const SizedBox(height: 24),

        // --- Related keywords ---
        Text(s.detailRelated,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final kw in trend.relatedKeywords)
              Chip(
                avatar: const Icon(Icons.tag_rounded, size: 16),
                label: Text(kw),
              ),
          ],
        ),
        const SizedBox(height: 32),

        FilledButton.icon(
          onPressed: () =>
              ref.read(savedTrendsProvider.notifier).toggle(trend.id),
          icon: Icon(isSaved
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded),
          label: Text(isSaved ? s.detailSaved : s.detailSave),
        ),
      ],
    );
  }
}

class _InterestChart extends StatelessWidget {
  const _InterestChart({required this.data});
  final List<double> data;

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[
      for (var i = 0; i < data.length; i++) FlSpot(i.toDouble(), data[i]),
    ];
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (v) => FlLine(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
            strokeWidth: 1,
          ),
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: AppColors.peach,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.peach.withValues(alpha: 0.28),
                  AppColors.peach.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pro paywall overlay shown in place of gated content.
class _ProLock extends StatelessWidget {
  const _ProLock({required this.message, required this.cta});
  final String message;
  final String cta;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.peach.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_rounded, color: AppColors.peach, size: 32),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(message, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                // Paywall flow (RevenueCat) is wired in the monetization
                // milestone. For now, surface intent.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(cta)),
                );
              },
              child: Text(cta),
            ),
          ],
        ),
      ),
    );
  }
}
