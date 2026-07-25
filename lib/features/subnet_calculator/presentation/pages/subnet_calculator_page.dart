import 'package:flutter/material.dart';
import '../../logic/subnet_calculator_logic.dart';

class SubnetCalculatorPage extends StatefulWidget {
  const SubnetCalculatorPage({super.key});

  @override
  State<SubnetCalculatorPage> createState() => _SubnetCalculatorPageState();
}

class _SubnetCalculatorPageState extends State<SubnetCalculatorPage> {
  final _ipController = TextEditingController();
  int _subnetMask = 24;
  int _numberOfSubnets = 2;
  List<SubnetInfo> _subnets = [];
  String? _error;

  void _calculate() {
    setState(() {
      _error = null;
      try {
        _subnets =
            calculateSubnets(_ipController.text, _subnetMask, _numberOfSubnets);
        if (_subnets.isEmpty) {
          _error = 'No subnets calculated. Please check your input.';
        }
      } catch (e) {
        _error = 'Invalid input or calculation error.';
      }
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subnet Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'Base IP Address',
                hintText: '192.168.1.0',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Subnet Mask: '),
                Expanded(
                  child: Slider(
                    value: _subnetMask.toDouble(),
                    min: 0,
                    max: 32,
                    divisions: 32,
                    label: '/$_subnetMask',
                    onChanged: (value) {
                      setState(() {
                        _subnetMask = value.toInt();
                      });
                    },
                  ),
                ),
                Text('/$_subnetMask'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Number of Subnets: '),
                Expanded(
                  child: Slider(
                    value: _numberOfSubnets.toDouble(),
                    min: 2,
                    max: 32,
                    divisions: 30,
                    label: '$_numberOfSubnets',
                    onChanged: (value) {
                      setState(() {
                        _numberOfSubnets = value.toInt();
                      });
                    },
                  ),
                ),
                Text('$_numberOfSubnets'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _calculate,
              icon: const Icon(Icons.calculate),
              label: const Text('Calculate Subnets'),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Card(
                color: Theme.of(context).colorScheme.error,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_error!,
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            if (_subnets.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Subnets:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _subnets.length,
                    itemBuilder: (context, index) {
                      final subnet = _subnets[index];
                      return Card(
                        child: ListTile(
                          title: Text('Subnet ${index + 1}'),
                          subtitle: Text(
                              'Network: ${subnet.networkAddress}\nBroadcast: ${subnet.broadcastAddress}\nFirst: ${subnet.firstUsableIp}\nLast: ${subnet.lastUsableIp}\nHosts: ${subnet.totalHosts}'),
                        ),
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
}
