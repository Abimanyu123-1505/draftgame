import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/network_provider.dart';
import 'result_screen.dart';

class DecisionScreen extends ConsumerWidget {
  const DecisionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(networkProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Moral Decision')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('“Budget fraud simulation module active.”'),
            const SizedBox(height: 12),
            Text(state.logs),
            const Spacer(),
            _option(
              context,
              ref,
              title: 'Leak Evidence',
              alignment: PlayerAlignment.leakEvidence,
            ),
            _option(
              context,
              ref,
              title: 'Delete Logs',
              alignment: PlayerAlignment.deleteLogs,
            ),
            _option(
              context,
              ref,
              title: 'Copy Secretly',
              alignment: PlayerAlignment.copySecretly,
            ),
          ],
        ),
      ),
    );
  }

  Widget _option(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required PlayerAlignment alignment,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            ref.read(networkProvider.notifier).chooseAlignment(alignment);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ResultScreen()),
            );
          },
          child: Text(title),
        ),
      ),
    );
  }
}
