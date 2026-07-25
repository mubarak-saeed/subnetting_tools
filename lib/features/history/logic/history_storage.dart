import 'dart:convert';
import 'package:hive/hive.dart';

class HistoryEntry {
  final String title;
  final String details;
  final String featureType;
  final DateTime timestamp;

  HistoryEntry({
    required this.title,
    required this.details,
    required this.featureType,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'title': title,
        'details': details,
        'featureType': featureType,
        'timestamp': timestamp.toIso8601String(),
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        title: json['title'] ?? '',
        details: json['details'] ?? '',
        featureType: json['featureType'] ?? 'General',
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'])
            : DateTime.now(),
      );
}

class HistoryStorage {
  static const String boxName = 'historyBox';

  static Future<void> addHistoryEntry(HistoryEntry entry) async {
    final box = await Hive.openBox<String>(boxName);
    await box.add(jsonEncode(entry.toJson()));
  }

  static Future<List<HistoryEntry>> getHistoryEntries() async {
    final box = await Hive.openBox<String>(boxName);
    final rawValues = box.values.toList().reversed.toList();
    final entries = <HistoryEntry>[];

    for (final raw in rawValues) {
      try {
        if (raw.startsWith('{')) {
          entries.add(HistoryEntry.fromJson(jsonDecode(raw)));
        } else {
          // Legacy string format backward compatibility
          entries.add(HistoryEntry(
            title: raw.split('\n').first,
            details: raw,
            featureType: 'IP Calculator',
          ));
        }
      } catch (_) {
        // Fallback for malformed entries
      }
    }
    return entries;
  }

  static Future<void> deleteHistoryEntryAt(int reversedIndex) async {
    final box = await Hive.openBox<String>(boxName);
    final actualIndex = box.length - 1 - reversedIndex;
    if (actualIndex >= 0 && actualIndex < box.length) {
      await box.deleteAt(actualIndex);
    }
  }

  static Future<void> clearHistory() async {
    final box = await Hive.openBox<String>(boxName);
    await box.clear();
  }
}
