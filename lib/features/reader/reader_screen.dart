import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../ui/tokens/spacing.dart';

/// Empty placeholder — the mushaf reader lands in Phase 1. See
/// docs/phases/phase-0-foundation.md Batch 0.7.
class ReaderScreen extends StatelessWidget {
  const ReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navReader)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pageMargin),
          child: Text(l10n.placeholderScreenBody(l10n.navReader)),
        ),
      ),
    );
  }
}
