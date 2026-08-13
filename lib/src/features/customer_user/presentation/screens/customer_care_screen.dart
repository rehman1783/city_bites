import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class CustomerCareScreen extends StatelessWidget {
  const CustomerCareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final supportItems = [
      {
        'title': 'Customer Hotline',
        'value': '+92 300 1234567',
        'icon': Icons.phone_rounded,
      },
      {
        'title': 'WhatsApp Support',
        'value': '+92 300 1234567',
        'icon': Icons.chat_rounded,
      },
      {
        'title': 'Email Support',
        'value': 'support@citybites.pk',
        'icon': Icons.email_rounded,
      },
      {
        'title': 'Business Hours',
        'value': '10:00 AM - 10:00 PM, Daily',
        'icon': Icons.access_time_rounded,
      },
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: 'Sahiwal Help & Customer Care'),
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
                    'Need help with your order?',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Our Sahiwal support team is here to help with deliveries, order updates, and account issues.',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Support Channels',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...supportItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildSupportCard(
                    theme,
                    title: item['title'] as String,
                    value: item['value'] as String,
                    icon: item['icon'] as IconData,
                  ),
                )),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Common Questions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFaqRow(
                    'How can I track my order?',
                    'Open the Order Status section from your profile and monitor the live progress.',
                  ),
                  const SizedBox(height: 12),
                  _buildFaqRow(
                    'Can I change my delivery address?',
                    'Yes. You can update your saved addresses from the saved addresses section in your profile.',
                  ),
                  const SizedBox(height: 12),
                  _buildFaqRow(
                    'Do you support late-night delivery?',
                    'We support daily service until 10:00 PM for most Sahiwal zones.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard(
    ThemeData theme, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
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
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqRow(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(answer),
      ],
    );
  }
}
