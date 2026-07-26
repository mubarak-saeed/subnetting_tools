import 'package:flutter_test/flutter_test.dart';
import 'package:subnetting_tools/core/network/cisco_network_engine.dart';

void main() {
  group('CiscoNetworkEngine - VLSM Allocator (CCNA Rule)', () {
    test('Allocates subnets sorted descending by required hosts', () {
      final allocations = CiscoNetworkEngine.calculateVlsm(
        baseIp: '192.168.1.0',
        baseCidr: 24,
        requirements: [
          const VlsmRequirement(name: 'Sales', requiredHosts: 60),
          const VlsmRequirement(name: 'Engineering', requiredHosts: 28),
          const VlsmRequirement(name: 'HR', requiredHosts: 12),
          const VlsmRequirement(name: 'RouterLink', requiredHosts: 2),
        ],
      );

      expect(allocations.length, equals(4));

      // Sales: 60 hosts -> /26 (62 usable, net 192.168.1.0)
      expect(allocations[0].name, equals('Sales'));
      expect(allocations[0].cidr, equals(26));
      expect(allocations[0].networkAddress, equals('192.168.1.0'));
      expect(allocations[0].wildcardMask, equals('0.0.0.63'));

      // Engineering: 28 hosts -> /27 (30 usable, net 192.168.1.64)
      expect(allocations[1].name, equals('Engineering'));
      expect(allocations[1].cidr, equals(27));
      expect(allocations[1].networkAddress, equals('192.168.1.64'));

      // HR: 12 hosts -> /28 (14 usable, net 192.168.1.96)
      expect(allocations[2].name, equals('HR'));
      expect(allocations[2].cidr, equals(28));
      expect(allocations[2].networkAddress, equals('192.168.1.96'));

      // RouterLink: 2 hosts -> /30 (2 usable, net 192.168.1.112)
      expect(allocations[3].name, equals('RouterLink'));
      expect(allocations[3].cidr, equals(30));
      expect(allocations[3].networkAddress, equals('192.168.1.112'));
    });
  });

  group('CiscoNetworkEngine - CLI Generator & Route Summarization', () {
    test('Generates Cisco IOS CLI OSPF and Wildcard commands', () {
      final cli = CiscoNetworkEngine.generateCiscoCliConfig(
        ip: '192.168.1.0',
        cidr: 24,
      );

      expect(cli['wildcard'], equals('0.0.0.255'));
      expect(cli['ospf'], contains('network 192.168.1.0 0.0.0.255 area 0'));
      expect(cli['acl'], contains('access-list 100 permit ip 192.168.1.0 0.0.0.255 any'));
    });

    test('Calculates Cisco Route Summarization correctly', () {
      final summary = CiscoNetworkEngine.calculateSummaryRoute([
        '172.16.0.0/24',
        '172.16.1.0/24',
        '172.16.2.0/24',
        '172.16.3.0/24',
      ]);

      expect(summary, equals('172.16.0.0/22'));
    });
  });

  group('CiscoNetworkEngine - IPv6 Calculation & Compression', () {
    test('Compresses and expands IPv6 address according to RFC 5952', () {
      final raw = '2001:0db8:85a3:0000:0000:8a2e:0370:7334';
      final compressed = CiscoNetworkEngine.compressIpv6(raw);
      final expanded = CiscoNetworkEngine.expandIpv6(compressed);

      expect(compressed, equals('2001:db8:85a3::8a2e:370:7334'));
      expect(expanded, equals('2001:0db8:85a3:0000:0000:8a2e:0370:7334'));
    });

    test('Calculates IPv6 scope details', () {
      final details = CiscoNetworkEngine.calculateIpv6Details('2001:db8::1', 64);
      expect(details.compressedIp, equals('2001:db8::1'));
      expect(details.ipType, contains('Global Unicast'));
    });
  });
}
