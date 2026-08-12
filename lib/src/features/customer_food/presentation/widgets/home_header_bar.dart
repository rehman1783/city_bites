import 'package:flutter/material.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/custom_textfield.dart';

class HomeHeaderBar extends StatelessWidget {
  final String location;
  final VoidCallback onOpenCart;
  final VoidCallback onLocationTap;
  final ValueChanged<String> onSearchChanged;

  const HomeHeaderBar({
    super.key,
    required this.location,
    required this.onOpenCart,
    required this.onLocationTap,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 12),
        // Top Location & Header
        Row(
          children: [
            const AppLogo(
              size: 44,
              borderRadius: 12,
              showShadow: false,
              showBorder: true,
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.location_on,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: InkWell(
                onTap: onLocationTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deliver to:',
                        style: theme.textTheme.labelMedium,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              location,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: onOpenCart,
              icon: Badge(
                label: const Text('2'),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Search & Filter Bar
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                labelText: '',
                hintText: 'Search biryani, burger, restaurants...',
                prefixIcon: Icons.search_rounded,
                onChanged: onSearchChanged,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
