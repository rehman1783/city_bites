import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_button.dart';

class OnboardingBottomControls extends StatelessWidget {
  final int currentIndex;
  final int totalSlides;
  final PageController pageController;
  final VoidCallback onFinish;

  const OnboardingBottomControls({
    super.key,
    required this.currentIndex,
    required this.totalSlides,
    required this.pageController,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastSlide = currentIndex == totalSlides - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalSlides,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: currentIndex == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withAlpha(40),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Next / Get Started Action Button
          CustomButton(
            text: isLastSlide ? 'Get Started' : 'Next',
            icon: isLastSlide
                ? Icons.rocket_launch_rounded
                : Icons.arrow_forward_rounded,
            onPressed: () {
              if (isLastSlide) {
                onFinish();
              } else {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
