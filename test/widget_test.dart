import 'package:flutter_test/flutter_test.dart';
import 'package:city_bites/main.dart';

void main() {
  testWidgets('Sahiwal Food Express smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SahiwalFoodExpressApp());
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(SahiwalFoodExpressApp), findsOneWidget);
  });
}