import 'package:flutter/material.dart';
import '../../logic/ip_converter_logic.dart';

class IpConverterPage extends StatefulWidget {
  const IpConverterPage({super.key});

  @override
  State<IpConverterPage> createState() => _IpConverterPageState();
}

class _IpConverterPageState extends State<IpConverterPage> {
  final _controller = TextEditingController();
  String _binary = '';
  String _hex = '';
  String _decimal = '';
  String? _error;
  String _mode = 'decimal';

  void _convert() {
    setState(() {
      _error = null;
      final input = _controller.text.trim();
      if (_mode == 'decimal') {
        _binary = decimalToBinary(input);
        _hex = decimalToHex(input);
        _decimal = input;
        if (_binary.isEmpty || _hex.isEmpty) _error = 'Invalid decimal IP!';
      } else if (_mode == 'binary') {
        _decimal = binaryToDecimal(input);
        _hex = decimalToHex(_decimal);
        _binary = input;
        if (_decimal.isEmpty || _hex.isEmpty) _error = 'Invalid binary IP!';
      } else if (_mode == 'hex') {
        _decimal = hexToDecimal(input);
        _binary = decimalToBinary(_decimal);
        _hex = input;
        if (_decimal.isEmpty || _binary.isEmpty) _error = 'Invalid hex IP!';
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
      appBar: AppBar(title: const Text('IP Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: _mode,
              items: const [
                DropdownMenuItem(value: 'decimal', child: Text('Decimal')),
                DropdownMenuItem(value: 'binary', child: Text('Binary')),
                DropdownMenuItem(value: 'hex', child: Text('Hexadecimal')),
              ],
              onChanged: (v) => setState(() => _mode = v!),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter IP ($_mode)',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _convert,
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Convert'),
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
            if (_decimal.isNotEmpty && _error == null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Decimal: $_decimal'),
                      Text('Binary: $_binary'),
                      Text('Hex: $_hex'),
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
