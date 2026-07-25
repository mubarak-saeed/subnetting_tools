import 'dart:math';
import 'ip_network_engine.dart';

class VlsmRequirement {
  final String name;
  final int requiredHosts;

  const VlsmRequirement({required this.name, required this.requiredHosts});
}

class VlsmAllocation {
  final String name;
  final int requestedHosts;
  final int allocatedHosts;
  final int cidr;
  final String netmask;
  final String wildcardMask;
  final String networkAddress;
  final String broadcastAddress;
  final String firstUsableIp;
  final String lastUsableIp;
  final int wastedHosts;

  const VlsmAllocation({
    required this.name,
    required this.requestedHosts,
    required this.allocatedHosts,
    required this.cidr,
    required this.netmask,
    required this.wildcardMask,
    required this.networkAddress,
    required this.broadcastAddress,
    required this.firstUsableIp,
    required this.lastUsableIp,
    required this.wastedHosts,
  });
}

class Ipv6Details {
  final String rawInput;
  final int prefixLength;
  final String compressedIp;
  final String expandedIp;
  final String networkPrefix;
  final String ipType;
  final String usableRange;

  const Ipv6Details({
    required this.rawInput,
    required this.prefixLength,
    required this.compressedIp,
    required this.expandedIp,
    required this.networkPrefix,
    required this.ipType,
    required this.usableRange,
  });
}

class CiscoNetworkEngine {
  /// Calculates Cisco Variable Length Subnet Masking (VLSM) allocations based on Cisco CCNA standards.
  static List<VlsmAllocation> calculateVlsm({
    required String baseIp,
    required int baseCidr,
    required List<VlsmRequirement> requirements,
  }) {
    if (!IpNetworkEngine.isValidIp(baseIp)) return [];

    // Sort requirements by requested hosts descending (Cisco VLSM golden rule)
    final sortedReqs = List<VlsmRequirement>.from(requirements)
      ..sort((a, b) => b.requiredHosts.compareTo(a.requiredHosts));

    int currentIpInt = IpNetworkEngine.ipToInt(baseIp) & IpNetworkEngine.cidrToMaskInt(baseCidr);
    final allocations = <VlsmAllocation>[];

    for (final req in sortedReqs) {
      if (req.requiredHosts < 1) continue;

      // Find smallest subnet CIDR that fits requiredHosts + 2 (Network + Broadcast)
      int hostBits = 0;
      while ((1 << hostBits) - 2 < req.requiredHosts) {
        hostBits++;
      }
      // For /31 point-to-point links (2 hosts needed)
      if (req.requiredHosts == 2 && hostBits < 1) hostBits = 1;
      if (hostBits < 2 && req.requiredHosts > 2) hostBits = 2;

      final subnetCidr = 32 - hostBits;
      if (subnetCidr < baseCidr) continue; // Out of bounds

      final subnetSize = 1 << hostBits;
      final maskInt = IpNetworkEngine.cidrToMaskInt(subnetCidr);
      final wildcardInt = (~maskInt) & 0xFFFFFFFF;

      final netInt = currentIpInt;
      final broadInt = netInt | wildcardInt;

      int allocatedUsable;
      int firstUsableInt;
      int lastUsableInt;

      if (subnetCidr == 31) {
        allocatedUsable = 2;
        firstUsableInt = netInt;
        lastUsableInt = broadInt;
      } else {
        allocatedUsable = max(0, subnetSize - 2);
        firstUsableInt = netInt + 1;
        lastUsableInt = broadInt - 1;
      }

      allocations.add(VlsmAllocation(
        name: req.name,
        requestedHosts: req.requiredHosts,
        allocatedHosts: allocatedUsable,
        cidr: subnetCidr,
        netmask: IpNetworkEngine.intToIp(maskInt),
        wildcardMask: IpNetworkEngine.intToIp(wildcardInt),
        networkAddress: IpNetworkEngine.intToIp(netInt),
        broadcastAddress: IpNetworkEngine.intToIp(broadInt),
        firstUsableIp: IpNetworkEngine.intToIp(firstUsableInt),
        lastUsableIp: IpNetworkEngine.intToIp(lastUsableInt),
        wastedHosts: max(0, allocatedUsable - req.requiredHosts),
      ));

      // Advance current IP to next subnet boundary
      currentIpInt += subnetSize;
    }

    return allocations;
  }

  /// Calculates Summary Route (Route Aggregation) for multiple IP networks
  static String? calculateSummaryRoute(List<String> cidrNetworks) {
    if (cidrNetworks.isEmpty) return null;

    final parsedIpInts = <int>[];
    final parsedCidrs = <int>[];

    for (final item in cidrNetworks) {
      final parts = item.trim().split('/');
      if (parts.length != 2) return null;
      if (!IpNetworkEngine.isValidIp(parts[0])) return null;
      final cidr = int.tryParse(parts[1]);
      if (cidr == null || cidr < 0 || cidr > 32) return null;

      parsedIpInts.add(IpNetworkEngine.ipToInt(parts[0]));
      parsedCidrs.add(cidr);
    }

    // Find common binary prefix
    int firstIp = parsedIpInts.first;
    int commonBits = 32;

    for (int i = 1; i < parsedIpInts.length; i++) {
      final diff = firstIp ^ parsedIpInts[i];
      if (diff != 0) {
        final leadingZeros = diff.toRadixString(2).padLeft(32, '0').indexOf('1');
        if (leadingZeros < commonBits) {
          commonBits = leadingZeros;
        }
      }
    }

    // Common prefix cannot exceed minimum input CIDR
    final minInputCidr = parsedCidrs.reduce(min);
    final summaryCidr = min(commonBits, minInputCidr);

    final summaryMask = IpNetworkEngine.cidrToMaskInt(summaryCidr);
    final summaryNetwork = firstIp & summaryMask;

    return '${IpNetworkEngine.intToIp(summaryNetwork)}/$summaryCidr';
  }

