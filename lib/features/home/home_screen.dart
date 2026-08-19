import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../ui/tokens/spacing.dart';

/// Empty placeholder — Home lands in Phase 6. See
/// docs/phases/phase-0-foundation.md Batch 0.7.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navHome)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pageMargin),
          child: Text(l10n.placeholderScreenBody(l10n.navHome)),
        ),
      ),
    );
  }
}
