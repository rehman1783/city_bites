import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Contact Us'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildContactCard(
              theme,
              icon: Icons.phone_rounded,
              title: 'Call Us',
              value: '+92 300 1234567',
            ),
            const SizedBox(height: 14),
            _buildContactCard(
              theme,
              icon: Icons.email_rounded,
              title: 'Email',
              value: 'support@citybites.pk',
            ),
            const SizedBox(height: 14),
            _buildContactCard(
              theme,
              icon: Icons.location_on_rounded,
              title: 'Address',
              value: 'Main Market, Scheme 3, Sahiwal, Punjab, Pakistan',
            ),
            const SizedBox(height: 14),
            _buildContactCard(
              theme,
              icon: Icons.access_time_rounded,
              title: 'Hours',
              value: 'Monday - Sunday: 10:00 AM - 10:00 PM',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(24),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
