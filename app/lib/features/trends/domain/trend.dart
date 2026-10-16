import 'package:flutter/foundation.dart';

/// Broad classification used for filter chips and iconography.
enum TrendCategory { product, keyword, hashtag, content }

/// A single trend signal surfaced in the feed.
///
/// This is a pure domain entity — no JSON / DB annotations here. Mapping to and
/// from Supabase rows or the local Drift cache lives in the data layer, keeping
/// the domain independent of any storage concern.
@immutable
class Trend {
  const Trend({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.growthPercent,
    required this.interest,
    required this.relatedKeywords,
    required this.isProOnly,
  });

  final String id;
  final String title;
  final TrendCategory category;

  /// Short AI-generated explanation of *why* this is trending.
  final String summary;

  /// Week-over-week growth as a percentage (can exceed 100 for breakouts).
  final double growthPercent;

  /// Normalized interest series (0–100) over the trailing window, oldest first.
  /// Drives the sparkline / detail chart.
  final List<double> interest;

  final List<String> relatedKeywords;

  /// Gated behind the Pro subscription. The client only *hides* the payload;
  /// the backend is the source of truth and must also enforce entitlement.
  final bool isProOnly;

  bool get isRising => growthPercent >= 25;
}
