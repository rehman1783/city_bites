import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';

class AuthQuickLoginSection extends StatelessWidget {
  const AuthQuickLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: theme.dividerColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'OR Continue With',
                style: theme.textTheme.labelMedium,
              ),
            ),
            Expanded(child: Divider(color: theme.dividerColor)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AuthCubit>().loginSubmitted(
                        email: 'google_user@sahiwal.com',
                        password: 'google_auth_pass',
                      );
                },
                icon: const Icon(Icons.g_mobiledata, size: 24),
                label: const Text('Google'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AuthCubit>().loginSubmitted(
                        email: 'phone_user@sahiwal.com',
                        password: 'phone_otp_pass',
                      );
                },
                icon: const Icon(Icons.phone_iphone, size: 18),
                label: const Text('Phone OTP'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: theme.textTheme.bodyMedium,
            ),
            GestureDetector(
              onTap: () {
                context.read<AuthCubit>().loginSubmitted(
                      email: 'new_user@sahiwal.com',
                      password: 'new_password',
                    );
              },
              child: Text(
                'Sign Up',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
