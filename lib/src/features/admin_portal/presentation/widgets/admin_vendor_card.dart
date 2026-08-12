import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_card.dart';

class AdminVendorCard extends StatelessWidget {
  final Map<String, dynamic> vendor;
  final bool isPending;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const AdminVendorCard({
    super.key,
    required this.vendor,
    required this.isPending,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                vendor['name'] ?? '',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Commission: ${vendor['commissionRate'] ?? 0}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Owner: ${vendor['ownerName'] ?? ""} (CNIC: ${vendor['cnic'] ?? ""})',
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            'Location: ${vendor['address'] ?? ""}',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.verified_outlined,
                  size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                'License Document Verified',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isPending)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error),
                    ),
                    child: const Text('Reject Application'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Approve Restaurant'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
