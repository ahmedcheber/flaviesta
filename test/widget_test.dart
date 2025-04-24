import 'package:flaviesta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Flaviesta splash screen test', (WidgetTester tester) async {
    await tester.pumpWidget(const FlaviestaApp());

    expect(find.text('Flaviesta'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
