import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Small pill showing week-over-week growth, colored by momentum.
class GrowthBadge extends StatelessWidget {
  const GrowthBadge({super.key, required this.growthPercent});

  final double growthPercent;

  @override
  Widget build(BuildContext context) {
    final positive = growthPercent >= 0;
    final color = growthPercent >= 25
        ? AppColors.success
        : positive
            ? AppColors.warning
            : AppColors.danger;
    final sign = positive ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            positive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '$sign${growthPercent.toStringAsFixed(0)}%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
