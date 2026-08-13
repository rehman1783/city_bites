import 'package:city_bites/main.dart';
import 'package:city_bites/src/core/theme/theme_cubit.dart';
import 'package:city_bites/src/features/customer_user/presentation/bloc/profile_bloc.dart';
import 'package:city_bites/src/features/customer_user/presentation/screens/customer_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Sahiwal Food Express smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SahiwalFoodExpressApp());
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(SahiwalFoodExpressApp), findsOneWidget);
  });

  testWidgets('Profile shows About Us, Contact Us and Privacy & Policy links',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        ],
        child: MaterialApp(
          home: CustomerProfileScreen(
            onNavigateToOrders: () {},
            onLogout: () {},
          ),
        ),
      ),
    );

    expect(find.text('About Us'), findsOneWidget);
    expect(find.text('Contact Us'), findsOneWidget);
    expect(find.text('Privacy & Policy'), findsOneWidget);
  });
}