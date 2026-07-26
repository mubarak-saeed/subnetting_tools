import 'package:flutter_test/flutter_test.dart';
import 'package:subnetting_tools/core/network/ip_network_engine.dart';

void main() {
  group('IpNetworkEngine - Validation & Basic Conversions', () {
    test('isValidIp returns true for valid IPv4 addresses', () {
      expect(IpNetworkEngine.isValidIp('192.168.1.1'), isTrue);
      expect(IpNetworkEngine.isValidIp('0.0.0.0'), isTrue);
      expect(IpNetworkEngine.isValidIp('255.255.255.255'), isTrue);
      expect(IpNetworkEngine.isValidIp('10.0.0.254'), isTrue);
    });

    test('isValidIp returns false for invalid IPv4 addresses', () {
      expect(IpNetworkEngine.isValidIp('256.1.1.1'), isFalse);
      expect(IpNetworkEngine.isValidIp('192.168.1'), isFalse);
      expect(IpNetworkEngine.isValidIp('abc.def.ghi.jkl'), isFalse);
      expect(IpNetworkEngine.isValidIp('192.168.1.1.1'), isFalse);
    });

    test('ipToInt & intToIp bidirectionally convert correctly', () {
      const ipStr = '192.168.1.100';
      final ipInt = IpNetworkEngine.ipToInt(ipStr);
      expect(IpNetworkEngine.intToIp(ipInt), equals(ipStr));
    });

    test('toBinaryString formats 32 bits correctly', () {
      expect(IpNetworkEngine.toBinaryString('192.168.1.1'),
          equals('11000000.10101000.00000001.00000001'));
    });

    test('toHexString formats hex correctly', () {
      expect(IpNetworkEngine.toHexString('192.168.1.1'), equals('C0.A8.01.01'));
    });
  });

  group('IpNetworkEngine - Network Details & RFC Compliance', () {
    test('Calculates standard /24 network details correctly', () {
      final details = IpNetworkEngine.calculateDetails('192.168.1.50', 24);
      expect(details.networkAddress, equals('192.168.1.0'));
      expect(details.broadcastAddress, equals('192.168.1.255'));
      expect(details.netmask, equals('255.255.255.0'));
      expect(details.wildcardMask, equals('0.0.0.255'));
      expect(details.firstUsableIp, equals('192.168.1.1'));
      expect(details.lastUsableIp, equals('192.168.1.254'));
      expect(details.usableHosts, equals(254));
      expect(details.totalHosts, equals(256));
      expect(details.isPrivate, isTrue);
      expect(details.ipClass, equals('C'));
    });

    test('Calculates RFC 3021 /31 point-to-point network correctly', () {
      final details = IpNetworkEngine.calculateDetails('10.0.0.1', 31);
      expect(details.networkAddress, equals('10.0.0.0'));
      expect(details.broadcastAddress, equals('10.0.0.1'));
      expect(details.usableHosts, equals(2));
      expect(details.firstUsableIp, equals('10.0.0.0'));
      expect(details.lastUsableIp, equals('10.0.0.1'));
    });

    test('Calculates single host /32 correctly', () {
      final details = IpNetworkEngine.calculateDetails('8.8.8.8', 32);
      expect(details.networkAddress, equals('8.8.8.8'));
      expect(details.broadcastAddress, equals('8.8.8.8'));
      expect(details.usableHosts, equals(1));
    });
  });

  group('IpNetworkEngine - Subnetting & Range', () {
    test('Subdivides /24 into 4 subnets correctly', () {
      final subnets = IpNetworkEngine.calculateSubnets(
        baseIp: '192.168.1.0',
        baseCidr: 24,
        targetSubnetsCount: 4,
      );

      expect(subnets.length, equals(4));
      expect(subnets[0].cidrNotation, equals('192.168.1.0/26'));
      expect(subnets[1].cidrNotation, equals('192.168.1.64/26'));
      expect(subnets[2].cidrNotation, equals('192.168.1.128/26'));
      expect(subnets[3].cidrNotation, equals('192.168.1.192/26'));
      expect(subnets[0].usableHosts, equals(62));
    });

    test('Generates IP range sequentially', () {
      final range = IpNetworkEngine.calculateRange('192.168.1.1', '192.168.1.4');
      expect(range, equals([
        '192.168.1.1',
        '192.168.1.2',
        '192.168.1.3',
        '192.168.1.4',
      ]));
    });
  });
}
