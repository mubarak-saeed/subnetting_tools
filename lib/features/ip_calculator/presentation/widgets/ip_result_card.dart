import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/ip_address.dart';

class IpResultCard extends StatelessWidget {
  final IpAddress ipAddress;

  const IpResultCard({super.key, required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'IP Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            _buildInfoRow('IP Address:', ipAddress.address),
            _buildInfoRow('Network Class:', ipAddress.networkClass),
            _buildInfoRow('Network Address:', ipAddress.networkAddress),
            _buildInfoRow('Broadcast Address:', ipAddress.broadcastAddress),
            _buildInfoRow(
                'Total Usable Hosts:', ipAddress.totalHosts.toString()),
            _buildInfoRow('Binary:', ipAddress.binaryAddress),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy all',
                  onPressed: () {
                    final data = '''
IP Address: ${ipAddress.address}
Network Class: ${ipAddress.networkClass}
Network Address: ${ipAddress.networkAddress}
Broadcast Address: ${ipAddress.broadcastAddress}
First Usable IP: ${ipAddress.totalHosts > 0 ? _firstUsableIp(ipAddress.networkAddress) : 'N/A'}
Last Usable IP: ${ipAddress.totalHosts > 0 ? _lastUsableIp(ipAddress.broadcastAddress) : 'N/A'}
Total Usable Hosts: ${ipAddress.totalHosts}
Binary: ${ipAddress.binaryAddress}
''';
                    Clipboard.setData(ClipboardData(text: data));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard!')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _firstUsableIp(String networkAddress) {
    final parts = networkAddress.split('.').map(int.parse).toList();
    parts[3] += 1;
    return parts.join('.');
  }

  String _lastUsableIp(String broadcastAddress) {
    final parts = broadcastAddress.split('.').map(int.parse).toList();
    parts[3] -= 1;
    return parts.join('.');
  }
}
