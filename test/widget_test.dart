import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vital/main.dart';

void main() {
  testWidgets('VitalApp shows Progress screen by default', (WidgetTester tester) async {
    await tester.pumpWidget(const VitalApp());
    await tester.pumpAndSettle();

    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Workout'), findsOneWidget);
    expect(find.text('Nutrition'), findsOneWidget);
  });
}
