import 'package:flutter_test/flutter_test.dart';
import 'package:hifz/data/platform/paths.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform {
  @override
  Future<String?> getApplicationSupportPath() async => '/fake/support';

  @override
  Future<String?> getApplicationCachePath() async => '/fake/cache';
}

void main() {
  setUp(() {
    PathProviderPlatform.instance = _FakePathProvider();
  });

  test(
    'appDatabaseFile() resolves to app.db in the support directory',
    () async {
      final file = await AppPaths.appDatabaseFile();
      expect(file.path, '/fake/support/app.db');
    },
  );

  test(
    'quranDatabaseFile() resolves to quran.db in the support directory',
    () async {
      final file = await AppPaths.quranDatabaseFile();
      expect(file.path, '/fake/support/quran.db');
    },
  );

  test('downloadCacheDirectory() resolves to the cache directory', () async {
    final dir = await AppPaths.downloadCacheDirectory();
    expect(dir.path, '/fake/cache');
  });
}
