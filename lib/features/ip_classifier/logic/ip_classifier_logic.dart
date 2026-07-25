class IpClassResult {
  final String ipClass;
  final bool isPrivate;
  final String description;
  IpClassResult(
      {required this.ipClass,
      required this.isPrivate,
      required this.description});
}

IpClassResult classifyIp(String ip) {
  final parts = ip.split('.');
  if (parts.length != 4) {
    return IpClassResult(
        ipClass: 'Invalid', isPrivate: false, description: 'Invalid IP');
  }
  final first = int.tryParse(parts[0]) ?? -1;
  final second = int.tryParse(parts[1]) ?? -1;
  if (first < 0 || first > 255 || second < 0 || second > 255) {
    return IpClassResult(
        ipClass: 'Invalid', isPrivate: false, description: 'Invalid IP');
  }
  if (first < 128) {
    final isPrivate = first == 10;
    return IpClassResult(
        ipClass: 'A',
        isPrivate: isPrivate,
        description: isPrivate ? 'Private (10.0.0.0/8)' : 'Public');
  } else if (first < 192) {
    final isPrivate = first == 172 && (second >= 16 && second <= 31);
    return IpClassResult(
        ipClass: 'B',
        isPrivate: isPrivate,
        description: isPrivate ? 'Private (172.16.0.0/12)' : 'Public');
  } else if (first < 224) {
    final isPrivate = first == 192 && second == 168;
    return IpClassResult(
        ipClass: 'C',
        isPrivate: isPrivate,
        description: isPrivate ? 'Private (192.168.0.0/16)' : 'Public');
  } else if (first < 240) {
    return IpClassResult(
        ipClass: 'D', isPrivate: false, description: 'Multicast');
  } else {
    return IpClassResult(
        ipClass: 'E', isPrivate: false, description: 'Reserved');
  }
}
