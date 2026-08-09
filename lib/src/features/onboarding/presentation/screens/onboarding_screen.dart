import 'package:flutter/material.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/image_loader.dart';

class OnboardingItem {
  final String title;
  final String description;
  final String imageUrl;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = const [
    OnboardingItem(
      title: 'Delicious Food From Top Sahiwal Eateries',
      description:
          'Explore local restaurants and traditional delicacies from Scheme 3, High Street, and College Road delivered hot.',
      imageUrl: AssetPaths.onboarding1,
    ),
    OnboardingItem(
      title: 'Fast & Reliable Hyper-Local Delivery',
      description:
          'Our swift rider fleet ensures your meals are delivered fresh to your doorstep within minutes.',
      imageUrl: AssetPaths.onboarding2,
    ),
    OnboardingItem(
      title: 'For Foodies & Restaurant Owners',
      description:
          'Order your favourite meals as a customer or manage your restaurant menu and orders seamlessly.',
      imageUrl: AssetPaths.onboarding3,
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  void _navigateToAuth() {
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_currentPage < _pages.length - 1)
            TextButton(
              onPressed: _navigateToAuth,
              child: Text(
                'Skip',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration Container
                        Container(
                          height: 280,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(20),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: ImageLoader(
                              imageUrl: item.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          item.title,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bottom Navigation & Indicators
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withAlpha(60),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Button
                  CustomButton(
                    text: _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: _onNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
