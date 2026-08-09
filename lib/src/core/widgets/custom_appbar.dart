import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? titleWidget;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.showBackButton = true,
    this.onBackPressed,
    this.onBack,
    this.actions,
    this.titleWidget,
    this.backgroundColor,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backCallback = onBack ?? onBackPressed;

    return AppBar(
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              onPressed: () {
                if (backCallback != null) {
                  backCallback();
                } else if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  // Fallback: If canPop is false and no callback was passed, navigate back to main route
                  Navigator.of(context).maybePop();
                }
              },
            )
          : null,
      title: titleWidget ??
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
