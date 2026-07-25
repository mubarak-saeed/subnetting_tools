import 'package:flutter/material.dart';
import '../../logic/range_calculator_logic.dart';

class RangeCalculatorPage extends StatefulWidget {
  const RangeCalculatorPage({super.key});

  @override
  State<RangeCalculatorPage> createState() => _RangeCalculatorPageState();
}

class _RangeCalculatorPageState extends State<RangeCalculatorPage> {
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  List<String> _range = [];
  String? _error;

  void _calculate() {
    setState(() {
      _error = null;
      _range = calculateIpRange(
          _startController.text.trim(), _endController.text.trim());
      if (_range.isEmpty) {
        _error = 'Invalid input or range too large.';
      }
    });
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Range Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _startController,
              decoration: const InputDecoration(
                labelText: 'Start IP',
                hintText: '192.168.1.1',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _endController,
              decoration: const InputDecoration(
                labelText: 'End IP',
                hintText: '192.168.1.100',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _calculate,
              icon: const Icon(Icons.linear_scale),
              label: const Text('Calculate Range'),
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
            if (_range.isNotEmpty && _error == null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('IP Range:'),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: _range.length,
                          itemBuilder: (context, i) => Text(_range[i]),
                        ),
                      ),
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
