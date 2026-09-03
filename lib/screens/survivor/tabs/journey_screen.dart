import 'package:flutter/material.dart';
import '../../../app/app.dart';
import '../../../models/daily_reflection.dart';
import '../../../models/recovery_activity.dart';
import '../../../models/recovery_state.dart';
import '../reflection_detail_screen.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final reflections = ReflectionScope.of(context);
    final allReflections = reflections.allReflections;
    final recovery = RecoveryStateScope.of(context).state;
    final history = ActivityHistoryScope.of(context);
    final completed = history.completedActivities;

    final hasAnyData = allReflections.isNotEmpty || completed.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text('Your Journey', style: theme.textTheme.displaySmall),
              const SizedBox(height: 4),
              Text(
                'Your recovery is personal. Notice your progress at your own pace.',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: cs.onSurface.withAlpha(160)),
              ),
              const SizedBox(height: 10),
              _NonLinearCard(cs: cs, theme: theme),
              const SizedBox(height: 20),

              if (!hasAnyData) ...[
                _EmptyState(cs: cs, theme: theme),
              ] else ...[
                // Overview stats
                _OverviewSection(
                  reflectionCount: allReflections.length,
                  activityCount: history.totalCompleted,
                  confidence: recovery.confidence,
                  connection: recovery.socialConnection,
                  cs: cs,
                  theme: theme,
                ),
                const SizedBox(height: 24),

                // Mood history
                _MoodHistorySection(
                  reflections: allReflections,
                  cs: cs,
                  theme: theme,
                ),
                const SizedBox(height: 24),

                // Confidence & connection
                _ScoreHistorySection(
                  reflections: allReflections,
                  cs: cs,
                  theme: theme,
                ),
                const SizedBox(height: 24),

                // Check-in timeline
                _CheckInTimeline(
                  reflections: allReflections.take(10).toList(),
                  cs: cs,
                  theme: theme,
                ),
                const SizedBox(height: 24),

                // Completed activities
                _CompletedActivitiesSection(
                  completed: completed.take(10).toList(),
                  cs: cs,
                  theme: theme,
                ),
                const SizedBox(height: 24),

                // Milestones
                _MilestonesSection(
                  reflections: allReflections,
                  activityCount: history.totalCompleted,
                  cs: cs,
                  theme: theme,
                ),
                const SizedBox(height: 24),

                // Voice reflections
                _VoiceReflectionsSection(cs: cs, theme: theme),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Non-linear recovery card ──────────────────────────────────────────────────

class _NonLinearCard extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _NonLinearCard({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(60),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.primary.withAlpha(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite_border_rounded,
                  size: 16, color: cs.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Recovery isn\'t a straight line. Every small step matters.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: cs.primary, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Your journey can have quiet days, difficult days, and hopeful days. '
            'That doesn\'t erase the steps you\'ve already taken. '
            'Move at a pace that feels right for you.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(160), height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _EmptyState({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.primary.withAlpha(20)),
      ),
      child: Column(
        children: [
          Icon(Icons.timeline_rounded, size: 56, color: cs.primary.withAlpha(120)),
          const SizedBox(height: 20),
          Text(
            'Your journey starts whenever you\'re ready.',
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Your check-ins and recovery steps will appear here over time.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: cs.onSurface.withAlpha(150)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _switchTab(context, 1),
              icon: const Icon(Icons.edit_note_rounded),
              label: const Text('Do a Check-in'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _switchTab(context, 2),
              icon: const Icon(Icons.self_improvement_rounded),
              label: const Text('Explore Recovery Activities'),
            ),
          ),
        ],
      ),
    );
  }

  void _switchTab(BuildContext context, int index) {
    // Walk up to find the SurvivorShell state and switch tab
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold == null) return;
    // Use the NavigationBar via the shell — navigate by popping to shell
    // The shell owns tab state; we trigger via a simple Navigator pop approach
    // Since Journey is tab 3, we can't directly call shell setState here.
    // Instead we show a snackbar guiding the user — the shell handles tab switching.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(index == 1
            ? 'Tap "Reflect" in the bottom navigation to start a check-in.'
            : 'Tap "Recover" in the bottom navigation to explore activities.'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ── Overview stats ────────────────────────────────────────────────────────────

class _OverviewSection extends StatelessWidget {
  final int reflectionCount;
  final int activityCount;
  final int confidence;
  final int connection;
  final ColorScheme cs;
  final ThemeData theme;

  const _OverviewSection({
    required this.reflectionCount,
    required this.activityCount,
    required this.confidence,
    required this.connection,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Overview', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.edit_note_rounded,
                value: '$reflectionCount',
                label: reflectionCount == 1 ? 'Check-in' : 'Check-ins',
                cs: cs,
                theme: theme,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                icon: Icons.eco_rounded,
                value: '$activityCount',
                label: activityCount == 1 ? 'Activity' : 'Activities',
                cs: cs,
                theme: theme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.shield_outlined,
                value: '$confidence/5',
                label: 'Confidence',
                cs: cs,
                theme: theme,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                icon: Icons.people_outline_rounded,
                value: '$connection/5',
                label: 'Connection',
                cs: cs,
                theme: theme,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final ColorScheme cs;
  final ThemeData theme;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withAlpha(20)),
        boxShadow: [
          BoxShadow(
              color: cs.primary.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: cs.primary),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontSize: 20, color: cs.primary)),
              Text(label,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: cs.onSurface.withAlpha(150), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Mood history ──────────────────────────────────────────────────────────────

class _MoodHistorySection extends StatelessWidget {
  final List<DailyReflection> reflections;
  final ColorScheme cs;
  final ThemeData theme;

  const _MoodHistorySection({
    required this.reflections,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final moodReflections =
        reflections.where((r) => r.mood != null).take(14).toList().reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent mood pattern', style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'Your check-in ratings — not a score or judgement.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withAlpha(150)),
        ),
        const SizedBox(height: 12),
        if (moodReflections.length < 2)
          _JourneyCard(
            cs: cs,
            child: Text(
              'Your mood patterns will appear here as you check in over time.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurface.withAlpha(150)),
            ),
          )
        else
          _JourneyCard(
            cs: cs,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: moodReflections.map((r) {
                      final moodVal = _moodValue(r.mood!);
                      final barH = 16.0 + (moodVal / 6.0) * 56.0;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Tooltip(
                            message:
                                '${r.mood!.emoji} ${r.mood!.label}\n${_shortDate(r.dateTime)}',
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(r.mood!.emoji,
                                    style: const TextStyle(fontSize: 11)),
                                const SizedBox(height: 2),
                                Container(
                                  height: barH,
                                  decoration: BoxDecoration(
                                    color: _moodColor(r.mood!, cs),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Each bar represents one check-in. Tap a bar to see details.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11, color: cs.onSurface.withAlpha(120)),
                ),
              ],
            ),
          ),
      ],
    );
  }

  int _moodValue(CheckInMood mood) {
    switch (mood) {
      case CheckInMood.good:
        return 6;
      case CheckInMood.okay:
        return 5;
      case CheckInMood.low:
        return 3;
      case CheckInMood.stressed:
        return 2;
      case CheckInMood.anxious:
        return 2;
      case CheckInMood.overwhelmed:
        return 1;
    }
  }

  Color _moodColor(CheckInMood mood, ColorScheme cs) {
    switch (mood) {
      case CheckInMood.good:
        return const Color(0xFF81C784);
      case CheckInMood.okay:
        return const Color(0xFFB39DDB);
      case CheckInMood.low:
        return const Color(0xFF90CAF9);
      case CheckInMood.stressed:
        return const Color(0xFFFFB74D);
      case CheckInMood.anxious:
        return const Color(0xFFFFCC80);
      case CheckInMood.overwhelmed:
        return const Color(0xFFEF9A9A);
    }
  }

  String _shortDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}

// ── Confidence & connection history ──────────────────────────────────────────

class _ScoreHistorySection extends StatelessWidget {
  final List<DailyReflection> reflections;
  final ColorScheme cs;
  final ThemeData theme;

  const _ScoreHistorySection({
    required this.reflections,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final withConf =
        reflections.where((r) => r.confidence != null).take(7).toList().reversed.toList();
    final withConn = reflections
        .where((r) => r.socialConnection != null)
        .take(7)
        .toList()
        .reversed
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your check-in ratings', style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'These are your own ratings — not clinical scores.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withAlpha(150)),
        ),
        const SizedBox(height: 12),
        _JourneyCard(
          cs: cs,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RatingRow(
                label: 'Confidence',
                icon: Icons.shield_outlined,
                entries: withConf
                    .map((r) => _RatingEntry(
                          date: r.dateTime,
                          value: r.confidence!,
                        ))
                    .toList(),
                color: cs.primary,
                cs: cs,
                theme: theme,
              ),
              if (withConf.isNotEmpty && withConn.isNotEmpty)
                const SizedBox(height: 16),
              _RatingRow(
                label: 'Social connection',
                icon: Icons.people_outline_rounded,
                entries: withConn
                    .map((r) => _RatingEntry(
                          date: r.dateTime,
                          value: r.socialConnection!,
                        ))
                    .toList(),
                color: const Color(0xFF64B5F6),
                cs: cs,
                theme: theme,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RatingEntry {
  final DateTime date;
  final int value;
  const _RatingEntry({required this.date, required this.value});
}

class _RatingRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<_RatingEntry> entries;
  final Color color;
  final ColorScheme cs;
  final ThemeData theme;

  const _RatingRow({
    required this.label,
    required this.icon,
    required this.entries,
    required this.color,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Row(
        children: [
          Icon(icon, size: 16, color: cs.onSurface.withAlpha(120)),
          const SizedBox(width: 8),
          Text('$label — no data yet',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurface.withAlpha(150))),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(label,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: entries.map((e) {
            final barH = 8.0 + (e.value / 5.0) * 36.0;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Tooltip(
                  message: '${e.value}/5',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${e.value}',
                          style: TextStyle(
                              fontSize: 10,
                              color: color,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Container(
                        height: barH,
                        decoration: BoxDecoration(
                          color: color.withAlpha(180),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Check-in timeline ─────────────────────────────────────────────────────────

class _CheckInTimeline extends StatelessWidget {
  final List<DailyReflection> reflections;
  final ColorScheme cs;
  final ThemeData theme;

  const _CheckInTimeline({
    required this.reflections,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Check-in history', style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'Your recent reflections.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withAlpha(150)),
        ),
        const SizedBox(height: 12),
        if (reflections.isEmpty)
          _JourneyCard(
            cs: cs,
            child: Text(
              'No reflections yet. Your check-ins will appear here when you\'re ready.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurface.withAlpha(150)),
            ),
          )
        else
          _JourneyCard(
            cs: cs,
            child: Column(
              children: reflections
                  .asMap()
                  .entries
                  .map((e) => _TimelineItem(
                        reflection: e.value,
                        isLast: e.key == reflections.length - 1,
                        cs: cs,
                        theme: theme,
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final DailyReflection reflection;
  final bool isLast;
  final ColorScheme cs;
  final ThemeData theme;

  const _TimelineItem({
    required this.reflection,
    required this.isLast,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ReflectionDetailScreen(reflection: reflection),
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline dot + line
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: cs.primary.withAlpha(40),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _formatDate(reflection.dateTime),
                        style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      if (reflection.mood != null)
                        Text(
                          '${reflection.mood!.emoji} ${reflection.mood!.label}',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontSize: 13),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (reflection.confidence != null)
                        _MiniChip(
                          label:
                              'Confidence ${reflection.confidence}/5',
                          cs: cs,
                          theme: theme,
                        ),
                      if (reflection.confidence != null &&
                          reflection.socialConnection != null)
                        const SizedBox(width: 6),
                      if (reflection.socialConnection != null)
                        _MiniChip(
                          label:
                              'Connection ${reflection.socialConnection}/5',
                          cs: cs,
                          theme: theme,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Tap to view',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            color: cs.primary.withAlpha(160)),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: cs.primary.withAlpha(160)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final ColorScheme cs;
  final ThemeData theme;

  const _MiniChip(
      {required this.label, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 11, color: cs.primary)),
    );
  }
}

// ── Completed activities ──────────────────────────────────────────────────────

class _CompletedActivitiesSection extends StatelessWidget {
  final List<dynamic> completed;
  final ColorScheme cs;
  final ThemeData theme;

  const _CompletedActivitiesSection({
    required this.completed,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Steps you\'ve taken', style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'These are the steps you\'ve chosen for yourself.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withAlpha(150)),
        ),
        const SizedBox(height: 12),
        if (completed.isEmpty)
          _JourneyCard(
            cs: cs,
            child: Text(
              'No activities completed yet. Explore the Recover tab whenever you\'re ready.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurface.withAlpha(150)),
            ),
          )
        else
          _JourneyCard(
            cs: cs,
            child: Column(
              children: completed
                  .map((c) => _ActivityHistoryItem(
                        item: c,
                        cs: cs,
                        theme: theme,
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _ActivityHistoryItem extends StatelessWidget {
  final dynamic item;
  final ColorScheme cs;
  final ThemeData theme;

  const _ActivityHistoryItem(
      {required this.item, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    final ActivityCategory cat = item.category as ActivityCategory;
    final catColor = cat.color;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: catColor.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(cat.icon, size: 18, color: catColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title as String,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: catColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(cat.label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 11,
                              color: catColor,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(item.completedAt as DateTime),
                      style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 11,
                          color: cs.onSurface.withAlpha(130)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle_outline_rounded,
              size: 18, color: cs.primary.withAlpha(160)),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}

// ── Milestones ────────────────────────────────────────────────────────────────

class _MilestonesSection extends StatelessWidget {
  final List<DailyReflection> reflections;
  final int activityCount;
  final ColorScheme cs;
  final ThemeData theme;

  const _MilestonesSection({
    required this.reflections,
    required this.activityCount,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final milestones = _buildMilestones();
    if (milestones.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Something you chose to do', style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'Moments in your journey worth noticing.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withAlpha(150)),
        ),
        const SizedBox(height: 12),
        _JourneyCard(
          cs: cs,
          child: Column(
            children: milestones
                .map((m) => _MilestoneItem(
                      milestone: m,
                      cs: cs,
                      theme: theme,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  List<_Milestone> _buildMilestones() {
    final list = <_Milestone>[];
    if (reflections.isNotEmpty) {
      list.add(const _Milestone(
        icon: Icons.edit_note_rounded,
        title: 'Your first reflection',
        description: 'You took a moment to check in with yourself.',
      ));
    }
    if (reflections.any((r) => r.journalText != null && r.journalText!.trim().isNotEmpty)) {
      list.add(const _Milestone(
        icon: Icons.book_outlined,
        title: 'First journal entry',
        description: 'You wrote something just for yourself.',
      ));
    }
    if (activityCount >= 1) {
      list.add(const _Milestone(
        icon: Icons.eco_rounded,
        title: 'First recovery activity',
        description: 'Another step in your journey.',
      ));
    }
    if (activityCount >= 3) {
      list.add(const _Milestone(
        icon: Icons.star_outline_rounded,
        title: 'Three activities completed',
        description: 'You\'ve made time for yourself more than once.',
      ));
    }
    if (reflections.length >= 3) {
      list.add(const _Milestone(
        icon: Icons.timeline_rounded,
        title: 'Three check-ins',
        description: 'You\'ve been showing up for yourself.',
      ));
    }
    return list;
  }
}

class _Milestone {
  final IconData icon;
  final String title;
  final String description;
  const _Milestone(
      {required this.icon,
      required this.title,
      required this.description});
}

class _MilestoneItem extends StatelessWidget {
  final _Milestone milestone;
  final ColorScheme cs;
  final ThemeData theme;

  const _MilestoneItem(
      {required this.milestone, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(milestone.icon, size: 20, color: cs.secondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(milestone.title,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text(milestone.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withAlpha(150))),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded,
              size: 20, color: cs.primary.withAlpha(180)),
        ],
      ),
    );
  }
}

// ── Voice reflections ────────────────────────────────────────────────────────

class _VoiceReflectionsSection extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _VoiceReflectionsSection({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    final voice = VoiceReflectionScope.of(context);
    final saved = voice.savedReflections;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Voice Reflections', style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'Private to you. Session-only storage.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withAlpha(150)),
        ),
        const SizedBox(height: 12),
        _JourneyCard(
          cs: cs,
          child: saved.isEmpty
              ? Text(
                  'No voice reflections recorded yet. '
                  'You can record one from the Reflect tab.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: cs.onSurface.withAlpha(150)),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${saved.length} voice reflection${saved.length == 1 ? '' : 's'} this session.',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600, color: cs.primary),
                    ),
                    const SizedBox(height: 10),
                    ...saved.map((r) {
                      const months = [
                        'Jan','Feb','Mar','Apr','May','Jun',
                        'Jul','Aug','Sep','Oct','Nov','Dec'
                      ];
                      final dt = r.createdAt;
                      final label =
                          '${dt.day} ${months[dt.month - 1]}, '
                          '${dt.hour.toString().padLeft(2, '0')}:'
                          '${dt.minute.toString().padLeft(2, '0')}';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.mic_rounded,
                                size: 18, color: cs.primary.withAlpha(160)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '$label  •  ${r.durationLabel}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              'Session only',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 11,
                                  color: cs.onSurface.withAlpha(120),
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
        ),
      ],
    );
  }
}

// ── Shared card ───────────────────────────────────────────────────────────────

class _JourneyCard extends StatelessWidget {
  final Widget child;
  final ColorScheme cs;

  const _JourneyCard({required this.child, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.primary.withAlpha(20)),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
