import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/image_loader.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> _banners = [
    {
      'title': '30% OFF First Order in Sahiwal',
      'subtitle': 'Use Voucher Code: SAHIWAL30',
      'image': AssetPaths.promoBanners[0],
      'tag': 'LIMITED DEAL',
    },
    {
      'title': 'Free Delivery in Scheme 3',
      'subtitle': 'On orders above Rs. 500 from Top Restaurants',
      'image': AssetPaths.promoBanners[1],
      'tag': 'FREE DELIVERY',
    },
    {
      'title': 'Midnight Craving Specials',
      'subtitle': 'Hot Burgers, Pizzas & Karahi till 2 AM',
      'image': AssetPaths.promoBanners[2],
      'tag': 'NIGHT SPECIAL',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          height: 165,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _currentPage == index ? 1.0 : 0.95,
                    child: child,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ImageLoader(
                          imageUrl: banner['image']!,
                          width: double.infinity,
                          height: 165,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Dark Gradient Overlay for optimal text readability
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withAlpha(210),
                              Colors.black.withAlpha(80),
                              Colors.transparent,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      // Content Overlay
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accentOrange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                banner['tag']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              banner['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              banner['subtitle']!,
                              style: TextStyle(
                                color: Colors.white.withAlpha(220),
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
        const SizedBox(height: 12),
        // Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              width: _currentPage == index ? 22 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.accentOrange
                    : theme.colorScheme.outline.withAlpha(80),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
