import 'package:flutter/material.dart';

import '../models/network_node.dart';
import '../theme/app_theme.dart';

class NodeCard extends StatefulWidget {
  const NodeCard({
    super.key,
    required this.node,
    required this.onTap,
  });

  final NetworkNode node;
  final VoidCallback onTap;

  @override
  State<NodeCard> createState() => _NodeCardState();
}

class _NodeCardState extends State<NodeCard> with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.2,
      upperBound: 0.9,
    );
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant NodeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    if (widget.node.isInfected) {
      _glowController.repeat(reverse: true);
    } else {
      _glowController.stop();
      _glowController.value = 0.2;
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Color _statusColor() {
    if (widget.node.isIsolated) return AppTheme.isolated;
    if (widget.node.isInfected) return AppTheme.infected;
    if (widget.node.suspiciousProcess) return AppTheme.suspicious;
    return AppTheme.safe;
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Card(
          elevation: 2,
          shadowColor: widget.node.isInfected
              ? AppTheme.infected.withValues(alpha: _glowController.value)
              : Colors.black54,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.node.id,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    widget.node.isCritical ? 'CRITICAL' : 'USER',
                    style: TextStyle(
                      color: widget.node.isCritical ? AppTheme.infected : Colors.white70,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
