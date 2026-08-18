import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hifz/features/settings/about_screen.dart';

void main() {
  testWidgets('shows the bundled attribution text once loaded', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: AboutScreen())),
    );

    // First frame: the asset load is still pending.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.textContaining('Attribution'), findsWidgets);
    expect(find.text('About'), findsOneWidget);
  });
}
