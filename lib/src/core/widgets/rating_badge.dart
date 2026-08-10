import 'package:flutter/material.dart';

class RatingBadge extends StatelessWidget {
  final double rating;
  final int? reviewCount;

  const RatingBadge({
    super.key,
    required this.rating,
    this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary, // Logo Royal Violet Brand Accent
        borderRadius: BorderRadius.circular(50.0), // Radius.pill
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (reviewCount != null) ...[
            const SizedBox(width: 3),
            Text(
              '($reviewCount)',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white.withAlpha(200),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
