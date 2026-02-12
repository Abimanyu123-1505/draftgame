import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/network_node.dart';
import '../services/infection_engine.dart';

enum MissionState { briefing, active, contained, success, failed }

enum PlayerAlignment { unknown, leakEvidence, deleteLogs, copySecretly }

class NetworkState {
  NetworkState({
    required this.nodes,
    this.logs = '',
    this.remainingSeconds = 300,
    this.missionState = MissionState.briefing,
    this.playerAlignment = PlayerAlignment.unknown,
    this.correctResponseChain = 0,
    this.totalCritical = 2,
  });

  final List<NetworkNode> nodes;
  final String logs;
  final int remainingSeconds;
  final MissionState missionState;
  final PlayerAlignment playerAlignment;
  final int correctResponseChain;
  final int totalCritical;

  NetworkState copyWith({
    List<NetworkNode>? nodes,
    String? logs,
    int? remainingSeconds,
    MissionState? missionState,
    PlayerAlignment? playerAlignment,
    int? correctResponseChain,
    int? totalCritical,
  }) {
    return NetworkState(
      nodes: nodes ?? this.nodes,
      logs: logs ?? this.logs,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      missionState: missionState ?? this.missionState,
      playerAlignment: playerAlignment ?? this.playerAlignment,
      correctResponseChain: correctResponseChain ?? this.correctResponseChain,
      totalCritical: totalCritical ?? this.totalCritical,
    );
  }
}

class NetworkNotifier extends StateNotifier<NetworkState> {
  NetworkNotifier()
      : super(
          NetworkState(nodes: _buildInitialNodes()),
        );

  static List<NetworkNode> _buildInitialNodes() {
    return [
      NetworkNode(id: 'PC-01', isCritical: false, connections: ['PC-02', 'AUTH-SERVER']),
      NetworkNode(id: 'PC-02', isCritical: false, connections: ['PC-01', 'GATEWAY']),
      NetworkNode(id: 'AUTH-SERVER', isCritical: true, connections: ['PC-01', 'FINANCE-DB']),
      NetworkNode(id: 'FINANCE-DB', isCritical: true, connections: ['AUTH-SERVER', 'GATEWAY']),
      NetworkNode(id: 'GATEWAY', isCritical: false, connections: ['PC-02', 'FINANCE-DB']),
    ];
  }

  InfectionEngine? _engine;
  Timer? _countdown;

  void startMission() {
    _engine ??= InfectionEngine(state.nodes);
    state = state.copyWith(missionState: MissionState.active, logs: '[INIT] Monitoring network...');

    _engine!.start((result) {
      state = state.copyWith(nodes: result.nodes, logs: result.log);

      if (result.isFailure) {
        failMission('[FAILURE] Two critical systems are compromised.');
      } else if (result.contained) {
        containMission();
      }
    });

    _countdown?.cancel();
    _countdown = Timer.periodic(const Duration(seconds: 1), (_) {
      final left = state.remainingSeconds - 1;
      if (left <= 0) {
        failMission('[FAILURE] Response window expired.');
      } else {
        state = state.copyWith(remainingSeconds: left);
      }
    });
  }

  void scanNode(String id) {
    final node = _findNode(id);
    final detected = node.scan();
    state = state.copyWith(
      logs: detected
          ? '[SCAN] ${node.id}: suspicious behavior confirmed.'
          : '[SCAN] ${node.id}: clear at current threshold.',
      correctResponseChain: 1,
    );
  }

  void isolateNode(String id) {
    final node = _findNode(id);
    node.isolate();

    final expected = state.correctResponseChain == 1;
    _applyResponsePenalty(expected);
    state = state.copyWith(
      logs: '[ACTION] ${node.id} moved to quarantine VLAN.',
      correctResponseChain: expected ? 2 : 0,
    );
  }

  void rollbackNode(String id) {
    final node = _findNode(id);
    final expected = state.correctResponseChain == 2;

    node.rollback();
    _applyResponsePenalty(expected);

    state = state.copyWith(
      logs: '[ACTION] ${node.id} rollback image deployed.',
      correctResponseChain: expected ? 3 : 0,
    );

    final infectedAny = state.nodes.any((n) => n.isInfected);
    if (!infectedAny && state.nodes.any((n) => n.encryptionEvents > 0)) {
      containMission();
    }
  }

  void chooseAlignment(PlayerAlignment alignment) {
    state = state.copyWith(
      playerAlignment: alignment,
      missionState: MissionState.success,
    );
  }

  void containMission() {
    if (state.missionState != MissionState.active &&
        state.missionState != MissionState.contained) {
      return;
    }
    _engine?.stop();
    _countdown?.cancel();
    state = state.copyWith(
      missionState: MissionState.contained,
      logs: 'Budget fraud simulation module active.',
    );
  }

  void failMission(String reason) {
    _engine?.stop();
    _countdown?.cancel();
    state = state.copyWith(
      missionState: MissionState.failed,
      logs: reason,
    );
  }

  void restart() {
    _engine?.stop();
    _countdown?.cancel();
    _engine = null;
    state = NetworkState(nodes: _buildInitialNodes());
  }

  int containmentPercent() {
    final total = state.nodes.length;
    final clean = state.nodes.where((n) => !n.isInfected).length;
    return ((clean / total) * 100).round();
  }

  int criticalSaved() {
    return state.nodes.where((n) => n.isCritical && !n.isInfected).length;
  }

  NetworkNode _findNode(String id) {
    return state.nodes.firstWhere((node) => node.id == id);
  }

  void _applyResponsePenalty(bool expectedOrder) {
    if (expectedOrder) {
      return;
    }

    for (final node in state.nodes.where((n) => n.isInfected && !n.isIsolated)) {
      node.encryptionEvents += 20;
      node.suspiciousProcess = true;
    }

    state = state.copyWith(logs: '[WARN] Incorrect sequence accelerated threat spread.');
  }

  @override
  void dispose() {
    _engine?.stop();
    _countdown?.cancel();
    super.dispose();
  }
}

final networkProvider =
    StateNotifierProvider<NetworkNotifier, NetworkState>((ref) => NetworkNotifier());
