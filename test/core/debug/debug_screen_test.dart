import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_boilerplate/core/debug/debug_screen.dart';

void main() {
  group('DebugScreen', () {
    testWidgets('renders Debug Tools title', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DebugScreen()));
      expect(find.text('Debug Tools'), findsOneWidget);
    });

    testWidgets('renders Open HTTP Inspector button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DebugScreen()));
      expect(find.text('Open HTTP Inspector'), findsOneWidget);
    });
  });
}
