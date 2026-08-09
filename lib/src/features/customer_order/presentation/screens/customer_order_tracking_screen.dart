import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_bites/src/core/constants/asset_paths.dart';
import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/widgets/custom_card.dart';
import 'package:city_bites/src/core/widgets/image_loader.dart';
import '../bloc/order_tracking_bloc.dart';

class CustomerOrderTrackingScreen extends StatefulWidget {
  final String orderId;
  final VoidCallback onBackToHome;

  const CustomerOrderTrackingScreen({
    super.key,
    required this.orderId,
    required this.onBackToHome,
  });

  @override
  State<CustomerOrderTrackingScreen> createState() =>
      _CustomerOrderTrackingScreenState();
}

class _CustomerOrderTrackingScreenState
    extends State<CustomerOrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderTrackingBloc>().subscribeToOrderStream(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Track Order',
        onBack: widget.onBackToHome,
      ),
      body: BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
        builder: (context, state) {
          if (state is TrackingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TrackingUpdated) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Live Map / Status Banner Header
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        const NetworkImageLoader(
                          imageUrl: AssetPaths.splashBanner,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withAlpha(180),
                                Colors.black.withAlpha(80),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'ETA: ${state.eta}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Order #${state.orderId}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Order Status Stepper Timeline
                  Text(
                    'Order Progress',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildStepItem(
                          theme,
                          title: 'Order Placed',
                          subtitle: 'We have received your order',
                          isDone: state.currentStep >= 0,
                          isActive: state.currentStep == 0,
                        ),
                        _buildStepLine(theme, isDone: state.currentStep >= 1),
                        _buildStepItem(
                          theme,
                          title: 'Accepted by Restaurant',
                          subtitle: 'Royal Taj is preparing your meal',
                          isDone: state.currentStep >= 1,
                          isActive: state.currentStep == 1,
                        ),
                        _buildStepLine(theme, isDone: state.currentStep >= 2),
                        _buildStepItem(
                          theme,
                          title: 'Out for Delivery',
                          subtitle: 'Rider is on the way with your order',
                          isDone: state.currentStep >= 2,
                          isActive: state.currentStep == 2,
                        ),
                        _buildStepLine(theme, isDone: state.currentStep >= 3),
                        _buildStepItem(
                          theme,
                          title: 'Delivered',
                          subtitle: 'Enjoy your hot meal in Sahiwal!',
                          isDone: state.currentStep >= 3,
                          isActive: state.currentStep == 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Rider & Restaurant Contact Card
                  Text(
                    'Rider & Vendor Info',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.orangeAccent,
                              child: Icon(Icons.two_wheeler,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.riderName,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Delivery Rider • Sahiwal Fleet',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: CircleAvatar(
                                backgroundColor:
                                    theme.colorScheme.secondary.withAlpha(40),
                                child: Icon(Icons.call,
                                    color: theme.colorScheme.secondary),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: CircleAvatar(
                                backgroundColor:
                                    theme.colorScheme.primary.withAlpha(40),
                                child: Icon(Icons.chat_bubble_outline,
                                    color: theme.colorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildStepItem(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required bool isDone,
    required bool isActive,
  }) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withAlpha(50),
          ),
          child: Icon(
            isDone ? Icons.check : Icons.circle,
            size: 16,
            color: isDone ? Colors.white : Colors.transparent,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight:
                      isActive || isDone ? FontWeight.bold : FontWeight.normal,
                  color: isDone
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(ThemeData theme, {required bool isDone}) {
    return Container(
      margin: const EdgeInsets.only(left: 13, top: 4, bottom: 4),
      height: 24,
      alignment: Alignment.centerLeft,
      child: Container(
        width: 2,
        height: 24,
        color: isDone
            ? theme.colorScheme.primary
            : theme.colorScheme.outline.withAlpha(50),
      ),
    );
  }
}
