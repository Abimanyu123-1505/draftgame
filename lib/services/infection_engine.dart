import 'dart:async';
import 'dart:math';

import '../models/network_node.dart';

class InfectionTickResult {
  InfectionTickResult({
    required this.nodes,
    required this.log,
    required this.contained,
    required this.isFailure,
  });

  final List<NetworkNode> nodes;
  final String log;
  final bool contained;
  final bool isFailure;
}

class InfectionEngine {
  InfectionEngine(this._nodes) : _rng = Random(77);

  final List<NetworkNode> _nodes;
  final Random _rng;
  Timer? _timer;

  static const Duration tickInterval = Duration(seconds: 5);

  void start(void Function(InfectionTickResult result) onTick) {
    _timer?.cancel();
    _timer = Timer.periodic(tickInterval, (_) {
      final result = _runSimulationTick();
      onTick(result);
    });
  }

  void stop() {
    _timer?.cancel();
  }

  InfectionTickResult _runSimulationTick() {
    final logs = <String>[];

    for (final node in _nodes) {
      if (node.isIsolated) {
        continue;
      }

      final baseSpike = _rng.nextInt(12);
      final pressure = node.isInfected ? 18 : 0;
      node.encryptionEvents += baseSpike + pressure;
      node.cpuUsage = (node.cpuUsage + _rng.nextInt(20)).clamp(10, 100);

      if (node.encryptionEvents > 25) {
        node.suspiciousProcess = true;
      }

      if (node.encryptionEvents > 50 && node.suspiciousProcess) {
        if (!node.isInfected) {
          logs.add('[ALERT] ${node.id} compromised.');
        }
        node.isInfected = true;
      }

      if (node.isInfected && !node.isIsolated && node.connections.isNotEmpty) {
        final randomConnection = node.connections[_rng.nextInt(node.connections.length)];
        final target = _nodes.firstWhere((n) => n.id == randomConnection);
        if (!target.isIsolated) {
          target.encryptionEvents += 30;
          target.suspiciousProcess = true;
          logs.add('[SPREAD] ${node.id} -> ${target.id}');
        }
      }
    }

    final infectedCritical =
        _nodes.where((node) => node.isCritical && node.isInfected).length;
    final infectedAny = _nodes.where((node) => node.isInfected).length;
    final contained = infectedAny == 0 &&
        _nodes.where((node) => node.encryptionEvents > 0).isNotEmpty;

    final failed = infectedCritical >= 2;

    final stateDump = _nodes
        .map(
          (n) =>
              '${n.id}(enc=${n.encryptionEvents},sus=${n.suspiciousProcess},inf=${n.isInfected},iso=${n.isIsolated})',
        )
        .join(' | ');
    // ignore: avoid_print
    print('[DEBUG][TICK] $stateDump');

    return InfectionTickResult(
      nodes: _nodes,
      log: logs.isEmpty ? '[SCAN] No immediate spread events.' : logs.join('\n'),
      contained: contained,
      isFailure: failed,
    );
  }
}
