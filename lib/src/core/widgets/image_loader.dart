import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageLoader extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? errorWidget;

  const ImageLoader({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget fallbackError = errorWidget ??
        Container(
          width: width,
          height: height,
          color: theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.fastfood,
            color: theme.colorScheme.onSurfaceVariant,
            size: 32,
          ),
        );

    Widget loadingSpinner = Container(
      width: width,
      height: height,
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );

    Widget image;

    if (kIsWeb) {
      image = Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return loadingSpinner;
        },
        errorBuilder: (context, error, stackTrace) => fallbackError,
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => loadingSpinner,
        errorWidget: (context, url, error) => fallbackError,
      );
    }

    if (borderRadius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: image,
      );
    }

    return image;
  }
}
