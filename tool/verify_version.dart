// Asserts that the git tag and the pubspec.yaml version agree.
//
// The release workflow runs this first, so a tag can never disagree with the
// version it claims to release. See docs/04-workflow.md.
//
//   dart run tool/verify_version.dart              # infer tag from git
//   dart run tool/verify_version.dart --tag v0.2.0
//
// Exits 0 on agreement, 1 on mismatch or malformed input.

import 'dart:io';

void main(List<String> args) {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    _fail('pubspec.yaml not found. Run from the repository root.');
  }

  final version = _readPubspecVersion(pubspec.readAsStringSync());
  if (version == null) {
    _fail('No `version:` line found in pubspec.yaml.');
  }

  final tag = _tagFrom(args) ?? _tagFromGit();
  if (tag == null) {
    stdout.writeln(
      'No tag supplied and none found at HEAD. '
      'pubspec.yaml version is $version. Nothing to compare.',
    );
    exit(0);
  }

  final tagVersion = tag.startsWith('v') ? tag.substring(1) : tag;
  final pubspecVersion = version.split('+').first;

  if (tagVersion != pubspecVersion) {
    _fail(
      'Version mismatch.\n'
      '  git tag        : $tag  (parsed as $tagVersion)\n'
      '  pubspec.yaml   : $version  (parsed as $pubspecVersion)\n\n'
      'Bump pubspec.yaml before tagging, or retag. See docs/04-workflow.md.',
    );
  }

  final build = version.contains('+') ? version.split('+').last : '(none)';
  stdout.writeln('Version OK: $tag matches pubspec.yaml $version');
  stdout.writeln('Build number: $build');
}

String? _readPubspecVersion(String contents) {
  for (final line in contents.split('\n')) {
    final match = RegExp(r'^version:\s*(\S+)').firstMatch(line);
    if (match != null) return match.group(1);
  }
  return null;
}

String? _tagFrom(List<String> args) {
  final i = args.indexOf('--tag');
  if (i != -1 && i + 1 < args.length) return args[i + 1];
  // CI supplies the tag as the ref name.
  final ref = Platform.environment['GITHUB_REF_NAME'];
  if (ref != null && ref.startsWith('v')) return ref;
  return null;
}

String? _tagFromGit() {
  try {
    final result = Process.runSync('git', [
      'describe',
      '--exact-match',
      '--tags',
    ]);
    if (result.exitCode != 0) return null;
    final tag = (result.stdout as String).trim();
    return tag.isEmpty ? null : tag;
  } on ProcessException {
    return null;
  }
}

Never _fail(String message) {
  stderr.writeln('verify_version: $message');
  exit(1);
}
