import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../../../../core/widgets/role_toggle_button.dart';
import '../bloc/auth_cubit.dart';

import '../widgets/auth_header_widget.dart';
import '../widgets/auth_quick_login_section.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onAuthSuccess;

  const AuthScreen({
    super.key,
    required this.onAuthSuccess,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveWrapper(
          maxWidth: 520,
          padding: EdgeInsets.zero,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    widget.onAuthSuccess();
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: theme.colorScheme.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final selectedRole = state.selectedRole;
                  final isLoading = state is AuthLoading;

                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AuthHeaderWidget(),
                        const SizedBox(height: 24),

                        // Segmented Role Toggle Control
                        RoleToggleButton(
                          selectedRole: selectedRole,
                          onRoleChanged: (role) {
                            context.read<AuthCubit>().roleToggled(role);
                          },
                        ),
                        const SizedBox(height: 28),

                        // Form Inputs
                        CustomTextField(
                          controller: _emailController,
                          labelText: selectedRole == UserRole.customer
                              ? 'Email or Mobile Number'
                              : selectedRole == UserRole.owner
                                  ? 'Restaurant Email'
                                  : 'Admin Credentials',
                          hintText: selectedRole == UserRole.customer
                              ? 'e.g. 03001234567 or user@sahiwal.com'
                              : 'admin@citybites.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter your email or phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          hintText: '••••••••',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          validator: (val) {
                            if (val == null || val.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Primary Submit Button
                        CustomButton(
                          text: selectedRole == UserRole.admin
                              ? 'Access Master Console'
                              : selectedRole == UserRole.owner
                                  ? 'Login to Restaurant Dashboard'
                                  : 'Login',
                          isLoading: isLoading,
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<AuthCubit>().loginSubmitted(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  );
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        if (selectedRole == UserRole.customer) ...[
                          const AuthQuickLoginSection(),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
