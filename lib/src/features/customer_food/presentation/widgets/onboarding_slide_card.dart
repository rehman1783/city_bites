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
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;
        final isLandscape =
            availableWidth > availableHeight && availableHeight < 550;

        if (isLandscape) {
          return _buildLandscapeLayout(
            context,
            theme,
            isDark,
            availableWidth,
            availableHeight,
          );
        } else {
          return _buildPortraitLayout(
            context,
            theme,
            isDark,
            availableWidth,
            availableHeight,
          );
        }
      },
    );
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    double availableWidth,
    double availableHeight,
  ) {
    // Dynamic image height calculation based on available vertical height
    final double imageHeight;
    if (availableHeight < 480) {
      imageHeight = (availableHeight * 0.35).clamp(120.0, 170.0);
    } else if (availableHeight < 620) {
      imageHeight = (availableHeight * 0.40).clamp(170.0, 240.0);
    } else if (availableHeight < 780) {
      imageHeight = (availableHeight * 0.44).clamp(240.0, 310.0);
    } else {
      imageHeight = 350.0;
    }

    // Dynamic typography & spacing scaling
    final double titleFontSize = availableHeight < 520
        ? 19.0
        : (availableHeight < 680 ? 22.0 : 25.0);
    final double subtitleFontSize = availableHeight < 520
        ? 12.5
        : (availableHeight < 680 ? 13.5 : 14.5);
    final double imageMarginBottom = availableHeight < 520
        ? 12.0
        : (availableHeight < 680 ? 16.0 : 20.0);
    final double titleSubGap = availableHeight < 520 ? 6.0 : 10.0;
    final double horizontalPadding = availableWidth < 360 ? 16.0 : 24.0;

    final cardContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: availableHeight < 520 ? 4 : 8),

        // Hero Illustration Container
        _buildHeroImage(
          theme: theme,
          isDark: isDark,
          height: imageHeight,
          width: double.infinity,
          marginBottom: imageMarginBottom,
        ),

        // Slide Title
        Text(
          slide['title'] ?? '',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: titleFontSize,
            height: 1.22,
            letterSpacing: -0.2,
          ),
        ),

        SizedBox(height: titleSubGap),

        // Slide Subtitle
        Text(
          slide['subtitle'] ?? '',
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withAlpha(220),
            fontSize: subtitleFontSize,
            height: 1.42,
            letterSpacing: 0.1,
          ),
        ),

        const SizedBox(height: 12),
      ],
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    double availableWidth,
    double availableHeight,
  ) {
    final imageHeight = availableHeight - 24.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side Image
          Expanded(
            flex: 45,
            child: _buildHeroImage(
              theme: theme,
              isDark: isDark,
              height: imageHeight,
              width: double.infinity,
              marginBottom: 0,
            ),
          ),

          const SizedBox(width: 20),

          // Right side Text details
          Expanded(
            flex: 55,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (slide['badge'] != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withAlpha(50),
                        ),
                      ),
                      child: Text(
                        slide['badge']!,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  Text(
                    slide['title'] ?? '',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    slide['subtitle'] ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage({
    required ThemeData theme,
    required bool isDark,
    required double height,
    required double width,
    required double marginBottom,
  }) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.only(bottom: marginBottom),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
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
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(isDark ? 45 : 25),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 80 : 25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ImageLoader(
              imageUrl: slide['image'] ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              height: height,
            ),

            // Top & Bottom Gradient Overlays
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.30, 0.65, 1.0],
                    colors: [
                      Colors.black.withAlpha(90),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withAlpha(150),
                    ],
                  ),
                ),
              ),
            ),

            // Top Category / Badge Pill
            if (slide['badge'] != null)
              Positioned(
                top: 12,
                left: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(140),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withAlpha(60),
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
                              fontSize: 10.5,
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

            // Bottom Feature Tag Chip
            if (slide['tag'] != null)
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? theme.colorScheme.surfaceContainerHighest
                                .withAlpha(210)
                            : Colors.white.withAlpha(225),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: theme.colorScheme.primary.withAlpha(90),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 15,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              slide['tag']!,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.5,
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
    );
  }
}
