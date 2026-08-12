import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  final int count;
  final ValueChanged<int> onChanged;
  final int minCount;
  final int maxCount;
  final bool isCompact;

  const QuantityStepper({
    super.key,
    required this.count,
    required this.onChanged,
    this.minCount = 1,
    this.maxCount = 99,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSize = isCompact ? 14.0 : 16.0;
    final paddingVal = isCompact ? 4.0 : 6.0;
    final textPadding = isCompact ? 6.0 : 8.0;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha(50),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove, size: iconSize),
            padding: EdgeInsets.all(paddingVal),
            constraints: const BoxConstraints(),
            onPressed: count > minCount ? () => onChanged(count - 1) : null,
            color: theme.colorScheme.primary,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: textPadding),
            child: Text(
              '$count',
              style: (isCompact
                      ? theme.textTheme.titleSmall
                      : theme.textTheme.titleMedium)
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, size: iconSize),
            padding: EdgeInsets.all(paddingVal),
            constraints: const BoxConstraints(),
            onPressed: count < maxCount ? () => onChanged(count + 1) : null,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
