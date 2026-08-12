import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = 900.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure the wrapper occupies the full available width so
    // inner scrollable content doesn't shrink to its intrinsic width
    // when there's little content. Center the constrained column
    // at the top of the available space.
    return Container(
      width: double.infinity,
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? ResponsiveHelper.pagePadding(context),
          child: child,
        ),
      ),
    );
  }
}
