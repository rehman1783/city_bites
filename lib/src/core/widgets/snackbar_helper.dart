import 'package:flutter/material.dart';

void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final theme = Theme.of(context);
  final bg = isError ? theme.colorScheme.error : theme.colorScheme.primary;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
      backgroundColor: bg,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
