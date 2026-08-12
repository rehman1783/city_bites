import 'package:flutter/material.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/custom_card.dart';

class ProfileUserHeaderCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  const ProfileUserHeaderCard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const AppLogo(
            size: 64,
            borderRadius: 16,
            showShadow: false,
            showBorder: true,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  phone,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
