import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hifz/app/app.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();
  }

  testWidgets('all four bottom nav tabs are present and navigate', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Reader'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.text('Reader').last);
    await tester.pumpAndSettle();
    expect(find.text('Reader — coming soon.'), findsOneWidget);

    await tester.tap(find.text('Progress').last);
    await tester.pumpAndSettle();
    expect(find.text('Progress — coming soon.'), findsOneWidget);

    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    expect(find.text('Theme'), findsOneWidget);
  });

  testWidgets('switching theme in Settings updates the app theme', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();

    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Sepia'), findsOneWidget);

    Color? currentBackground() => tester
        .widget<MaterialApp>(find.byType(MaterialApp))
        .theme
        ?.scaffoldBackgroundColor;

    final beforeColor = currentBackground();

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    final afterColor = currentBackground();

    expect(afterColor, isNot(beforeColor));
  });
}
