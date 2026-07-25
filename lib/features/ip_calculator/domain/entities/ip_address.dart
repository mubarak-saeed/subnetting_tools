import 'package:equatable/equatable.dart';

class IpAddress extends Equatable {
  final String address;
  final int subnetMask;
  final String networkClass;
  final String networkAddress;
  final String broadcastAddress;
  final int totalHosts;
  final String binaryAddress;
  final List<String> subnetAddresses;

  const IpAddress({
    required this.address,
    required this.subnetMask,
    required this.networkClass,
    required this.networkAddress,
    required this.broadcastAddress,
    required this.totalHosts,
    required this.binaryAddress,
    required this.subnetAddresses,
  });

  @override
  List<Object?> get props => [
        address,
        subnetMask,
        networkClass,
        networkAddress,
        broadcastAddress,
        totalHosts,
        binaryAddress,
        subnetAddresses,
      ];
}
