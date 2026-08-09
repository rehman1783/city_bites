import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/asset_paths.dart';
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
      'title': "Browse Sahiwal's Top Restaurants",
      'subtitle':
          "Discover authentic Karahi, famous Biryani, local fast food joints, and popular cafes near you.",
      'image': AssetPaths.onboarding1,
    },
    {
      'title': 'Fast Local Delivery via Riders',
      'subtitle':
          'Get hot, fresh food delivered rapidly straight from kitchen counters to your doorstep.',
      'image': AssetPaths.onboarding2,
    },
    {
      'title': 'Compare Prices & Save Commission',
      'subtitle':
          'Enjoy transparent local pricing, zero hidden charges, and direct vendor savings in Sahiwal.',
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
            // Top Bar with Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onFinishOnboarding,
                  child: Text(
                    'Skip',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
                          borderRadius: BorderRadius.circular(20),
                          child: NetworkImageLoader(
                            imageUrl: slide['image']!,
                            height: 280,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 36),
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
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Smooth Page Indicator Dots
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
                            ? theme.colorScheme.primary
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
