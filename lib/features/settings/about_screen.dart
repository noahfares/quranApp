import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'about_controller.dart';
import '../../ui/tokens/spacing.dart';

/// `SET-08` — About screen. Renders assets/ATTRIBUTION.md so every source's
/// licence status and required notice is visible in-app, not buried in a
/// repo file. This is a licence obligation — see docs/02-data-sources.md §9.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribution = ref.watch(aboutAttributionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: attribution.when(
        data: (text) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pageMargin),
          child: SelectableText(text),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Could not load attribution: $error')),
      ),
    );
  }
}
