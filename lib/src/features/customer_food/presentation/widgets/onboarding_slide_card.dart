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
        // Dynamically calculate illustration height according to available screen height
        final imageHeight = (constraints.maxHeight * 0.42).clamp(180.0, 300.0);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top Padding Spacer
                const SizedBox(height: 12),

                // Hero Illustration / Image Container
                Container(
                  height: imageHeight,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              theme.colorScheme.surfaceContainer,
                              theme.colorScheme.surface,
                            ]
                          : [
                              theme.colorScheme.primary.withAlpha(15),
                              theme.colorScheme.surfaceContainerLow,
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withAlpha(
                          isDark ? 50 : 20,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
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
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.colorScheme.secondary.withAlpha(80),
                      ),
                    ),
                    child: Text(
                      slide['tag']!,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Title
                Text(
                  slide['title'] ?? '',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 10),

                // Subtitle
                Text(
                  slide['subtitle'] ?? '',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
