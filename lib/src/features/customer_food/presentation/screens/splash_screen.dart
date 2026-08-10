import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/widgets/app_logo.dart';
import '../bloc/splash_cubit.dart';

class CustomerSplashScreen extends StatefulWidget {
  final VoidCallback onSplashComplete;

  const CustomerSplashScreen({
    super.key,
    required this.onSplashComplete,
  });

  @override
  State<CustomerSplashScreen> createState() => _CustomerSplashScreenState();
}

class _CustomerSplashScreenState extends State<CustomerSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isPrecached = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    context.read<SplashCubit>().checkAuthStatusAndConfig();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isPrecached) {
      precacheImage(const AssetImage(AssetPaths.logoAssetLarge), context);
      _isPrecached = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is Unauthenticated ||
            state is AuthenticatedCustomer ||
            state is AuthenticatedOwner ||
            state is AuthenticatedAdmin) {
          widget.onSplashComplete();
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withAlpha(isDark ? 160 : 210),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Centered Premium Logo Card with contrast background
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withAlpha(80),
                            blurRadius: 32,
                            spreadRadius: 4,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: AppLogo(
                        size: 220,
                        borderRadius: 36,
                        showShadow: false,
                        showBorder: true,
                        isOriginal: true,
                        backgroundColor: theme.colorScheme.surface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                // App Title
                Text(
                  AppConstants.appName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                    fontSize: 34,
                  ),
                ),
                const SizedBox(height: 10),
                // Tagline Pill Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withAlpha(60),
                    ),
                  ),
                  child: Text(
                    AppConstants.appTagline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                // Location Footer Badge & Spinner
                Column(
                  children: [
                    Text(
                      'Sahiwal Food Delivery Portal',
                      style: TextStyle(
                        color: Colors.white.withAlpha(200),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
