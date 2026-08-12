import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../bloc/admin_heatmap_bloc.dart';

class AdminAnalyticsHeatmapScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const AdminAnalyticsHeatmapScreen({
    super.key,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Platform Analytics & Heatmap',
        onBack: onBack,
      ),
      body: BlocBuilder<AdminHeatmapBloc, AdminHeatmapState>(
        builder: (context, state) {
          if (state is AdminHeatmapLoaded) {
            return ResponsiveWrapper(
              maxWidth: 950,
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sahiwal Regional Order Density Heatmap Card
                    Text(
                      'Regional Sahiwal Order Density',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: state.densityAreas.map((area) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        area['zone'],
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${area['ordersCount']} orders (${area['density']})',
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                LinearProgressIndicator(
                                  value: area['zone'].toString().contains('Scheme 3')
                                      ? 0.85
                                      : area['zone'].toString().contains('College')
                                          ? 0.60
                                          : 0.35,
                                  backgroundColor:
                                      theme.colorScheme.surfaceContainerHighest,
                                  color: theme.colorScheme.primary,
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Restaurant SLA Leaderboard
                    Text(
                      'Vendor SLA & Performance Leaderboard',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomCard(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: state.slaLeaderboard.map((item) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: item['rank'] == 1
                                  ? theme.colorScheme.primaryContainer
                                  : theme.colorScheme.surfaceContainerHighest,
                              child: Text(
                                '#${item['rank']}',
                                style: TextStyle(
                                  color: item['rank'] == 1
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(item['name']),
                            subtitle: Text('Avg Prep: ${item['avgPrepTime']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${item['rating']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
