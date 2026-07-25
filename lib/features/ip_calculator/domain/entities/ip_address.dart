import 'package:equatable/equatable.dart';
import '../../../../core/network/ip_network_engine.dart';

class IpAddress extends Equatable {
  final String address;
  final int subnetMask;
  final String netmask;
  final String wildcardMask;
  final String networkClass;
  final String networkAddress;
  final String broadcastAddress;
  final String firstUsableIp;
  final String lastUsableIp;
  final int totalHosts;
  final int usableHosts;
  final bool isPrivate;
  final String ipTypeDescription;
  final String binaryAddress;
  final String binaryNetmask;
  final List<SubnetItem> subnets;

  const IpAddress({
    required this.address,
    required this.subnetMask,
    required this.netmask,
    required this.wildcardMask,
    required this.networkClass,
    required this.networkAddress,
    required this.broadcastAddress,
    required this.firstUsableIp,
    required this.lastUsableIp,
    required this.totalHosts,
    required this.usableHosts,
    required this.isPrivate,
    required this.ipTypeDescription,
    required this.binaryAddress,
    required this.binaryNetmask,
    required this.subnets,
  });

  factory IpAddress.fromDetails(IpNetworkDetails details, List<SubnetItem> subnets) {
    return IpAddress(
      address: details.ipAddress,
      subnetMask: details.cidr,
      netmask: details.netmask,
      wildcardMask: details.wildcardMask,
      networkClass: details.ipClass,
      networkAddress: details.networkAddress,
      broadcastAddress: details.broadcastAddress,
      firstUsableIp: details.firstUsableIp,
      lastUsableIp: details.lastUsableIp,
      totalHosts: details.totalHosts,
      usableHosts: details.usableHosts,
      isPrivate: details.isPrivate,
      ipTypeDescription: details.ipTypeDescription,
      binaryAddress: details.binaryIp,
      binaryNetmask: details.binaryNetmask,
      subnets: subnets,
    );
  }

  @override
  List<Object?> get props => [
        address,
        subnetMask,
        netmask,
        wildcardMask,
        networkClass,
        networkAddress,
        broadcastAddress,
        firstUsableIp,
        lastUsableIp,
        totalHosts,
        usableHosts,
        isPrivate,
        ipTypeDescription,
        binaryAddress,
        binaryNetmask,
        subnets,
      ];
}
