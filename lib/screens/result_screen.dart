import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/network_provider.dart';
import 'story_screen.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(networkProvider);
    final notifier = ref.read(networkProvider.notifier);

    final failed = state.missionState == MissionState.failed;
    final alignmentText = switch (state.playerAlignment) {
      PlayerAlignment.leakEvidence => 'Leak Evidence',
      PlayerAlignment.deleteLogs => 'Delete Logs',
      PlayerAlignment.copySecretly => 'Copy Secretly',
      _ => 'Undecided',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Mission Result')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              failed ? 'FAILURE' : 'VICTORY',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text('Containment %: ${notifier.containmentPercent()}'),
            Text('Critical Nodes Saved: ${notifier.criticalSaved()}/${state.totalCritical}'),
            Text('Alignment Choice: $alignmentText'),
            const SizedBox(height: 10),
            Text(state.logs),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  notifier.restart();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const StoryScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Restart Mission'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
