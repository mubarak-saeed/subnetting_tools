import '../../domain/entities/ip_address.dart';
import '../../domain/repositories/ip_calculator_repository.dart';

class IpCalculatorRepositoryImpl implements IpCalculatorRepository {
  @override
  String calculateNetworkAddress(String ipAddress, int subnetMask) {
    final ipParts = ipAddress.split('.').map(int.parse).toList();
    final subnetBits = List.filled(32, false);

    for (var i = 0; i < subnetMask; i++) {
      subnetBits[i] = true;
    }

    final networkBits = [];
    for (var i = 0; i < 4; i++) {
      var octet = 0;
      for (var j = 0; j < 8; j++) {
        if (subnetBits[i * 8 + j]) {
          octet |= ((ipParts[i] >> (7 - j)) & 1) << (7 - j);
        }
      }
      networkBits.add(octet);
    }

    return networkBits.join('.');
  }

  @override
  String calculateBroadcastAddress(String ipAddress, int subnetMask) {
    final networkAddr = calculateNetworkAddress(ipAddress, subnetMask);
    final networkParts = networkAddr.split('.').map(int.parse).toList();

    var hostBits = 32 - subnetMask;
    final broadcastParts = List<int>.from(networkParts);

    for (var i = 3; i >= 0 && hostBits > 0; i--) {
      final bitsInThisOctet = hostBits > 8 ? 8 : hostBits;
      broadcastParts[i] |= (1 << bitsInThisOctet) - 1;
      hostBits -= bitsInThisOctet;
    }

    return broadcastParts.join('.');
  }

  @override
  int calculateTotalHosts(int subnetMask) {
    return (1 << (32 - subnetMask)) - 2;
  }

  @override
  String convertToBinary(String ipAddress) {
    return ipAddress
        .split('.')
        .map((octet) => int.parse(octet).toRadixString(2).padLeft(8, '0'))
        .join('.');
  }

  @override
  String convertToDecimal(String binaryIp) {
    return binaryIp
        .split('.')
        .map((binary) => int.parse(binary, radix: 2).toString())
        .join('.');
  }

  @override
  String determineIpClass(String ipAddress) {
    final firstOctet = int.parse(ipAddress.split('.')[0]);

    if (firstOctet < 128) return 'A';
    if (firstOctet < 192) return 'B';
    if (firstOctet < 224) return 'C';
    if (firstOctet < 240) return 'D';
    return 'E';
  }

  @override
  List<String> calculateSubnets(
      String networkAddress, int subnetMask, int numberOfSubnets) {
    final subnets = <String>[];
    final networkParts = networkAddress.split('.').map(int.parse).toList();
    final subnetBits = (32 - subnetMask).toInt();
    final hostsPerSubnet = (1 << subnetBits) ~/ numberOfSubnets;

    for (var i = 0; i < numberOfSubnets; i++) {
      final subnetParts = List<int>.from(networkParts);
      subnetParts[3] += (i * hostsPerSubnet);
      subnets.add(subnetParts.join('.'));
    }

    return subnets;
  }

  @override
  bool validateIpAddress(String ipAddress) {
    try {
      final parts = ipAddress.split('.');
      if (parts.length != 4) return false;

      return parts.every((part) {
        final value = int.parse(part);
        return value >= 0 && value <= 255;
      });
    } catch (_) {
      return false;
    }
  }

  @override
  IpAddress calculateAll(String ipAddress, int subnetMask) {
    if (!validateIpAddress(ipAddress)) {
      throw ArgumentError('Invalid IP address format');
    }

    final networkAddress = calculateNetworkAddress(ipAddress, subnetMask);
    final broadcastAddress = calculateBroadcastAddress(ipAddress, subnetMask);
    final totalHosts = calculateTotalHosts(subnetMask);
    final binaryAddress = convertToBinary(ipAddress);
    final networkClass = determineIpClass(ipAddress);
    final subnetAddresses = calculateSubnets(networkAddress, subnetMask, 4);

    return IpAddress(
      address: ipAddress,
      subnetMask: subnetMask,
      networkClass: networkClass,
      networkAddress: networkAddress,
      broadcastAddress: broadcastAddress,
      totalHosts: totalHosts,
      binaryAddress: binaryAddress,
      subnetAddresses: subnetAddresses,
    );
  }
}
