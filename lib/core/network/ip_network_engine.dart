import 'dart:math';

/// Unified model representing calculated IP network details
class IpNetworkDetails {
  final String ipAddress;
  final int cidr;
  final String netmask;
  final String wildcardMask;
  final String networkAddress;
  final String broadcastAddress;
  final String firstUsableIp;
  final String lastUsableIp;
  final int totalHosts;
  final int usableHosts;
  final String ipClass;
  final bool isPrivate;
  final String ipTypeDescription;
  final String binaryIp;
  final String binaryNetmask;

  const IpNetworkDetails({
    required this.ipAddress,
    required this.cidr,
    required this.netmask,
    required this.wildcardMask,
    required this.networkAddress,
    required this.broadcastAddress,
    required this.firstUsableIp,
    required this.lastUsableIp,
    required this.totalHosts,
    required this.usableHosts,
    required this.ipClass,
    required this.isPrivate,
    required this.ipTypeDescription,
    required this.binaryIp,
    required this.binaryNetmask,
  });
}

/// Unified model for Subnet Info
class SubnetItem {
  final int index;
  final String cidrNotation;
  final String networkAddress;
  final String broadcastAddress;
  final String firstUsableIp;
  final String lastUsableIp;
  final int usableHosts;

  const SubnetItem({
    required this.index,
    required this.cidrNotation,
    required this.networkAddress,
    required this.broadcastAddress,
    required this.firstUsableIp,
    required this.lastUsableIp,
    required this.usableHosts,
  });
}

/// Core high-performance IPv4 network calculation engine using 32-bit integer arithmetic.
class IpNetworkEngine {
  /// Validates standard IPv4 dotted-decimal format (0.0.0.0 - 255.255.255.255)
  static bool isValidIp(String ip) {
    final parts = ip.trim().split('.');
    if (parts.length != 4) return false;
    for (final part in parts) {
      final val = int.tryParse(part);
      if (val == null || val < 0 || val > 255) return false;
    }
    return true;
  }

  /// Converts dotted-decimal IPv4 string to 32-bit unsigned int
  static int ipToInt(String ip) {
    if (!isValidIp(ip)) throw ArgumentError('Invalid IP address: $ip');
    final parts = ip.trim().split('.').map(int.parse).toList();
    return ((parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8) | parts[3]) & 0xFFFFFFFF;
  }

  /// Converts 32-bit unsigned int back to dotted-decimal IPv4 string
  static String intToIp(int value) {
    final v = value & 0xFFFFFFFF;
    final o1 = (v >> 24) & 0xFF;
    final o2 = (v >> 16) & 0xFF;
    final o3 = (v >> 8) & 0xFF;
    final o4 = v & 0xFF;
    return '$o1.$o2.$o3.$o4';
  }

  /// Converts CIDR prefix length (0-32) to 32-bit integer mask
  static int cidrToMaskInt(int cidr) {
    if (cidr < 0 || cidr > 32) throw ArgumentError('CIDR must be 0-32');
    if (cidr == 0) return 0;
    return ((0xFFFFFFFF << (32 - cidr)) & 0xFFFFFFFF);
  }

  /// Converts dotted subnet mask string to CIDR prefix length
  static int? maskToCidr(String mask) {
    if (!isValidIp(mask)) return null;
    final maskInt = ipToInt(mask);
    // Mask must be consecutive 1s followed by 0s
    final binaryStr = maskInt.toRadixString(2).padLeft(32, '0');
    final match = RegExp(r'^(1*)(0*)$').firstMatch(binaryStr);
    if (match == null) return null;
    return match.group(1)?.length ?? 0;
  }

  /// Converts IP string to 32-bit binary string representation (e.g. 11000000.10101000.00000001.00000001)
  static String toBinaryString(String ip) {
    final parts = ip.trim().split('.').map(int.parse);
    return parts.map((octet) => octet.toRadixString(2).padLeft(8, '0')).join('.');
  }

  /// Converts IP string to 32-bit Hex string representation (e.g. C0.A8.01.01)
  static String toHexString(String ip) {
    final parts = ip.trim().split('.').map(int.parse);
    return parts.map((octet) => octet.toRadixString(16).padLeft(2, '0').toUpperCase()).join('.');
  }

