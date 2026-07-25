// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/ip_calculator_cubit.dart';
import '../widgets/ip_result_card.dart';
import '../widgets/subnet_result_card.dart';

class IpCalculatorPage extends StatefulWidget {
  const IpCalculatorPage({super.key});

  @override
  State<IpCalculatorPage> createState() => _IpCalculatorPageState();
}

class _IpCalculatorPageState extends State<IpCalculatorPage> {
  final _ipController = TextEditingController();
  int _subnetMask = 24;

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _ipController,
                      decoration: InputDecoration(
                        labelText: 'IP Address',
                        hintText: '192.168.1.1',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _ipController.clear(),
                        ),
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
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit as dotted',
                          onPressed: () async {
                            final mask = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                final controller = TextEditingController();
                                return AlertDialog(
                                  title:
                                      const Text('Enter Subnet Mask (dotted)'),
                                  content: TextField(
                                    controller: controller,
                                    decoration: const InputDecoration(
                                        hintText: '255.255.255.0'),
                                    keyboardType: TextInputType.number,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(
                                          context, controller.text),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (mask != null && mask.isNotEmpty) {
                              final bits = _dottedToCidr(mask);
                              if (bits != null) {
                                setState(() => _subnetMask = bits);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Invalid subnet mask!')),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<IpCalculatorCubit>().calculateIp(
                              _ipController.text,
                              _subnetMask,
                            );
                      },
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calculate'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<IpCalculatorCubit, IpCalculatorState>(
              builder: (context, state) {
                if (state is IpCalculatorLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is IpCalculatorSuccess) {
                  return Column(
                    children: [
                      IpResultCard(ipAddress: state.ipAddress),
                      const SizedBox(height: 16),
                      SubnetResultCard(ipAddress: state.ipAddress),
                    ],
                  );
                } else if (state is IpCalculatorError) {
                  return Card(
                    color: Theme.of(context).colorScheme.error,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  int? _dottedToCidr(String mask) {
    final parts = mask.split('.');
    if (parts.length != 4) return null;
    try {
      final binary = parts
          .map((e) => int.parse(e).toRadixString(2).padLeft(8, '0'))
          .join();
      // يجب أن يكون الباينري عبارة عن سلسلة من 1 ثم 0 فقط (بدون تداخل)
      final match = RegExp(r'^(1+)(0+)$|^(1+)$').firstMatch(binary);
      if (match == null) return null;
      return !binary.contains('0') ? 32 : binary.indexOf('0');
    } catch (_) {
      return null;
    }
  }
}
