import 'package:flutter/material.dart';
import '../../domain/entities/ip_address.dart';

class SubnetResultCard extends StatelessWidget {
  final IpAddress ipAddress;

  const SubnetResultCard({super.key, required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subnet Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            Text(
              'Subnet Mask: /${ipAddress.subnetMask}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Available Subnets:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ipAddress.subnetAddresses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(ipAddress.subnetAddresses[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
