import 'package:flutter_test/flutter_test.dart';
import 'package:city_bites/main.dart';

void main() {
  testWidgets('Sahiwal Food Express smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SahiwalFoodExpressApp());
    expect(find.byType(SahiwalFoodExpressApp), findsOneWidget);
  });
}