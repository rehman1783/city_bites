import 'package:flutter/material.dart';

/// Shows a compact, professional snackbar for success or error states.
///
/// - `isError == true` shows a red error style.
/// - otherwise shows a green success style.
void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final theme = Theme.of(context);

  final bg = isError
      ? theme.colorScheme.error
      : const Color(0xFF2E7D32); // Green 700 - success

  final icon = isError ? Icons.error_outline : Icons.check_circle_outline;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: bg,
      duration: const Duration(seconds: 1),
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
// import 'package:flutter/material.dart';

// void showAppSnackBar(
//   BuildContext context,
//   String message, {
//   bool isError = false,
// }) {
//   final theme = Theme.of(context);
//   final bg = isError ? theme.colorScheme.error : theme.colorScheme.primary;
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(message),
//       duration: const Duration(seconds: 1),
//       backgroundColor: bg,
//       behavior: SnackBarBehavior.floating,
//     ),
//   );
// }
