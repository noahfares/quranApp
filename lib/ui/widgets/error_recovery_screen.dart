import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../tokens/spacing.dart';

/// Shown when an uncaught error reaches the top of the widget tree. There
/// is no crash reporting service (no-telemetry rule) — this just tells the
/// user something broke and stops the app from showing a blank/garbled
/// screen. See docs/01-architecture.md §8.
class ErrorRecoveryScreen extends StatelessWidget {
  const ErrorRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pageMargin),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n?.errorRecoveryTitle ?? 'Something went wrong',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n?.errorRecoveryBody ??
                    "The app hit an unexpected error and couldn't continue. "
                        'Restarting usually fixes this.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
