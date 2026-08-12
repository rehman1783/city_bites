import 'package:flutter/material.dart';
import '../../../../core/widgets/image_loader.dart';

class OnboardingSlideCard extends StatelessWidget {
  final Map<String, String> slide;

  const OnboardingSlideCard({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        // Dynamically calculate illustration height according to available screen height (up to 50%)
        final imageHeight = (availableHeight * 0.50).clamp(200.0, 440.0);

        final cardContent = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),

            // Hero Illustration / Image Container
            Container(
              height: imageHeight,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          theme.colorScheme.surfaceContainerHigh,
                          theme.colorScheme.surfaceContainer,
                        ]
                      : [
                          theme.colorScheme.primary.withAlpha(20),
                          theme.colorScheme.surfaceContainerLow,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withAlpha(
                      isDark ? 60 : 25,
                    ),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: ImageLoader(
                  imageUrl: slide['image'] ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: imageHeight,
                ),
              ),
            ),

            // Feature Tag Chip
            if (slide['tag'] != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withAlpha(70),
                  ),
                ),
                child: Text(
                  slide['tag']!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Title
            Text(
              slide['title'] ?? '',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.2,
                fontSize: availableHeight < 400 ? 20 : null,
              ),
            ),

            const SizedBox(height: 10),

            // Subtitle
            Text(
              slide['subtitle'] ?? '',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
                fontSize: availableHeight < 400 ? 13 : null,
              ),
            ),
            const SizedBox(height: 16),
          ],
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: availableHeight),
              child: IntrinsicHeight(
                child: cardContent,
              ),
            ),
          ),
        );
      },
    );
  }
}
