import 'package:city_bites/src/features/customer_food/presentation/bloc/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/widgets/app_logo.dart';
import '../widgets/onboarding_slide_card.dart';
import '../widgets/onboarding_bottom_controls.dart';

class WelcomeOnboardingScreen extends StatefulWidget {
  final VoidCallback onFinishOnboarding;

  const WelcomeOnboardingScreen({
    super.key,
    required this.onFinishOnboarding,
  });

  @override
  State<WelcomeOnboardingScreen> createState() =>
      _WelcomeOnboardingScreenState();
}

class _WelcomeOnboardingScreenState extends State<WelcomeOnboardingScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, String>> _slides = [
    {
      'badge': 'Sahiwal Food Capital',
      'title': 'Desi Karahi & Fast Food Variety',
      'subtitle':
          'Explore top Sahiwali eateries, traditional Shinwari Karahi, authentic Dum Biryani, and crispy fresh fast food.',
      'image': AssetPaths.onboarding1,
      'tag': '🍲 100+ Local Restaurants',
    },
    {
      'badge': 'Lightning Express Fleet',
      'title': 'Rapid Doorstep Delivery Fleet',
      'subtitle':
          'Our swift local riders ensure your meals arrive piping hot from kitchen counters directly to your doorstep in minutes.',
      'image': AssetPaths.onboarding2,
      'tag': '⚡ Real-time Order Tracking',
    },
    {
      'badge': 'Unmatched Local Value',
      'title': 'Best Deals & Wallet Savings',
      'subtitle':
          'Enjoy transparent local restaurant pricing, exclusive discount promo codes, and zero hidden platform charges.',
      'image': AssetPaths.onboarding3,
      'tag': '💰 Daily Exclusive Vouchers',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Glow Accents
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withAlpha(isDark ? 40 : 25),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.secondary.withAlpha(isDark ? 30 : 20),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Column(
                  children: [
                    // Top Header Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const AppLogo(
                                size: 36,
                                borderRadius: 10,
                                showShadow: false,
                                showBorder: true,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'CITY BYTES',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: widget.onFinishOnboarding,
                            icon: const Icon(Icons.arrow_forward_ios_rounded,
                                size: 12),
                            label: Text(
                              'Skip',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.primary.withAlpha(20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Onboarding Page Content
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _slides.length,
                        onPageChanged: (index) {
                          context.read<OnboardingCubit>().pageChanged(index);
                        },
                        itemBuilder: (context, index) {
                          return OnboardingSlideCard(
                            slide: _slides[index],
                          );
                        },
                      ),
                    ),

                    // Bottom Controls Bar
                    BlocBuilder<OnboardingCubit, OnboardingState>(
                      builder: (context, state) {
                        return OnboardingBottomControls(
                          currentIndex: state.currentPage,
                          totalSlides: _slides.length,
                          pageController: _pageController,
                          onFinish: widget.onFinishOnboarding,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
