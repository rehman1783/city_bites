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
      'title': 'Desi Karahi & Fast Food Variety',
      'subtitle':
          'Explore top Sahiwali eateries, traditional Shinwari Karahi, authentic Biryani, and fresh fast food.',
      'image': AssetPaths.onboarding1,
    },
    {
      'title': 'Rapid Doorstep Delivery Fleet',
      'subtitle':
          'Our swift local riders ensure your meals arrive piping hot from kitchen counters directly to your home.',
      'image': AssetPaths.onboarding2,
    },
    {
      'title': 'Best Deals & Wallet Savings',
      'subtitle':
          'Enjoy transparent local pricing, special discount vouchers, and zero hidden platform charges.',
      'image': AssetPaths.onboarding3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Brand Badge and Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogo(
                    size: 40,
                    borderRadius: 12,
                    showShadow: false,
                    showBorder: true,
                  ),
                  TextButton(
                    onPressed: widget.onFinishOnboarding,
                    child: Text(
                      'Skip',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // PageView Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  context.read<OnboardingCubit>().pageChanged(index);
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: ImageLoader(
                            imageUrl: slide['image']!,
                            height: 280,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          slide['title']!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide['subtitle']!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Page Indicator Dots
            BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: state.currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: state.currentPage == index
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.outline.withAlpha(80),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Bottom Sticky CTA Button
            BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                final isLast = state.currentPage == _slides.length - 1;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: CustomButton(
                    text: isLast ? 'Get Started' : 'Next',
                    icon: isLast ? Icons.arrow_forward : null,
                    onPressed: () {
                      if (isLast) {
                        widget.onFinishOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
