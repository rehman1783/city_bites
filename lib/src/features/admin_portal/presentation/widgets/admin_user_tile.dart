import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_card.dart';

class AdminUserTile extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onToggleBlock;

  const AdminUserTile({
    super.key,
    required this.user,
    required this.onToggleBlock,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBlocked = user['status'] == 'Blocked';
    final role = user['role'] ?? 'Customer';

    return CustomCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isBlocked
                ? theme.colorScheme.error.withAlpha(40)
                : theme.colorScheme.primary.withAlpha(40),
            child: Icon(
              role == 'Owner'
                  ? Icons.storefront
                  : role == 'Rider'
                      ? Icons.two_wheeler
                      : Icons.person,
              color: isBlocked
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user['name'] ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        role,
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  user['contact'] ?? '',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  'Registered: ${user['regDate'] ?? ""}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onToggleBlock,
            style: ElevatedButton.styleFrom(
              backgroundColor: isBlocked
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
            ),
            child: Text(
              isBlocked ? 'Unblock' : 'Block',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
