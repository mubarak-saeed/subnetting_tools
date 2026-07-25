class SubnetInfo {
  final String networkAddress;
  final String broadcastAddress;
  final String firstUsableIp;
  final String lastUsableIp;
  final int totalHosts;

  SubnetInfo({
    required this.networkAddress,
    required this.broadcastAddress,
    required this.firstUsableIp,
    required this.lastUsableIp,
    required this.totalHosts,
  });
}

List<SubnetInfo> calculateSubnets(
    String baseIp, int baseMask, int numberOfSubnets) {
  // Basic validation
  final parts = baseIp.split('.');
  if (parts.length != 4) return [];
  final ip = parts.map(int.parse).toList();
  if (ip.any((v) => v < 0 || v > 255)) return [];
  if (baseMask < 0 || baseMask > 32) return [];
  if (numberOfSubnets < 1) return [];

  final totalHosts = (1 << (32 - baseMask)) - 2;
  final hostsPerSubnet = totalHosts ~/ numberOfSubnets;
  final subnets = <SubnetInfo>[];
  int base = (ip[0] << 24) | (ip[1] << 16) | (ip[2] << 8) | ip[3];
  int increment = hostsPerSubnet + 2;

  for (int i = 0; i < numberOfSubnets; i++) {
    int subnetBase = base + (i * increment);
    int subnetBroadcast = subnetBase + increment - 1;
    int firstUsable = subnetBase + 1;
    int lastUsable = subnetBroadcast - 1;
    subnets.add(SubnetInfo(
      networkAddress: _intToIp(subnetBase),
      broadcastAddress: _intToIp(subnetBroadcast),
      firstUsableIp: _intToIp(firstUsable),
      lastUsableIp: _intToIp(lastUsable),
      totalHosts: hostsPerSubnet,
    ));
  }
  return subnets;
}

String _intToIp(int val) {
  return '${(val >> 24) & 0xFF}.${(val >> 16) & 0xFF}.${(val >> 8) & 0xFF}.${val & 0xFF}';
}
