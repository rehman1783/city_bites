import 'package:flutter_test/flutter_test.dart';
<<<<<<< HEAD
import 'package:city_bites/main.dart';

void main() {
  testWidgets('City Bites smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CityBitesApp());
    expect(find.byType(CityBitesApp), findsOneWidget);
=======

void main() {
  testWidgets('Basic test', (WidgetTester tester) async {
    expect(1 + 1, 2);
>>>>>>> origin/quratulain-food-project
  });
}