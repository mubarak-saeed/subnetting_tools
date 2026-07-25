import 'dart:convert';
import 'package:flutter/services.dart';
import '../network/cisco_network_engine.dart';

class ExportHelper {
  /// Exports calculation list or data to formatted CSV string
  static String toCsv(List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) return '';
    final keys = rows.first.keys.toList();
    final header = keys.join(',');
    final body = rows.map((row) {
      return keys.map((k) => '"${row[k].toString().replaceAll('"', '""')}"').join(',');
    }).join('\n');

    return '$header\n$body';
  }

  /// Exports VLSM allocation list to JSON string
  static String vlsmToJson(List<VlsmAllocation> allocations) {
    final listMap = allocations.map((a) => {
      'name': a.name,
      'requestedHosts': a.requestedHosts,
      'allocatedHosts': a.allocatedHosts,
      'cidr': a.cidr,
      'netmask': a.netmask,
      'wildcardMask': a.wildcardMask,
      'networkAddress': a.networkAddress,
      'broadcastAddress': a.broadcastAddress,
      'firstUsableIp': a.firstUsableIp,
      'lastUsableIp': a.lastUsableIp,
      'wastedHosts': a.wastedHosts,
    }).toList();

    return const JsonEncoder.withIndent('  ').convert(listMap);
  }

  /// Copies any string content to system clipboard
  static Future<void> copyToClipboard(String content) async {
    await Clipboard.setData(ClipboardData(text: content));
  }
}
