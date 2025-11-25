import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vital/main.dart';

void main() {
  testWidgets('VitalApp shows Progress screen by default', (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(const VitalApp());

    // Allow animations and initial layout to finish.
    await tester.pumpAndSettle();

    // Check for text that is unique to the Progress screen dashboard.
    expect(find.text('Welcome back, Alex'), findsOneWidget);
  });
}
