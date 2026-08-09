import 'package:flutter_test/flutter_test.dart';
import 'package:city_bites/main.dart';

void main() {
  testWidgets('City Bites smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CityBitesApp());
    expect(find.byType(CityBitesApp), findsOneWidget);
  });
}