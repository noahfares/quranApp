import 'package:flutter/material.dart';

import 'ui/theme/app_theme.dart';
import 'ui/theme/theme_preview_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Temporary entry point. Batch 0.7 replaces this with app/app.dart,
/// app/router.dart, and app/bootstrap.dart. Until then, this shows the
/// debug-only theme preview screen so Batch 0.3's design tokens are
/// reachable and reviewable — see docs/phases/phase-0-foundation.md.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hifz',
      theme: AppTheme.light,
      home: const ThemePreviewScreen(),
    );
  }
}
