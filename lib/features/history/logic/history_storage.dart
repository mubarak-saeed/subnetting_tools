import 'package:hive/hive.dart';

class HistoryStorage {
  static const String boxName = 'historyBox';

  static Future<void> addHistory(String entry) async {
    final box = await Hive.openBox<String>(boxName);
    await box.add(entry);
  }

  static Future<List<String>> getHistory() async {
    final box = await Hive.openBox<String>(boxName);
    return box.values.toList().reversed.toList();
  }

  static Future<void> clearHistory() async {
    final box = await Hive.openBox<String>(boxName);
    await box.clear();
  }
}
