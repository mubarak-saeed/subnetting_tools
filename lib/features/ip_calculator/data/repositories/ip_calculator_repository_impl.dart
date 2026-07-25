import '../../../../core/network/ip_network_engine.dart';
import '../../domain/entities/ip_address.dart';
import '../../domain/repositories/ip_calculator_repository.dart';

class IpCalculatorRepositoryImpl implements IpCalculatorRepository {
  @override
  bool validateIpAddress(String ipAddress) {
    return IpNetworkEngine.isValidIp(ipAddress);
  }

  @override
  String calculateNetworkAddress(String ipAddress, int subnetMask) {
    final details = IpNetworkEngine.calculateDetails(ipAddress, subnetMask);
    return details.networkAddress;
  }

  @override
  String calculateBroadcastAddress(String ipAddress, int subnetMask) {
    final details = IpNetworkEngine.calculateDetails(ipAddress, subnetMask);
    return details.broadcastAddress;
  }

  @override
  int calculateTotalHosts(int subnetMask) {
    final details = IpNetworkEngine.calculateDetails('0.0.0.0', subnetMask);
    return details.usableHosts;
  }

  @override
  String convertToBinary(String ipAddress) {
    return IpNetworkEngine.toBinaryString(ipAddress);
  }

  @override
  String convertToDecimal(String binaryIp) {
    return IpNetworkEngine.binaryToDecimalIp(binaryIp);
  }

  @override
  String determineIpClass(String ipAddress) {
    final details = IpNetworkEngine.calculateDetails(ipAddress, 24);
    return details.ipClass;
  }

  @override
  IpAddress calculateAll(String ipAddress, int subnetMask) {
    final details = IpNetworkEngine.calculateDetails(ipAddress, subnetMask);
    final subnets = IpNetworkEngine.calculateSubnets(
      baseIp: ipAddress,
      baseCidr: subnetMask,
      targetSubnetsCount: 4,
    );
    return IpAddress.fromDetails(details, subnets);
  }
}
