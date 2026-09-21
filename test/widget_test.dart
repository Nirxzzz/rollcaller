// Basic smoke test: app builds and shows MaterialApp after splash.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rollcaller/main.dart' show MyApp;

void main() {
  testWidgets('app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Skip the splash delay (1s Future.delayed in _getThemeInfo).
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
