import 'package:flutter/material.dart';

import 'schemas.dart';

/// One session: a time block on the left, details on the right.
class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final (roomBg, roomFg) = roomColors(scheme, session.room);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 84,
              color: roomBg,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'DAY ${session.day}',
                    style: text.labelSmall?.copyWith(
                      color: roomFg,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    session.startTime,
                    style: text.titleMedium?.copyWith(
                      color: roomFg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    session.endTime,
                    style: text.bodySmall?.copyWith(
                      color: roomFg.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                    if (session.speaker.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _IconLine(
                        icon: Icons.person_outline_rounded,
                        label: session.speaker,
                      ),
                    ],
                    const SizedBox(height: 4),
                    _IconLine(icon: Icons.place_outlined, label: session.room),
                    if (session.tags.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final tag in session.tags.take(3))
                            _TagPill(tag: tag),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Each room gets its own colour, so parallel talks are easy to tell apart.
(Color, Color) roomColors(ColorScheme scheme, String room) => switch (room) {
  'Auditorium' => (scheme.primaryContainer, scheme.onPrimaryContainer),
  'Visual Spaces' => (scheme.tertiaryContainer, scheme.onTertiaryContainer),
  _ => (scheme.secondaryContainer, scheme.onSecondaryContainer),
};

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '#$tag',
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: scheme.onSurfaceVariant),
      ),
    );
  }
}
