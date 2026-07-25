List<String> calculateIpRange(String startIp, String endIp) {
  List<String> result = [];
  try {
    List<int> start = startIp.split('.').map(int.parse).toList();
    List<int> end = endIp.split('.').map(int.parse).toList();
    if (start.length != 4 || end.length != 4) return result;
    int startInt =
        (start[0] << 24) | (start[1] << 16) | (start[2] << 8) | start[3];
    int endInt = (end[0] << 24) | (end[1] << 16) | (end[2] << 8) | end[3];
    if (startInt > endInt) return result;
    for (int i = startInt; i <= endInt && result.length < 1000; i++) {
      result.add(
          '${(i >> 24) & 255}.${(i >> 16) & 255}.${(i >> 8) & 255}.${i & 255}');
    }
  } catch (_) {}
  return result;
}
