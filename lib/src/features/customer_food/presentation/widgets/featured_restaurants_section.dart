import 'package:flutter/material.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/image_loader.dart';

class FeaturedRestaurantsSection extends StatelessWidget {
  final Function(Map<String, dynamic> restaurant) onSelectRestaurant;

  const FeaturedRestaurantsSection({
    super.key,
    required this.onSelectRestaurant,
  });

  static const List<Map<String, dynamic>> featuredList = [
    {
      'id': 'r1',
      'name': 'Royal Taj Restaurant',
      'location': 'Scheme 3, College Road',
      'rating': 4.8,
      'deliveryTime': '20-25 min',
      'distance': '1.2 km',
      'image': AssetPaths.royalTaj,
      'tags': ['Biryani', 'Desi', 'Karahi'],
      'isFeatured': true,
    },
    {
      'id': 'r2',
      'name': 'Sahiwal Grill & Fast Food',
      'location': 'High Street Market',
      'rating': 4.6,
      'deliveryTime': '25-30 min',
      'distance': '2.1 km',
      'image': AssetPaths.sahiwalGrill,
      'tags': ['Burgers', 'Fast Food', 'Fries'],
      'isFeatured': true,
    },
    {
      'id': 'r3',
      'name': 'Pizza Haven Sahiwal',
      'location': 'Girls College Road',
      'rating': 4.9,
      'deliveryTime': '30-35 min',
      'distance': '1.8 km',
      'image': AssetPaths.pizzaHaven,
      'tags': ['Pizza', 'Italian', 'Deals'],
      'isFeatured': true,
    },
    {
      'id': 'r4',
      'name': 'Shinwari Karahi House',
      'location': 'Farooq-e-Azam Town',
      'rating': 4.7,
      'deliveryTime': '35-40 min',
      'distance': '3.0 km',
      'image': AssetPaths.chickenKarahi,
      'tags': ['Karahi', 'Desi', 'BBQ'],
      'isFeatured': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.stars_rounded,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Featured Restaurants',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'TOP PICKS',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: featuredList.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = featuredList[index];
              return CustomCard(
                onTap: () => onSelectRestaurant(item),
                padding: EdgeInsets.zero,
                child: SizedBox(
                  width: 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ImageLoader(
                            imageUrl: item['image'],
                            height: 125,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            borderRadius: 16,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(190),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded,
                                      color: AppColors.ratingGold, size: 14),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${item['rating']}',
                                    style: const TextStyle(
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
                            bottom: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${item['distance']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['location'],
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled_rounded,
                                  size: 14,
                                  color: theme.colorScheme.secondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item['deliveryTime'],
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
