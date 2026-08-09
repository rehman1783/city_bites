import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../bloc/owner_analytics_bloc.dart';

class OwnerAnalyticsScreen extends StatelessWidget {
  const OwnerAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Restaurant Analytics',
      ),
      body: BlocBuilder<OwnerAnalyticsBloc, OwnerAnalyticsState>(
        builder: (context, state) {
          if (state is OwnerAnalyticsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Range Segmented Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ['Today', 'This Week', 'This Month'].map((range) {
                      final isSelected = state.timeRange == range;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(range),
                          selected: isSelected,
                          selectedColor: theme.colorScheme.primary,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          onSelected: (_) {
                            context
                                .read<OwnerAnalyticsBloc>()
                                .setTimeRange(range);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Revenue & Orders Cards
                  Row(
                    children: [
                      Expanded(
                        child: CustomCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Revenue',
                                  style: theme.textTheme.labelMedium),
                              const SizedBox(height: 6),
                              Text(
                                'PKR ${state.totalRevenue.toInt()}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Orders',
                                  style: theme.textTheme.labelMedium),
                              const SizedBox(height: 6),
                              Text(
                                '${state.totalOrders}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Revenue Trend Chart Representation
                  Text(
                    'Revenue Trend',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Growth vs last period'),
                            Text(
                              '+18.4% 🚀',
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Visual Bar representation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildBar(theme, label: 'Mon', height: 40),
                            _buildBar(theme, label: 'Tue', height: 65),
                            _buildBar(theme, label: 'Wed', height: 50),
                            _buildBar(theme, label: 'Thu', height: 80),
                            _buildBar(theme, label: 'Fri', height: 95),
                            _buildBar(theme, label: 'Sat', height: 120),
                            _buildBar(theme, label: 'Sun', height: 110),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Top Selling Dishes Ranking List
                  Text(
                    'Top 5 Selling Dishes',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: state.topDishes.asMap().entries.map((entry) {
                        final idx = entry.key + 1;
                        final dish = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: idx == 1
                                    ? Colors.amber
                                    : theme.colorScheme.surfaceContainerHighest,
                                child: Text(
                                  '#$idx',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: idx == 1
                                        ? Colors.black
                                        : theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  dish['name'],
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                              Text(
                                '${dish['salesCount']} orders',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBar(ThemeData theme,
      {required String label, required double height}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 20,
          height: height,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
