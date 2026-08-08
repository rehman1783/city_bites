import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_badge.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../bloc/home_cubit.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onCartTap;

  const HomeHeader({
    super.key,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Location Picker
            Expanded(
              child: GestureDetector(
                onTap: () => _showLocationSelector(context, state.selectedLocation),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'DELIVER TO',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Sahiwal - ${state.selectedLocation}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Cart Button Badge
            BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                return CustomBadge(
                  count: cartState.totalItemCount,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_bag_outlined,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: onCartTap,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showLocationSelector(BuildContext context, String currentLocation) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Delivery Location in Sahiwal',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: AppConstants.sahiwalLocations.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final location = AppConstants.sahiwalLocations[index];
                    final isSelected = currentLocation.contains(location);

                    return ListTile(
                      leading: Icon(
                        Icons.place,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      title: Text(
                        location,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                          : null,
                      onTap: () {
                        context.read<HomeCubit>().updateLocation(location);
                        Navigator.pop(modalContext);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
