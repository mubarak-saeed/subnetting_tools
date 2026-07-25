import '../entities/ip_address.dart';

abstract class IpCalculatorRepository {
  String calculateNetworkAddress(String ipAddress, int subnetMask);
  String calculateBroadcastAddress(String ipAddress, int subnetMask);
  int calculateTotalHosts(int subnetMask);
  String convertToBinary(String ipAddress);
  String convertToDecimal(String binaryIp);
  String determineIpClass(String ipAddress);
  bool validateIpAddress(String ipAddress);
  IpAddress calculateAll(String ipAddress, int subnetMask);
}
