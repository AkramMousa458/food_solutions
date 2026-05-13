import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A simple translation system that replaces flutter_translate.
/// Loads JSON translation files directly from assets without using AssetManifest.json.
class AppTranslations {
  static final AppTranslations _instance = AppTranslations._();
  factory AppTranslations() => _instance;
  AppTranslations._();

  Locale _currentLocale = const Locale('en');
  Map<String, dynamic> _translations = {};
  final Map<String, Map<String, dynamic>> _cache = {};

  String _basePath = 'assets/i18n';
  String _fallbackLocale = 'en';
  List<String> _supportedLocales = ['en'];

  Locale get currentLocale => _currentLocale;
  List<String> get supportedLocales => _supportedLocales;

  /// Initialize the translation system
  static Future<AppTranslations> init({
    required String fallbackLocale,
    required List<String> supportedLocales,
    String basePath = 'assets/i18n',
  }) async {
    final instance = AppTranslations();
    instance._basePath = basePath;
    instance._fallbackLocale = fallbackLocale;
    instance._supportedLocales = supportedLocales;
    instance._currentLocale = Locale(fallbackLocale);

    // Pre-load all locale files
    for (final locale in supportedLocales) {
      await instance._loadLocale(locale);
    }

    // Set fallback as current
    instance._translations = instance._cache[fallbackLocale] ?? {};

    return instance;
  }

  /// Load a locale's JSON file
  Future<void> _loadLocale(String localeCode) async {
    if (_cache.containsKey(localeCode)) return;

    try {
      final jsonString = await rootBundle.loadString(
        '$_basePath/$localeCode.json',
      );
      _cache[localeCode] = json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Failed to load locale "$localeCode": $e');
      _cache[localeCode] = {};
    }
  }

  /// Change the current locale
  Future<void> setLocale(Locale locale) async {
    final code = locale.languageCode;
    await _loadLocale(code);
    _currentLocale = locale;
    _translations = _cache[code] ?? _cache[_fallbackLocale] ?? {};
  }

  /// Translate a key to the current locale
  String translate(String key) {
    return _translations[key]?.toString() ?? key;
  }
}

// ─── Global translate function (drop-in replacement for flutter_translate) ───
String translate(String key) {
  return AppTranslations().translate(key);
}

// ─── LocalizedApp widget (drop-in replacement for flutter_translate) ─────────
class LocalizedApp extends StatefulWidget {
  final AppTranslations translations;
  final Widget child;

  const LocalizedApp(this.translations, this.child, {super.key});

  static LocalizedAppState of(BuildContext context) {
    return context.findAncestorStateOfType<LocalizedAppState>()!;
  }

  @override
  State<LocalizedApp> createState() => LocalizedAppState();
}

class LocalizedAppState extends State<LocalizedApp> {
  AppTranslations get translations => widget.translations;

  AppTranslationsDelegate get delegate =>
      AppTranslationsDelegate(widget.translations);

  /// Change the app locale and rebuild
  Future<void> changeLocale(Locale locale) async {
    await widget.translations.setLocale(locale);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// ─── LocalizationsDelegate (drop-in replacement) ────────────────────────────
class AppTranslationsDelegate extends LocalizationsDelegate<AppTranslations> {
  final AppTranslations translations;

  AppTranslationsDelegate(this.translations);

  Locale get currentLocale => translations.currentLocale;

  @override
  bool isSupported(Locale locale) {
    return translations.supportedLocales.contains(locale.languageCode);
  }

  @override
  Future<AppTranslations> load(Locale locale) async {
    await translations.setLocale(locale);
    return translations;
  }

  @override
  bool shouldReload(AppTranslationsDelegate old) => true;
}