  /// Converts binary IP string (8.8.8.8 bits) back to dotted decimal IP
  static String binaryToDecimalIp(String binaryStr) {
    final cleanStr = binaryStr.replaceAll(' ', '');
    final parts = cleanStr.contains('.') ? cleanStr.split('.') : [
      if (cleanStr.length >= 8) cleanStr.substring(0, 8),
      if (cleanStr.length >= 16) cleanStr.substring(8, 16),
      if (cleanStr.length >= 24) cleanStr.substring(16, 24),
      if (cleanStr.length >= 32) cleanStr.substring(24, 32),
    ];
    if (parts.length != 4) throw ArgumentError('Invalid binary IP format');
    return parts.map((part) => int.parse(part, radix: 2).toString()).join('.');
  }

  /// Converts Hex IP string (XX.XX.XX.XX) back to dotted decimal IP
  static String hexToDecimalIp(String hexStr) {
    final cleanStr = hexStr.replaceAll(' ', '').replaceAll('0x', '');
    final parts = cleanStr.contains('.') ? cleanStr.split('.') : [
      if (cleanStr.length >= 2) cleanStr.substring(0, 2),
      if (cleanStr.length >= 4) cleanStr.substring(2, 4),
      if (cleanStr.length >= 6) cleanStr.substring(4, 6),
      if (cleanStr.length >= 8) cleanStr.substring(6, 8),
    ];
    if (parts.length != 4) throw ArgumentError('Invalid hex IP format');
    return parts.map((part) => int.parse(part, radix: 16).toString()).join('.');
  }

  /// Classifies IPv4 class (A, B, C, D, E)
  static String getIpClass(int firstOctet) {
    if (firstOctet < 128) return 'A';
    if (firstOctet < 192) return 'B';
    if (firstOctet < 224) return 'C';
    if (firstOctet < 240) return 'D (Multicast)';
    return 'E (Experimental/Reserved)';
  }

  /// Checks if IPv4 address is in Private Address Space (RFC 1918)
  static bool isPrivateIp(String ip) {
    if (!isValidIp(ip)) return false;
    final parts = ip.split('.').map(int.parse).toList();
    final oct1 = parts[0];
    final oct2 = parts[1];

    // 10.0.0.0/8
    if (oct1 == 10) return true;
    // 172.16.0.0/12
    if (oct1 == 172 && oct2 >= 16 && oct2 <= 31) return true;
    // 192.168.0.0/16
    if (oct1 == 192 && oct2 == 168) return true;
    // 127.0.0.0/8 Loopback
    if (oct1 == 127) return true;
    // 169.254.0.0/16 Link-Local
    if (oct1 == 169 && oct2 == 254) return true;

    return false;
  }

  /// Detailed IP type description
  static String getIpTypeDescription(String ip) {
    if (!isValidIp(ip)) return 'Invalid IP';
    final parts = ip.split('.').map(int.parse).toList();
    final oct1 = parts[0];
    final oct2 = parts[1];

    if (oct1 == 10) return 'Private Address (RFC 1918 Class A)';
    if (oct1 == 172 && oct2 >= 16 && oct2 <= 31) return 'Private Address (RFC 1918 Class B)';
    if (oct1 == 192 && oct2 == 168) return 'Private Address (RFC 1918 Class C)';
    if (oct1 == 127) return 'Loopback Address';
    if (oct1 == 169 && oct2 == 254) return 'Link-Local Address (APIPA)';
    if (oct1 >= 224 && oct1 <= 239) return 'Multicast Address (Class D)';
    if (oct1 >= 240) return 'Reserved/Experimental Address (Class E)';
    if (oct1 == 0) return 'Current Network / Default Route';
    if (ip == '255.255.255.255') return 'Limited Broadcast Address';

    return 'Public Address';
  }

