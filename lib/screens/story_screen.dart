import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/network_provider.dart';
import 'network_map_screen.dart';

class StoryScreen extends ConsumerWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Silent Breach // Briefing')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unknown Contact:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            const Text('“Helix Dynamics staged fake ransomware attacks.”'),
            const SizedBox(height: 10),
            const Text('“Tonight it’s real.”'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(networkProvider.notifier).startMission();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const NetworkMapScreen()),
                  );
                },
                child: const Text('Begin Investigation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
