// Enforces the architectural boundaries in docs/01-architecture.md §10.
//
// These rules are cheap to check now and expensive to fix later. In particular,
// rule 1 protects the pure-Dart domain layer, which is roughly 60% of the code
// and the part that must survive the UI redesign untouched.
//
//   dart run tool/verify_layering.dart
//
// Exits 0 if clean, 1 with a report of every violation found.

import 'dart:io';

void main() {
  final lib = Directory('lib');
  if (!lib.existsSync()) {
    stdout.writeln(
      'verify_layering: no lib/ directory yet — nothing to check.',
    );
    exit(0);
  }

  final violations = <_Violation>[];

  for (final file
      in lib
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .where((f) => !_isGenerated(f.path))) {
    final path = file.path.replaceAll(r'\', '/');
    final lines = file.readAsLinesSync();

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (_isComment(line)) continue;
      violations.addAll(_check(path, line, i + 1));
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('verify_layering: clean.');
    exit(0);
  }

  stderr.writeln('verify_layering: ${violations.length} violation(s)\n');
  for (final v in violations) {
    stderr.writeln('  ${v.path}:${v.line}');
    stderr.writeln('    rule ${v.rule}: ${v.message}');
    stderr.writeln('    > ${v.source.trim()}\n');
  }
  exit(1);
}

Iterable<_Violation> _check(String path, String line, int lineNo) sync* {
  // Rule 1 — domain/ and core/ are pure Dart.
  if ((path.contains('/domain/') || path.contains('/core/')) &&
      RegExp(r'''import\s+['"]package:flutter/''').hasMatch(line)) {
    yield _Violation(
      path,
      lineNo,
      line,
      1,
      'domain/ and core/ must not import Flutter. Keep them pure Dart.',
    );
  }

  // Rule 2 — ui/ is a design system, not an application layer.
  if (path.contains('/ui/') &&
      RegExp(r'''import\s+['"].*(/data/|/features/)''').hasMatch(line)) {
    yield _Violation(
      path,
      lineNo,
      line,
      2,
      'ui/ must not import data/ or features/. It is presentation only.',
    );
  }

  // Rule 3 — features are siblings, never dependencies of each other.
  // Cross-feature imports are usually written relatively ('../reader/x.dart'),
  // so the import must be resolved against the importing file before the
  // feature name can be read off it.
  final feature = RegExp(r'/features/([^/]+)/').firstMatch(path)?.group(1);
  if (feature != null) {
    final uri = RegExp(
      '''import\\s+['"]([^'"]+)['"]''',
    ).firstMatch(line)?.group(1);
    if (uri != null) {
      final resolved = _resolveImport(path, uri);
      final imported = RegExp(
        r'/features/([^/]+)/',
      ).firstMatch(resolved ?? '')?.group(1);
      if (imported != null && imported != feature) {
        yield _Violation(
          path,
          lineNo,
          line,
          3,
          "feature '$feature' must not import feature '$imported'. "
          'Share through domain/ or ui/ instead.',
        );
      }
    }
  }

  // Rule 4 — no hardcoded design values where tokens belong.
  if (path.contains('/features/') || path.contains('/ui/widgets/')) {
    if (RegExp(r'\bColor\(0x').hasMatch(line) ||
        RegExp(r'\bColors\.').hasMatch(line)) {
      yield _Violation(
        path,
        lineNo,
        line,
        4,
        'Hardcoded colour. Use a design token or Theme.of(context).',
      );
    }
    if (RegExp(r'\bEdgeInsets\.\w+\(\s*[\d.]').hasMatch(line) ||
        RegExp(r'\bSizedBox\(\s*(width|height):\s*[\d.]').hasMatch(line)) {
      yield _Violation(
        path,
        lineNo,
        line,
        4,
        'Hardcoded spacing. Use AppSpacing.',
      );
    }
  }

  // Rule 5 — time must be injectable, or the scheduler is untestable.
  if (!path.endsWith('/core/clock.dart') && line.contains('DateTime.now()')) {
    yield _Violation(
      path,
      lineNo,
      line,
      5,
      'Use the injected Clock, never DateTime.now(). See architecture §6.',
    );
  }
}

/// Resolves an import URI to a repo-relative path, or null if it is external.
/// Handles both `package:<app>/…` and relative forms.
String? _resolveImport(String fromPath, String uri) {
  if (uri.startsWith('dart:')) return null;
  if (uri.startsWith('package:')) {
    // package:my_app/features/reader/x.dart -> lib/features/reader/x.dart
    final slash = uri.indexOf('/');
    return slash == -1 ? null : 'lib/${uri.substring(slash + 1)}';
  }

  final base = fromPath.substring(0, fromPath.lastIndexOf('/'));
  final segments = <String>[...base.split('/'), ...uri.split('/')];
  final out = <String>[];
  for (final segment in segments) {
    if (segment == '.' || segment.isEmpty) continue;
    if (segment == '..') {
      if (out.isNotEmpty) out.removeLast();
      continue;
    }
    out.add(segment);
  }
  return out.join('/');
}

bool _isGenerated(String path) =>
    path.endsWith('.g.dart') ||
    path.endsWith('.freezed.dart') ||
    path.endsWith('.gr.dart') ||
    path.contains('generated');

bool _isComment(String line) {
  final t = line.trimLeft();
  return t.startsWith('//') || t.startsWith('*') || t.startsWith('/*');
}

class _Violation {
  const _Violation(this.path, this.line, this.source, this.rule, this.message);
  final String path;
  final int line;
  final String source;
  final int rule;
  final String message;
}
