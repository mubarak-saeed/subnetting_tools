import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../network/ip_network_engine.dart';
import '../../l10n/app_localizations.dart';

class IpInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const IpInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText = '192.168.1.1',
    this.onChanged,
  });

  @override
  State<IpInputField> createState() => _IpInputFieldState();
}

class _IpInputFieldState extends State<IpInputField> {
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _checkValidity();
    widget.controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChange);
    super.dispose();
  }

  void _onTextChange() {
    _checkValidity();
    if (widget.onChanged != null) {
      widget.onChanged!(widget.controller.text);
    }
  }

  void _checkValidity() {
    final text = widget.controller.text.trim();
    final valid = text.isEmpty || IpNetworkEngine.isValidIp(text);
    if (_isValid != valid) {
      setState(() {
        _isValid = valid;
      });
    }
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      final text = data!.text!.trim();
      widget.controller.text = text;
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text('${AppLocalizations.of(context).translate('copiedToClipboard')}: $text'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    final isNotEmpty = widget.controller.text.trim().isNotEmpty;
    final isFullyValid = isNotEmpty && _isValid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon: Icon(
              isFullyValid ? Icons.check_circle : Icons.lan_outlined,
              color: isFullyValid ? const Color(0xFF10B981) : null,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.assignment_outlined, size: 20),
                  tooltip: 'Paste IP',
                  onPressed: _pasteFromClipboard,
                ),
                if (isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () => widget.controller.clear(),
                  ),
              ],
            ),
          ),
          keyboardType: TextInputType.number,
        ),
        if (isNotEmpty && !_isValid)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 12.0, right: 12.0),
            child: Text(
              tr.translate('invalidInput'),
              style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
