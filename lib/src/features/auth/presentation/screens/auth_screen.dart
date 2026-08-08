import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../bloc/auth_cubit.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(text: 'customer@sahiwal.pk');
  final _passwordController = TextEditingController(text: '12345678');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(AuthState state) {
    if (_formKey.currentState?.validate() ?? false) {
      if (state.mode == AuthMode.login) {
        context.read<AuthCubit>().login(
              email: _emailController.text,
              password: _passwordController.text,
            );
      } else {
        context.read<AuthCubit>().signup(
              name: _nameController.text.isNotEmpty ? _nameController.text : 'Sahiwal User',
              email: _emailController.text,
              password: _passwordController.text,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          if (state.role == UserRole.customer) {
            Navigator.of(context).pushReplacementNamed('/main');
          } else {
            Navigator.of(context).pushReplacementNamed('/owner_dashboard');
          }
        }
      },
      builder: (context, state) {
        final isLogin = state.mode == AuthMode.login;
        final isCustomer = state.role == UserRole.customer;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Header Logo & Title
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha(20),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delivery_dining_rounded,
                              size: 44,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            AppConstants.appName,
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Sahiwal Food Portal',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Role Selector Segmented Switcher
                    CustomCard(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                context.read<AuthCubit>().setRole(UserRole.customer);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isCustomer
                                      ? theme.colorScheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      size: 18,
                                      color: isCustomer
                                          ? Colors.white
                                          : theme.colorScheme.onSurface,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Customer',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isCustomer
                                            ? Colors.white
                                            : theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                context.read<AuthCubit>().setRole(UserRole.restaurantOwner);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !isCustomer
                                      ? theme.colorScheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.storefront_outlined,
                                      size: 18,
                                      color: !isCustomer
                                          ? Colors.white
                                          : theme.colorScheme.onSurface,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Restaurant Owner',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: !isCustomer
                                            ? Colors.white
                                            : theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section Title
                    Text(
                      isLogin
                          ? 'Welcome Back!'
                          : (isCustomer ? 'Create Foodie Account' : 'Register Restaurant'),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isLogin
                          ? 'Sign in to access delicious meals in Sahiwal'
                          : 'Join City Bites and get started',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),

                    // Input Form Fields
                    if (!isLogin) ...[
                      CustomTextField(
                        controller: _nameController,
                        labelText: isCustomer ? 'Full Name' : 'Restaurant Name',
                        hintText: isCustomer ? 'Ali Raza' : 'Royal Taj Restaurant',
                        prefixIcon: isCustomer ? Icons.person : Icons.store,
                      ),
                      const SizedBox(height: 16),
                    ],

                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email or Mobile Number',
                      hintText: '03001234567 or email@sahiwal.pk',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Please enter contact info' : null,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      validator: (val) =>
                          val == null || val.length < 6 ? 'Minimum 6 characters' : null,
                    ),

                    if (isLogin) ...[
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password reset link sent to your email!'),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Submit Button
                    CustomButton(
                      text: isLogin ? 'Sign In' : 'Create Account',
                      isLoading: state.isLoading,
                      onPressed: () => _submit(state),
                    ),
                    const SizedBox(height: 24),

                    // Divider Social Login
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            'OR CONTINUE WITH',
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Social Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _submit(state),
                            icon: const Icon(Icons.g_mobiledata, size: 28),
                            label: const Text('Google'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _submit(state),
                            icon: const Icon(Icons.facebook, size: 22),
                            label: const Text('Facebook'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Mode Switch Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLogin
                              ? "Don't have an account? "
                              : "Already have an account? ",
                          style: theme.textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<AuthCubit>().setMode(
                                  isLogin ? AuthMode.signup : AuthMode.login,
                                );
                          },
                          child: Text(
                            isLogin ? 'Sign Up' : 'Sign In',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
