import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_bites/src/core/constants/asset_paths.dart';
import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/widgets/custom_button.dart';
import 'package:city_bites/src/core/widgets/custom_card.dart';
import 'package:city_bites/src/core/widgets/image_loader.dart';
import 'package:city_bites/src/core/widgets/rating_dialog.dart';
import 'package:city_bites/src/core/widgets/responsive_wrapper.dart';
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

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => RatingDialog(
        orderId: widget.orderId,
        onSubmit: (rating, comment) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Thank you for rating $rating Stars! Feedback recorded.',
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Live Order Tracking',
        onBack: widget.onBackToHome,
      ),
      body: BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
        builder: (context, state) {
          if (state is TrackingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TrackingUpdated) {
            return ResponsiveWrapper(
              maxWidth: 900,
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Simulated Live Map Route Container Header
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          const NetworkImageLoader(
                            imageUrl: AssetPaths.splashBanner,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withAlpha(200),
                                  Colors.black.withAlpha(90),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.my_location_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'LIVE Sahiwal Route Tracker',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 36,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Order #${state.orderId}',
                                            maxLines: 1,
                                            softWrap: false,
                                            overflow: TextOverflow.visible,
                                            style: theme.textTheme.titleLarge
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  
                                                ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Destination: ${state.destination}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white.withAlpha(200),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    'ETA: ${state.eta}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 5 Order Stages Timeline (Pending -> Accepted -> Preparing -> Out for Delivery -> Delivered)
                    Text(
                      'Order Journey Stages',
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
                            title: 'Pending Confirmation',
                            subtitle: 'Order received & sent to restaurant',
                            isDone: state.currentStep >= 0,
                            isActive: state.currentStep == 0,
                          ),
                          _buildStepLine(theme, isDone: state.currentStep >= 1),
                          _buildStepItem(
                            theme,
                            title: 'Accepted by Kitchen',
                            subtitle: 'Vendor has accepted order request',
                            isDone: state.currentStep >= 1,
                            isActive: state.currentStep == 1,
                          ),
                          _buildStepLine(theme, isDone: state.currentStep >= 2),
                          _buildStepItem(
                            theme,
                            title: 'Preparing Food',
                            subtitle: 'Chef is cooking your fresh meal',
                            isDone: state.currentStep >= 2,
                            isActive: state.currentStep == 2,
                          ),
                          _buildStepLine(theme, isDone: state.currentStep >= 3),
                          _buildStepItem(
                            theme,
                            title: 'Out for Delivery',
                            subtitle: 'Sahiwal rider is heading to your door',
                            isDone: state.currentStep >= 3,
                            isActive: state.currentStep == 3,
                          ),
                          _buildStepLine(theme, isDone: state.currentStep >= 4),
                          _buildStepItem(
                            theme,
                            title: 'Delivered',
                            subtitle: 'Meal successfully handed over!',
                            isDone: state.currentStep >= 4,
                            isActive: state.currentStep == 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Post-Delivery Rating Prompt Button
                    if (state.currentStep >= 4) ...[
                      CustomButton(
                        text: 'Rate Your Meal & Delivery',
                        icon: Icons.star_rounded,
                        onPressed: () => _showRatingDialog(context),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Rider & Vendor Contact Card
                    Text(
                      'Assigned Delivery Fleet',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: theme.colorScheme.secondary,
                            child: const Icon(
                              Icons.two_wheeler_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.riderName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sahiwal Express Rider • 4.9 ★',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Calling Sahiwal Rider...'),
                                ),
                              );
                            },
                            icon: CircleAvatar(
                              backgroundColor: theme.colorScheme.secondary
                                  .withAlpha(30),
                              child: Icon(
                                Icons.call_rounded,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
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
            isDone ? Icons.check_rounded : Icons.circle,
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
                  fontWeight: isActive || isDone
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isDone
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(ThemeData theme, {required bool isDone}) {
    return Container(
      margin: const EdgeInsets.only(left: 13, top: 3, bottom: 3),
      height: 20,
      alignment: Alignment.centerLeft,
      child: Container(
        width: 2,
        height: 20,
        color: isDone
            ? theme.colorScheme.primary
            : theme.colorScheme.outline.withAlpha(50),
      ),
    );
  }
}
