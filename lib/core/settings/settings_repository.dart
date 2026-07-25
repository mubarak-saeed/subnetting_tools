import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsRepository {
  static const String boxName = 'settingsBox';
  static const String keyThemeMode = 'themeMode';
  static const String keyLanguageCode = 'languageCode';

  static Future<ThemeMode> getThemeMode() async {
    final box = await Hive.openBox(boxName);
    final val = box.get(keyThemeMode, defaultValue: 'system') as String;
    if (val == 'light') return ThemeMode.light;
    if (val == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final box = await Hive.openBox(boxName);
    String val = 'system';
    if (mode == ThemeMode.light) val = 'light';
    if (mode == ThemeMode.dark) val = 'dark';
    await box.put(keyThemeMode, val);
  }

  static Future<Locale> getLocale() async {
    final box = await Hive.openBox(boxName);
    final val = box.get(keyLanguageCode, defaultValue: 'ar') as String;
    return Locale(val);
  }

  static Future<void> saveLocale(Locale locale) async {
    final box = await Hive.openBox(boxName);
    await box.put(keyLanguageCode, locale.languageCode);
  }
}
