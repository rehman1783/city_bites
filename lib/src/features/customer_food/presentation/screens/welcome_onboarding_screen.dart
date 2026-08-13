import 'package:city_bites/src/features/customer_food/presentation/bloc/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/widgets/app_logo.dart';
import '../widgets/onboarding_slide_card.dart';
import '../widgets/onboarding_bottom_controls.dart';

class WelcomeOnboardingScreen extends StatefulWidget {
  final VoidCallback onFinishOnboarding;

  const WelcomeOnboardingScreen({super.key, required this.onFinishOnboarding});

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
    Future<bool> onSystemBackPressed() async {
      if (MediaQuery.of(context).viewInsets.bottom > 0) {
        FocusScope.of(context).unfocus();
        return false;
      }
      if (_pageController.hasClients && (_pageController.page ?? 0) > 0) {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
        return false;
      }
      return true;
    }

    return WillPopScope(
      onWillPop: onSystemBackPressed,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
              children: [
                // Top Header Bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: MediaQuery.of(context).size.height < 600 ? 6.0 : 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const AppLogo(
                            size: 38,
                            borderRadius: 12,
                            showShadow: true,
                            showBorder: true,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'CITY BYTES',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.4,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              BlocBuilder<OnboardingCubit, OnboardingState>(
                                builder: (context, state) {
                                  return Text(
                                    'EXPLORE • STEP ${state.currentPage + 1}/${_slides.length}',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.0,
                                      color: theme.colorScheme.onSurfaceVariant
                                          .withAlpha(180),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: widget.onFinishOnboarding,
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 11,
                        ),
                        label: Text(
                          'Skip',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary
                              .withAlpha(22),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: theme.colorScheme.primary.withAlpha(40),
                            ),
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
                      return OnboardingSlideCard(slide: _slides[index]);
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
    ),
    );   
  }
}
