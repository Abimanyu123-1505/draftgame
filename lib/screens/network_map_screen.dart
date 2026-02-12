import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/network_provider.dart';
import '../widgets/node_card.dart';
import 'decision_screen.dart';
import 'node_analysis_screen.dart';
import 'result_screen.dart';

class NetworkMapScreen extends ConsumerStatefulWidget {
  const NetworkMapScreen({super.key});

  @override
  ConsumerState<NetworkMapScreen> createState() => _NetworkMapScreenState();
}

class _NetworkMapScreenState extends ConsumerState<NetworkMapScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<NetworkState>(networkProvider, (previous, next) {
      if (next.missionState == MissionState.failed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ResultScreen()),
        );
      }
      if (next.missionState == MissionState.contained) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DecisionScreen()),
        );
      }
    });

    final state = ref.watch(networkProvider);
    final minutes = (state.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (state.remainingSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Telemetry'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('T-$minutes:$seconds', style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(state.logs),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: state.nodes.length,
              itemBuilder: (context, index) {
                final node = state.nodes[index];
                return NodeCard(
                  node: node,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NodeAnalysisScreen(nodeId: node.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
