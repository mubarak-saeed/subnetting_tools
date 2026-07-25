import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  final Map<String, String> _localizedStrings = {
    'appTitle': 'Network Calculator',
    'chooseFeature': 'Choose the network feature you want to use',
    'ipCalculator': 'IP Calculator',
    'subnetCalculator': 'Subnet Calculator',
    'ipConverter': 'IP Converter',
    'ipClassifier': 'IP Classifier',
    'rangeCalculator': 'Range Calculator',
    'history': 'History',
    'calculate': 'Calculate',
    'calculateSubnets': 'Calculate Subnets',
    'convert': 'Convert',
    'classify': 'Classify',
    'clear': 'Clear',
    'noHistory': 'No history yet.',
    'invalidInput': 'Invalid input!',
    'networkAddress': 'Network Address',
    'broadcastAddress': 'Broadcast Address',
    'firstUsableIp': 'First Usable IP',
    'lastUsableIp': 'Last Usable IP',
    'totalHosts': 'Total Usable Hosts'
  };

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
