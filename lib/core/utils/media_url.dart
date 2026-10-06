import 'package:food_solutions/core/utils/app_string.dart';

String resolveMediaUrl(String url) {
  final trimmedUrl = url.trim();
  if (trimmedUrl.isEmpty || trimmedUrl == '-') return trimmedUrl;
  if (trimmedUrl.startsWith('https://')) return trimmedUrl;
  if (trimmedUrl.startsWith('http://')) {
    return 'https://${trimmedUrl.substring('http://'.length)}';
  }
  if (trimmedUrl.startsWith('//')) return 'https:$trimmedUrl';
  final normalizedBase = AppString.baseUrl.endsWith('/')
      ? AppString.baseUrl
      : '${AppString.baseUrl}/';
  final path = trimmedUrl.startsWith('/')
      ? trimmedUrl.substring(1)
      : trimmedUrl;
  return '$normalizedBase$path';
}
