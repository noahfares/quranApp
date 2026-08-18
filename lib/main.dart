import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/settings/about_screen.dart';
import 'ui/theme/app_theme.dart';
import 'ui/theme/theme_preview_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/// Temporary entry point. Batch 0.7 replaces this with app/app.dart,
/// app/router.dart, and app/bootstrap.dart. Until then, this shows the
/// debug-only theme preview screen (Batch 0.3) with a way to reach the
/// About screen (`SET-08`, Batch 0.4) — see
/// docs/phases/phase-0-foundation.md.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hifz',
      theme: AppTheme.light,
      home: const _DevHome(),
    );
  }
}

class _DevHome extends StatelessWidget {
  const _DevHome();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ThemePreviewScreen(),
        Positioned(
          top: MediaQuery.paddingOf(context).top,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ),
      ],
    );
  }
}
