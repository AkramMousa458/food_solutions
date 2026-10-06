import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/utils/media_url.dart';

void main() {
  test('upgrades cleartext media urls to https', () {
    const inputUrl =
        'http://foodsolutions.site/storage/images/icons/2a4339c8-3431-440b-9d1b-b272a7201dc8.png';
    const expectedUrl =
        'https://foodsolutions.site/storage/images/icons/2a4339c8-3431-440b-9d1b-b272a7201dc8.png';
    final actualUrl = resolveMediaUrl(inputUrl);
    expect(actualUrl, expectedUrl);
  });

  test('keeps https urls unchanged', () {
    const inputUrl =
        'https://foodsolutions.site/storage/icons/services/icon.png';
    final actualUrl = resolveMediaUrl(inputUrl);
    expect(actualUrl, inputUrl);
  });

  test('prefixes relative paths with the api base url', () {
    const inputUrl = '/storage/images/icons/icon.png';
    const expectedUrl =
        'https://foodsolutions.site/storage/images/icons/icon.png';
    final actualUrl = resolveMediaUrl(inputUrl);
    expect(actualUrl, expectedUrl);
  });

  test('returns empty and placeholder values unchanged', () {
    expect(resolveMediaUrl(''), '');
    expect(resolveMediaUrl('-'), '-');
    expect(resolveMediaUrl('   '), '');
  });
}
