import 'package:flutter_test/flutter_test.dart';

import 'package:hifz/main.dart';
import 'package:hifz/ui/theme/theme_preview_screen.dart';

void main() {
  testWidgets('MyApp renders the theme preview screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(ThemePreviewScreen), findsOneWidget);
    expect(find.text('Theme preview'), findsOneWidget);
  });

  testWidgets('all three theme tabs are present', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('light'), findsOneWidget);
    expect(find.text('dark'), findsOneWidget);
    expect(find.text('sepia'), findsOneWidget);
  });
}
