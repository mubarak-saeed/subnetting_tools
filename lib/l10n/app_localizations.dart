import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Network Tools & Calculator',
      'chooseFeature': 'Choose a network tool to start',
      'ipCalculator': 'IP Calculator',
      'ipCalculatorDesc': 'Subnet mask, network & broadcast addresses, hosts',
      'subnetCalculator': 'Subnet Calculator',
      'subnetCalculatorDesc': 'Divide IP network into subnets with CIDR/VLSM',
      'ipConverter': 'IP Converter',
      'ipConverterDesc': 'Convert IP between Decimal, Binary, and Hex',
      'ipClassifier': 'IP Classifier',
      'ipClassifierDesc': 'Identify IP class, public/private type & RFC info',
      'rangeCalculator': 'Range Calculator',
      'rangeCalculatorDesc': 'Generate list of IPs between start and end range',
      'history': 'History Log',
      'historyDesc': 'Saved operations and calculation history',
      'calculate': 'Calculate',
      'calculateSubnets': 'Subdivide Network',
      'convert': 'Convert',
      'classify': 'Classify IP',
      'calculateRange': 'Generate Range',
      'clear': 'Clear',
      'clearHistory': 'Clear History',
      'noHistory': 'No calculation history saved yet.',
      'invalidInput': 'Invalid IP address format!',
      'invalidSubnetMask': 'Invalid subnet mask!',
      'invalidRange': 'Start IP must be less than or equal to End IP.',
      'networkAddress': 'Network Address',
      'broadcastAddress': 'Broadcast Address',
      'firstUsableIp': 'First Usable Host',
      'lastUsableIp': 'Last Usable Host',
      'totalHosts': 'Total Addresses',
      'usableHosts': 'Usable Host Addresses',
      'netmask': 'Subnet Mask',
      'wildcardMask': 'Wildcard Mask',
      'ipClass': 'IP Class',
      'ipType': 'Address Type',
      'binaryIp': 'Binary Representation',
      'hexIp': 'Hex Representation',
      'subnets': 'Calculated Subnets',
      'subnet': 'Subnet',
      'copiedToClipboard': 'Copied to clipboard!',
      'copy': 'Copy',
      'editAsDotted': 'Edit Subnet Mask (Dotted)',
      'enterSubnetMaskDotted': 'Enter Subnet Mask in Dotted Format',
      'numberOfSubnets': 'Target Subnets Count',
      'startIp': 'Start IP Address',
      'endIp': 'End IP Address',
      'enterIp': 'Enter IP Address',
      'mode': 'Input Format',
      'decimal': 'Decimal',
      'binary': 'Binary',
      'hex': 'Hexadecimal',
      'bitVisualization': 'Bit Visualization (Network / Host)',
      'networkBits': 'Network Bits',
      'hostBits': 'Host Bits',
      'settings': 'Settings',
      'themeMode': 'Theme Mode',
      'language': 'Language',
      'arabic': 'العربية',
      'english': 'English',
      'delete': 'Delete',
    },
    'ar': {
      'appTitle': 'أدوات وحاسبة الشبكات',
      'chooseFeature': 'اختر أداة الشبكة للبدء',
      'ipCalculator': 'حاسبة الـ IP',
      'ipCalculatorDesc': 'حساب قناع الشبكة وعنوان البث والأجهزة المتاحة',
      'subnetCalculator': 'حاسبة تقسيم الشبكات',
      'subnetCalculatorDesc': 'تقسيم شبكات IP إلى شبكات فرعية CIDR/VLSM',
      'ipConverter': 'محوّل عناوين IP',
      'ipConverterDesc': 'التحويل بين النظام العشري والثنائي والسداسي عشر',
      'ipClassifier': 'مصنّف عناوين IP',
      'ipClassifierDesc': 'تحديد فئة الـ IP وعما إذا كان خاصاً أم عاماً',
      'rangeCalculator': 'حاسبة مدى العناوين',
      'rangeCalculatorDesc': 'توليد قائمة عناوين IP بين بداية ونهاية المدى',
      'history': 'سجل العمليات',
      'historyDesc': 'عرض وسجل العمليات والحسابات المحفوظة',
      'calculate': 'احسب التفاصيل',
      'calculateSubnets': 'تقسيم الشبكة',
      'convert': 'تحويل',
      'classify': 'فحص وتصنيف',
      'calculateRange': 'توليد المدى',
      'clear': 'مسح',
      'clearHistory': 'مسح السجل بالكامل',
      'noHistory': 'لا يوجد سجل عمليات محفوظ حالياً.',
      'invalidInput': 'صيغة عنوان IP غير صالحة!',
      'invalidSubnetMask': 'قناع الشبكة غير صالح!',
      'invalidRange': 'عنوان البداية يجب أن يكون أصغر أو يساوي عنوان النهاية.',
      'networkAddress': 'عنوان الشبكة (Network IP)',
      'broadcastAddress': 'عنوان البث (Broadcast IP)',
      'firstUsableIp': 'أول جهاز متاح (First Usable)',
      'lastUsableIp': 'آخر جهاز متاح (Last Usable)',
      'totalHosts': 'إجمالي الإناوين',
      'usableHosts': 'عدد الأجهزة المتاحة (Usable Hosts)',
      'netmask': 'قناع الشبكة (Netmask)',
      'wildcardMask': 'القناع العكسي (Wildcard)',
      'ipClass': 'فئة الشبكة (IP Class)',
      'ipType': 'نوع العنوان',
      'binaryIp': 'التمثيل الثنائي (Binary)',
      'hexIp': 'التمثيل السداسي عشر (Hex)',
      'subnets': 'الشبكات الفرعية الناتجة',
      'subnet': 'شبكة فرعية',
      'copiedToClipboard': 'تم النسخ إلى الحافظة!',
      'copy': 'نسخ',
      'editAsDotted': 'إدخال القناع بالصيغة العشرية',
      'enterSubnetMaskDotted': 'أدخل قناع الشبكة (مثال: 255.255.255.0)',
      'numberOfSubnets': 'عدد الشبكات الفرعية المطلوبة',
      'startIp': 'عنوان البداية',
      'endIp': 'عنوان النهاية',
      'enterIp': 'أدخل عنوان IP',
      'mode': 'صيغة الإدخال',
      'decimal': 'عشري (Decimal)',
      'binary': 'ثنائي (Binary)',
      'hex': 'سداسي عشر (Hex)',
      'bitVisualization': 'تمثيل البتات (بتات الشبكة / بتات المضيف)',
      'networkBits': 'بتات الشبكة',
      'hostBits': 'بتات المضيف',
      'settings': 'الإعدادات',
      'themeMode': 'المظهر',
      'language': 'اللغة',
      'arabic': 'العربية',
      'english': 'English',
      'delete': 'حذف',
    },
  };

  String translate(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ??
        _localizedValues['en']?[key] ??
        key;
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
    return true;
  }
}
