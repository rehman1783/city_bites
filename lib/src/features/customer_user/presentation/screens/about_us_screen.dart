import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'About Us'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(24),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fresh food, fast delivery, hometown care.',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'City Bites brings the best local flavors from Sahiwal straight to your doorstep with convenience, quality, and a warm community touch.',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              theme,
              title: 'Our Story',
              text:
                  'We started with a simple mission: make local food discovery easier and more enjoyable for families, students, and busy professionals.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              theme,
              title: 'What We Offer',
              text:
                  'From restaurant favorites and quick bites to healthy meals and dessert cravings, City Bites connects customers with food they love, delivered with care.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              theme,
              title: 'Our Promise',
              text:
                  'We focus on freshness, transparent service, and reliable delivery so every order feels satisfying and stress-free.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme, {
    required String title,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(text, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
