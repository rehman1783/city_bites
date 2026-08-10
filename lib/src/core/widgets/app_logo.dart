import 'package:flutter/material.dart';
import '../constants/asset_paths.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final double borderRadius;
  final bool showShadow;
  final bool showBorder;
  final Color? backgroundColor;
  final BoxFit fit;
  final bool isOriginal;

  const AppLogo({
    super.key,
    this.size = 120,
    this.borderRadius = 24,
    this.showShadow = true,
    this.showBorder = false,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.isOriginal = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final containerColor = backgroundColor ??
        (isDark ? theme.colorScheme.surfaceContainerHighest : theme.colorScheme.primaryContainer);

    final logoPath = isOriginal ? AssetPaths.logoAssetOriginal : AssetPaths.logoAssetSmall;

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.02), // Minimal padding ensuring maximum text legibility & emblem size
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(
                color: theme.colorScheme.primary.withAlpha(90),
                width: 1.5,
              )
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withAlpha(isDark ? 90 : 45),
                  blurRadius: size * 0.18,
                  spreadRadius: size * 0.02,
                  offset: Offset(0, size * 0.05),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius * 0.65),
        child: Image.asset(
          logoPath,
          width: size,
          height: size,
          fit: fit,
          filterQuality: FilterQuality.high,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) {
              return child;
            }
            return Center(
              child: SizedBox(
                width: size * 0.25,
                height: size * 0.25,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            color: containerColor,
            alignment: Alignment.center,
            child: Icon(
              Icons.restaurant_menu_rounded,
              size: size * 0.5,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
