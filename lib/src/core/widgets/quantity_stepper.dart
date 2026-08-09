import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  final int count;
  final ValueChanged<int> onChanged;
  final int minCount;
  final int maxCount;

  const QuantityStepper({
    super.key,
    required this.count,
    required this.onChanged,
    this.minCount = 1,
    this.maxCount = 99,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            icon: const Icon(Icons.remove, size: 16),
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
            onPressed: count > minCount ? () => onChanged(count - 1) : null,
            color: theme.colorScheme.primary,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$count',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
            onPressed: count < maxCount ? () => onChanged(count + 1) : null,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