  /// Calculates full IP network details for a given IP and CIDR prefix length
  static IpNetworkDetails calculateDetails(String ip, int cidr) {
    final ipInt = ipToInt(ip);
    final maskInt = cidrToMaskInt(cidr);
    final wildcardInt = (~maskInt) & 0xFFFFFFFF;

    final networkInt = ipInt & maskInt;
    final broadcastInt = networkInt | wildcardInt;

    final totalHosts = pow(2, 32 - cidr).toInt();

    int usableHosts;
    int firstUsableInt;
    int lastUsableInt;

    if (cidr == 32) {
      usableHosts = 1;
      firstUsableInt = networkInt;
      lastUsableInt = networkInt;
    } else if (cidr == 31) {
      // RFC 3021: /31 for point-to-point links uses both addresses as usable
      usableHosts = 2;
      firstUsableInt = networkInt;
      lastUsableInt = broadcastInt;
    } else {
      usableHosts = max(0, totalHosts - 2);
      firstUsableInt = networkInt + 1;
      lastUsableInt = broadcastInt - 1;
    }

    final firstOctet = (ipInt >> 24) & 0xFF;

    return IpNetworkDetails(
      ipAddress: ip,
      cidr: cidr,
      netmask: intToIp(maskInt),
      wildcardMask: intToIp(wildcardInt),
      networkAddress: intToIp(networkInt),
      broadcastAddress: intToIp(broadcastInt),
      firstUsableIp: intToIp(firstUsableInt),
      lastUsableIp: intToIp(lastUsableInt),
      totalHosts: totalHosts,
      usableHosts: usableHosts,
      ipClass: getIpClass(firstOctet),
      isPrivate: isPrivateIp(ip),
      ipTypeDescription: getIpTypeDescription(ip),
      binaryIp: toBinaryString(ip),
      binaryNetmask: toBinaryString(intToIp(maskInt)),
    );
  }

  /// Calculates CIDR subnets by splitting a base network into 2^bits subnets.
  /// [targetSubnetsCount] will be rounded up to the next power of 2.
  static List<SubnetItem> calculateSubnets({
    required String baseIp,
    required int baseCidr,
    required int targetSubnetsCount,
  }) {
    if (targetSubnetsCount < 1) return [];
    if (baseCidr < 0 || baseCidr >= 32) return [];

    // Calculate required additional bits to borrow
    int bitsNeeded = 0;
    while ((1 << bitsNeeded) < targetSubnetsCount) {
      bitsNeeded++;
    }

    final newCidr = baseCidr + bitsNeeded;
    if (newCidr > 32) return []; // Cannot subdivide further

    final actualSubnetsCount = 1 << bitsNeeded;
    final subnetSize = 1 << (32 - newCidr);

    final baseNetworkInt = ipToInt(baseIp) & cidrToMaskInt(baseCidr);
    final results = <SubnetItem>[];

    for (int i = 0; i < actualSubnetsCount; i++) {
      final subNetworkInt = baseNetworkInt + (i * subnetSize);
      final subNetmaskInt = cidrToMaskInt(newCidr);
      final subWildcardInt = (~subNetmaskInt) & 0xFFFFFFFF;
      final subBroadcastInt = subNetworkInt | subWildcardInt;

      int usableHosts;
      int firstUsableInt;
      int lastUsableInt;

      if (newCidr == 32) {
        usableHosts = 1;
        firstUsableInt = subNetworkInt;
        lastUsableInt = subNetworkInt;
      } else if (newCidr == 31) {
        usableHosts = 2;
        firstUsableInt = subNetworkInt;
        lastUsableInt = subBroadcastInt;
      } else {
        usableHosts = max(0, (1 << (32 - newCidr)) - 2);
        firstUsableInt = subNetworkInt + 1;
        lastUsableInt = subBroadcastInt - 1;
      }

      results.add(SubnetItem(
        index: i + 1,
        cidrNotation: '${intToIp(subNetworkInt)}/$newCidr',
        networkAddress: intToIp(subNetworkInt),
        broadcastAddress: intToIp(subBroadcastInt),
        firstUsableIp: intToIp(firstUsableInt),
        lastUsableIp: intToIp(lastUsableInt),
        usableHosts: usableHosts,
      ));
    }

    return results;
  }

  /// Calculates sequential list of IP addresses between startIp and endIp
  static List<String> calculateRange(String startIp, String endIp, {int maxResults = 5000}) {
    if (!isValidIp(startIp) || !isValidIp(endIp)) return [];
    final startInt = ipToInt(startIp);
    final endInt = ipToInt(endIp);

    if (startInt > endInt) return [];

    final list = <String>[];
    final count = min(endInt - startInt + 1, maxResults);

    for (int i = 0; i < count; i++) {
      list.add(intToIp(startInt + i));
    }

    return list;
  }
}
