String decimalToBinary(String ip) {
  final parts = ip.split('.');
  if (parts.length != 4) return '';
  try {
    return parts
        .map((e) => int.parse(e).toRadixString(2).padLeft(8, '0'))
        .join('.');
  } catch (_) {
    return '';
  }
}

String binaryToDecimal(String binary) {
  final parts = binary.split('.');
  if (parts.length != 4) return '';
  try {
    return parts.map((e) => int.parse(e, radix: 2).toString()).join('.');
  } catch (_) {
    return '';
  }
}

String decimalToHex(String ip) {
  final parts = ip.split('.');
  if (parts.length != 4) return '';
  try {
    return parts
        .map((e) => int.parse(e).toRadixString(16).padLeft(2, '0'))
        .join('.');
  } catch (_) {
    return '';
  }
}

String hexToDecimal(String hex) {
  final parts = hex.split('.');
  if (parts.length != 4) return '';
  try {
    return parts.map((e) => int.parse(e, radix: 16).toString()).join('.');
  } catch (_) {
    return '';
  }
}
