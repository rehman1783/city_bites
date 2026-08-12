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
    final iconSize = isCompact ? 12.0 : 14.0;
    final paddingVal = isCompact ? 0.0 : 1.0;
    final textPadding = isCompact ? 1.0 : 2.0;
    final stepperHeight = isCompact ? 30.0 : 36.0;
    final iconConstraints = isCompact
        ? BoxConstraints(
            minWidth: stepperHeight - 8,
            minHeight: stepperHeight - 8,
          )
        : BoxConstraints(
            minWidth: stepperHeight - 6,
            minHeight: stepperHeight - 6,
          );

    return SizedBox(
      height: stepperHeight,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(34.0),
          border: Border.all(color: theme.colorScheme.outline.withAlpha(50)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove, size: iconSize),
              padding: EdgeInsets.all(paddingVal),
              constraints: iconConstraints,
              onPressed: count > minCount ? () => onChanged(count - 1) : null,
              color: theme.colorScheme.primary,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: textPadding),
              child: Text(
                '$count',
                style:
                    (isCompact
                            ? theme.textTheme.bodySmall
                            : theme.textTheme.labelLarge)
                        ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, size: iconSize),
              padding: EdgeInsets.all(paddingVal),
              constraints: iconConstraints,
              onPressed: count < maxCount ? () => onChanged(count + 1) : null,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
