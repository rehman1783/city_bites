import 'dart:ui';
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

            // Hero Illustration Container with Ultra-Chic Frame & Glass Badges
            Container(
              height: imageHeight,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withAlpha(35)
                      : theme.colorScheme.primary.withAlpha(45),
                  width: 1.5,
                ),
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
                  // Ambient primary glow
                  BoxShadow(
                    color: theme.colorScheme.primary.withAlpha(isDark ? 45 : 25),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                    spreadRadius: -4,
                  ),
                  // Sharp drop shadow for 3D depth
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 90 : 35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ImageLoader(
                      imageUrl: slide['image'] ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: imageHeight,
                    ),

                    // Top & Bottom Vignette Gradient Overlays for High Text Contrast
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.0, 0.25, 0.65, 1.0],
                            colors: [
                              Colors.black.withAlpha(100),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withAlpha(160),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Top Category / Badge Pill (Chic Frosted Glass)
                    if (slide['badge'] != null)
                      Positioned(
                        top: 14,
                        left: 14,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(130),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withAlpha(50),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFFF9800),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    slide['badge']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Bottom Feature Tag Chip (Chic Glassmorphic Overlay)
                    if (slide['tag'] != null)
                      Positioned(
                        bottom: 14,
                        left: 14,
                        right: 14,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? theme.colorScheme.surfaceContainerHighest
                                        .withAlpha(210)
                                    : Colors.white.withAlpha(225),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: theme.colorScheme.primary.withAlpha(90),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      slide['tag']!,
                                      style:
                                          theme.textTheme.labelMedium?.copyWith(
                                        color: theme.colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

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
