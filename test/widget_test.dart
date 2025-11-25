import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vital/main.dart';

void main() {
  testWidgets('VitalApp shows Progress screen by default', (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(const VitalApp());

    // Allow animations to finish.
    await tester.pumpAndSettle();

    // Validate by checking an element unique to Progress screen.
    expect(find.text('Welcome back, Alex'), findsOneWidget);
  });
}
