import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/network_provider.dart';

class NodeAnalysisScreen extends ConsumerWidget {
  const NodeAnalysisScreen({super.key, required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(networkProvider);
    final node = state.nodes.firstWhere((n) => n.id == nodeId);

    return Scaffold(
      appBar: AppBar(title: Text('Node Analysis // ${node.id}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _line('CPU Usage', '${node.cpuUsage}%'),
            _line('Encryption Events', '${node.encryptionEvents}'),
            _line('Suspicious Process', node.suspiciousProcess ? 'YES' : 'NO'),
            _line('Infected', node.isInfected ? 'YES' : 'NO'),
            _line('Isolated', node.isIsolated ? 'YES' : 'NO'),
            const SizedBox(height: 16),
            Text(state.logs),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(networkProvider.notifier).scanNode(node.id);
                    },
                    child: const Text('Scan'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(networkProvider.notifier).isolateNode(node.id);
                    },
                    child: const Text('Isolate'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(networkProvider.notifier).rollbackNode(node.id);
                    },
                    child: const Text('Rollback'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text('$label: $value'),
    );
  }
}
