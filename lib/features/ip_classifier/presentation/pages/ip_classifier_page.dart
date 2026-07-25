import 'package:flutter/material.dart';
import '../../logic/ip_classifier_logic.dart';

class IpClassifierPage extends StatefulWidget {
  const IpClassifierPage({super.key});

  @override
  State<IpClassifierPage> createState() => _IpClassifierPageState();
}

class _IpClassifierPageState extends State<IpClassifierPage> {
  final _controller = TextEditingController();
  IpClassResult? _result;
  String? _error;

  void _classify() {
    setState(() {
      _error = null;
      final input = _controller.text.trim();
      final res = classifyIp(input);
      if (res.ipClass == 'Invalid') {
        _error = 'Invalid IP address!';
        _result = null;
      } else {
        _result = res;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IP Classifier')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter IP Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _classify,
              icon: const Icon(Icons.category),
              label: const Text('Classify'),
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
            if (_result != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Class: ${_result!.ipClass}'),
                      Text(
                          'Type: ${_result!.isPrivate ? 'Private' : 'Public'}'),
                      Text('Description: ${_result!.description}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
