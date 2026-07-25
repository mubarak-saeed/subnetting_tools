// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/ip_network_engine.dart';
import '../../../../core/widgets/cidr_selector_chips.dart';
import '../../../../core/widgets/ip_input_field.dart';
import '../../../../core/widgets/quick_preset_chips.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/ip_calculator_cubit.dart';
import '../widgets/ip_result_card.dart';
import '../widgets/subnet_result_card.dart';

class IpCalculatorPage extends StatefulWidget {
  const IpCalculatorPage({super.key});

  @override
  State<IpCalculatorPage> createState() => _IpCalculatorPageState();
}

class _IpCalculatorPageState extends State<IpCalculatorPage> {
  final _ipController = TextEditingController(text: '192.168.1.1');
  int _subnetMask = 24;

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('ipCalculator')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IpInputField(
                      controller: _ipController,
                      labelText: tr.translate('enterIp'),
                    ),
                    const SizedBox(height: 10),
                    QuickPresetChips(
                      onSelected: (ip) {
                        setState(() {
                          _ipController.text = ip;
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${tr.translate('netmask')}:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '/$_subnetMask (${IpNetworkEngine.intToIp(IpNetworkEngine.cidrToMaskInt(_subnetMask))})',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
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
                        IconButton(
                          icon: const Icon(Icons.edit_note, color: Colors.blueAccent),
                          tooltip: tr.translate('editAsDotted'),
                          onPressed: () async {
                            final mask = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                final controller = TextEditingController();
                                return AlertDialog(
                                  title: Text(tr.translate('enterSubnetMaskDotted')),
                                  content: TextField(
                                    controller: controller,
                                    decoration: const InputDecoration(
                                        hintText: '255.255.255.0'),
                                    keyboardType: TextInputType.number,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(tr.translate('clear')),
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
                              final bits = IpNetworkEngine.maskToCidr(mask.trim());
                              if (bits != null) {
                                setState(() => _subnetMask = bits);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(tr.translate('invalidSubnetMask'))),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    CidrSelectorChips(
                      selectedCidr: _subnetMask,
                      onCidrSelected: (cidr) {
                        setState(() => _subnetMask = cidr);
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<IpCalculatorCubit>().calculateIp(
                              _ipController.text.trim(),
                              _subnetMask,
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      icon: const Icon(Icons.tune),
                      label: Text(tr.translate('calculate')),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<IpCalculatorCubit, IpCalculatorState>(
              builder: (context, state) {
                if (state is IpCalculatorLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
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
                        tr.translate(state.messageKey),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
}
