import 'package:flutter/material.dart';
import 'custom_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onRetry;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.buttonText,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null && buttonText != null) ...[
              const SizedBox(height: 24),
              CustomButton(
                width: 200,
                text: buttonText!,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
