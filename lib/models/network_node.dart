class NetworkNode {
  NetworkNode({
    required this.id,
    required this.isCritical,
    this.isInfected = false,
    this.suspiciousProcess = false,
    this.encryptionEvents = 0,
    this.cpuUsage = 10,
    this.isIsolated = false,
    this.connections = const [],
  });

  final String id;
  final bool isCritical;
  bool isInfected;
  bool suspiciousProcess;
  int encryptionEvents;
  int cpuUsage;
  bool isIsolated;
  final List<String> connections;

  void infect() {
    isInfected = true;
    suspiciousProcess = true;
    encryptionEvents = encryptionEvents < 60 ? 60 : encryptionEvents;
    cpuUsage = cpuUsage < 85 ? 85 : cpuUsage;
  }

  void isolate() {
    isIsolated = true;
  }

  void rollback() {
    encryptionEvents = 0;
    isInfected = false;
    suspiciousProcess = false;
    cpuUsage = 15;
  }

  bool scan() {
    return suspiciousProcess || isInfected || encryptionEvents > 20;
  }
}
