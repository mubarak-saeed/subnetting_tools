import 'dart:convert';
import 'package:hive/hive.dart';
import 'history_storage.dart';

class FavoritesStorage {
  static const String boxName = 'favoritesBox';

  static Future<void> toggleFavorite(HistoryEntry entry) async {
    final box = await Hive.openBox<String>(boxName);
    final key = '${entry.title}_${entry.featureType}';
    if (box.containsKey(key)) {
      await box.delete(key);
    } else {
      await box.put(key, jsonEncode(entry.toJson()));
    }
  }

  static Future<bool> isFavorite(String title, String featureType) async {
    final box = await Hive.openBox<String>(boxName);
    final key = '${title}_$featureType';
    return box.containsKey(key);
  }

  static Future<List<HistoryEntry>> getFavorites() async {
    final box = await Hive.openBox<String>(boxName);
    final list = <HistoryEntry>[];
    for (final val in box.values) {
      try {
        list.add(HistoryEntry.fromJson(jsonDecode(val)));
      } catch (_) {}
    }
    return list.reversed.toList();
  }
}
