import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? titleWidget;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.titleWidget,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
