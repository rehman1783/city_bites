import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/image_loader.dart';
import '../bloc/onboarding_cubit.dart';

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
          // Background Gradient Glow Accents
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
                    // Top Header: App Logo + Title + Skip Button
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

                    // Main Full-Height Slider Content (Zero Empty Gaps + Zero Overflow)
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _slides.length,
                        onPageChanged: (index) {
                          context.read<OnboardingCubit>().pageChanged(index);
                        },
                        itemBuilder: (context, index) {
                          final slide = _slides[index];

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final availableHeight = constraints.maxHeight;

                              return SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: availableHeight,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const SizedBox(height: 8),

                                      // Hero Image Frame Card (Dynamically Proportional)
                                      Container(
                                        height: (availableHeight * 0.45)
                                            .clamp(160.0, 320.0),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          boxShadow: [
                                            BoxShadow(
                                              color: theme.colorScheme.primary
                                                  .withAlpha(isDark ? 80 : 35),
                                              blurRadius: 20,
                                              spreadRadius: 1,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              child: ImageLoader(
                                                imageUrl: slide['image']!,
                                                height: double.infinity,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            // Gradient Overlay
                                            Positioned.fill(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.black
                                                          .withAlpha(130),
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end:
                                                        Alignment.bottomCenter,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Floating Tag Badge
                                            Positioned(
                                              bottom: 14,
                                              left: 14,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: theme
                                                      .colorScheme.surface
                                                      .withAlpha(230),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withAlpha(40),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  slide['tag']!,
                                                  style: theme
                                                      .textTheme.labelMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: theme
                                                        .colorScheme.primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      // Typography Section (Badge + Title + Subtitle)
                                      Column(
                                        children: [
                                          // Subhead Category Chip
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme
                                                  .primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              slide['badge']!.toUpperCase(),
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.1,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          // Main Title
                                          Text(
                                            slide['title']!,
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.titleLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 22,
                                              height: 1.25,
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          // Subtitle
                                          Text(
                                            slide['subtitle']!,
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: theme
                                                  .colorScheme.onSurfaceVariant,
                                              height: 1.45,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // Bottom Section: Indicator Dots + CTA Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Page Indicator Dots
                          BlocBuilder<OnboardingCubit, OnboardingState>(
                            builder: (context, state) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _slides.length,
                                  (index) {
                                    final isSelected =
                                        state.currentPage == index;
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      height: 8,
                                      width: isSelected ? 28 : 8,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.outline
                                                .withAlpha(90),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Main Action CTA Button
                          BlocBuilder<OnboardingCubit, OnboardingState>(
                            builder: (context, state) {
                              final isLast =
                                  state.currentPage == _slides.length - 1;
                              return CustomButton(
                                text: isLast
                                    ? 'Get Started — Order Now'
                                    : 'Continue',
                                icon: isLast
                                    ? Icons.rocket_launch_rounded
                                    : Icons.arrow_forward_rounded,
                                onPressed: () {
                                  if (isLast) {
                                    widget.onFinishOnboarding();
                                  } else {
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 350),
                                      curve: Curves.easeInOutCubic,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
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