  /// Generates Cisco IOS CLI Commands for OSPF, EIGRP, and ACLs
  static Map<String, String> generateCiscoCliConfig({
    required String ip,
    required int cidr,
    String area = '0',
    int ospfProcessId = 1,
  }) {
    final maskInt = IpNetworkEngine.cidrToMaskInt(cidr);
    final wildcardInt = (~maskInt) & 0xFFFFFFFF;

    final netInt = IpNetworkEngine.ipToInt(ip) & maskInt;
    final netIp = IpNetworkEngine.intToIp(netInt);
    final netmask = IpNetworkEngine.intToIp(maskInt);
    final wildcard = IpNetworkEngine.intToIp(wildcardInt);

    return {
      'wildcard': wildcard,
      'ospf': 'router ospf $ospfProcessId\n router-id 1.1.1.1\n network $netIp $wildcard area $area',
      'eigrp': 'router eigrp 100\n network $netIp $wildcard\n no auto-summary',
      'interface': 'interface GigabitEthernet0/0/0\n ip address $ip $netmask\n no shutdown',
      'acl': 'access-list 100 permit ip $netIp $wildcard any',
      'staticRoute': 'ip route $netIp $netmask GigabitEthernet0/0/0',
    };
  }

  /// Abbreviates uncompressed IPv6 address according to RFC 5952
  static String compressIpv6(String ipv6) {
    var str = ipv6.trim().toLowerCase();
    if (str.isEmpty) return '';

    // Expand shorthand first if needed
    if (str.contains('::')) {
      final parts = str.split('::');
      final left = parts[0].isEmpty ? [] : parts[0].split(':');
      final right = parts[1].isEmpty ? [] : parts[1].split(':');
      final missingCount = 8 - (left.length + right.length);
      final middle = List.filled(missingCount, '0');
      final fullList = [...left, ...middle, ...right];
      str = fullList.map((e) => e.padLeft(4, '0')).join(':');
    }

    final hextets = str.split(':').map((h) {
      final hexVal = int.tryParse(h, radix: 16) ?? 0;
      return hexVal.toRadixString(16);
    }).toList();

    if (hextets.length != 8) return ipv6;

    // Find longest sequence of '0' hextets
    int bestStart = -1;
    int bestLen = 0;
    int curStart = -1;
    int curLen = 0;

    for (int i = 0; i < 8; i++) {
      if (hextets[i] == '0') {
        if (curStart == -1) curStart = i;
        curLen++;
        if (curLen > bestLen) {
          bestStart = curStart;
          bestLen = curLen;
        }
      } else {
        curStart = -1;
        curLen = 0;
      }
    }

    if (bestLen > 1) {
      hextets.removeRange(bestStart, bestStart + bestLen);
      hextets.insert(bestStart, '');
      if (bestStart == 0) hextets.insert(0, '');
      if (bestStart + bestLen == 8) hextets.add('');
    }

    return hextets.join(':');
  }

  /// Expands shorthand IPv6 address to full 8-hextet string (32 hex characters)
  static String expandIpv6(String ipv6) {
    var str = ipv6.trim().toLowerCase();
    if (str.isEmpty) return '';

    if (str.contains('::')) {
      final parts = str.split('::');
      final left = parts[0].isEmpty ? [] : parts[0].split(':');
      final right = parts[1].isEmpty ? [] : parts[1].split(':');
      final missingCount = 8 - (left.length + right.length);
      final middle = List.filled(missingCount, '0');
      final fullList = [...left, ...middle, ...right];
      return fullList.map((e) => e.padLeft(4, '0')).join(':');
    }

    final hextets = str.split(':');
    if (hextets.length == 8) {
      return hextets.map((e) => e.padLeft(4, '0')).join(':');
    }

    return ipv6;
  }

  /// Calculates IPv6 Subnet Details
  static Ipv6Details calculateIpv6Details(String ipv6, int prefixLength) {
    final expanded = expandIpv6(ipv6);
    final compressed = compressIpv6(ipv6);

    String scope = 'Global Unicast Address (Public IPv6)';
    if (compressed.startsWith('fe80:')) {
      scope = 'Link-Local Address (FE80::/10)';
    } else if (compressed.startsWith('fc') || compressed.startsWith('fd')) {
      scope = 'Unique Local Address (FC00::/7)';
    } else if (compressed.startsWith('ff')) {
      scope = 'Multicast Address (FF00::/8)';
    } else if (compressed == '::1') {
      scope = 'Loopback Address (::1/128)';
    }

    return Ipv6Details(
      rawInput: ipv6,
      prefixLength: prefixLength,
      compressedIp: compressed,
      expandedIp: expanded,
      networkPrefix: '$compressed/$prefixLength',
      ipType: scope,
      usableRange: '$compressed - Host Space (2^${128 - prefixLength} addresses)',
    );
  }
}
