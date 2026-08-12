import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/image_loader.dart';
import '../../../../core/services/favorites_service.dart';
import '../../../../core/widgets/snackbar_helper.dart';
import '../../../../core/widgets/rating_badge.dart';

class RestaurantCardTile extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final VoidCallback onTap;

  const RestaurantCardTile({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tags = (restaurant['tags'] as List).map((e) => e.toString()).toList();

    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: NetworkImageLoader(
                  imageUrl: restaurant['image'] ?? '',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: RatingBadge(
                  rating: restaurant['rating'] is num
                      ? (restaurant['rating'] as num).toDouble()
                      : 4.5,
                  reviewCount: restaurant['reviewCount'] is int
                      ? restaurant['reviewCount'] as int
                      : 100,
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable: FavoritesService.instance.restaurants,
                  builder: (context, value, _) {
                    final isFav = value.any(
                      (e) =>
                          (e['id']?.toString() ?? '') ==
                          (restaurant['id']?.toString() ?? ''),
                    );
                    return GestureDetector(
                      onTap: () async {
                        final added = await FavoritesService.instance
                            .toggleRestaurant(restaurant);
                        showAppSnackBar(
                          context,
                          added
                              ? '${restaurant['name']} added to favorites'
                              : '${restaurant['name']} removed from favorites',
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.black54,
                          size: 18,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(180),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        restaurant['deliveryTime'] ?? '25-35 min',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant['name'] ?? '',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            softWrap: true,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  restaurant['branch'] ??
                                      restaurant['location'] ??
                                      '',
                                  style: theme.textTheme.bodySmall,
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Fee: PKR ${restaurant['deliveryFee'] ?? 0}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: tags
                        .map(
                          (t) => Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(t, style: theme.textTheme.labelSmall),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
