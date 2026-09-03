import 'package:flutter/material.dart';
import '../../../app/app.dart';
import '../../../models/daily_reflection.dart';
import '../../../models/recovery_state.dart';
import 'check_in_flow.dart';
import 'voice_reflection_screen.dart';

class ReflectLanding extends StatelessWidget {
  final VoidCallback onGoHome;
  const ReflectLanding({super.key, required this.onGoHome});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final reflections =
        ReflectionScope.of(context).getRecentReflections();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text('Take a moment to reflect',
                  style: theme.textTheme.displaySmall),
              const SizedBox(height: 8),
              Text(
                'You don\'t need to have the right words. Just notice how you\'re feeling.',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: cs.onSurface.withAlpha(160), height: 1.6),
              ),
              const SizedBox(height: 16),

              // Privacy note
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withAlpha(80),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.primary.withAlpha(30)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline_rounded,
                        size: 16, color: cs.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your reflection stays private unless you choose otherwise.',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: cs.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Start button
              ElevatedButton(
                onPressed: () => _startCheckIn(context),
                child: const Text('Start today\'s check-in'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.maybePop(context),
                child: Text('Maybe later',
                    style: TextStyle(
                        color: cs.onSurface.withAlpha(150))),
              ),
              const SizedBox(height: 24),

              // Voice reflection card
              _VoiceReflectionCard(cs: cs, theme: theme),
              const SizedBox(height: 32),

              // Recent reflections
              Text('Your recent reflections',
                  style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              if (reflections.isEmpty) ...[
                _EmptyReflections(cs: cs, theme: theme),
              ] else ...[
                ...reflections.map((r) =>
                    _ReflectionTile(reflection: r, cs: cs, theme: theme)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _startCheckIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CheckInFlow(onGoHome: onGoHome),
      ),
    );
  }
}

// ── Voice reflection card ───────────────────────────────────────────────────────────────

class _VoiceReflectionCard extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _VoiceReflectionCard({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    final voiceProvider = VoiceReflectionScope.of(context);
    final savedCount = voiceProvider.savedCount;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.primary.withAlpha(20)),
        boxShadow: [
          BoxShadow(
              color: cs.primary.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.mic_none_rounded,
                    size: 20, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Voice Reflection',
                        style: theme.textTheme.titleLarge),
                    Text(
                      'Sometimes speaking feels easier than writing.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withAlpha(150)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Privacy note
          Row(
            children: [
              Icon(Icons.lock_outline_rounded,
                  size: 14, color: cs.primary.withAlpha(160)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Stays in this session only. Nothing is uploaded or shared.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: cs.onSurface.withAlpha(140)),
                ),
              ),
            ],
          ),
          if (savedCount > 0) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.mic_rounded,
                    size: 14, color: cs.primary.withAlpha(160)),
                const SizedBox(width: 6),
                Text(
                  '$savedCount voice reflection${savedCount == 1 ? '' : 's'} saved this session.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: cs.primary,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              // Microphone permission is only requested after this tap.
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const VoiceReflectionScreen()),
              ),
              icon: const Icon(Icons.mic_none_rounded, size: 18),
              label: const Text('Record a voice reflection'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────────

class _EmptyReflections extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _EmptyReflections({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withAlpha(20)),
      ),
      child: Column(
        children: [
          Icon(Icons.edit_note_rounded,
              size: 36, color: cs.primary.withAlpha(120)),
          const SizedBox(height: 12),
          Text('No reflections yet.',
              style: theme.textTheme.titleLarge
                  ?.copyWith(color: cs.onSurface.withAlpha(160))),
          const SizedBox(height: 6),
          Text(
            'Your first check-in can be as simple as choosing how you feel.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(130)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ReflectionTile extends StatelessWidget {
  final DailyReflection reflection;
  final ColorScheme cs;
  final ThemeData theme;
  const _ReflectionTile(
      {required this.reflection, required this.cs, required this.theme});

  String _dateLabel() {
    final now = DateTime.now();
    final d = reflection.dateTime;
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (d.year == yesterday.year &&
        d.month == yesterday.month &&
        d.day == yesterday.day) {
      return 'Yesterday';
    }
    return '${d.day}/${d.month}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final mood = reflection.mood;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.primary.withAlpha(20)),
        boxShadow: [
          BoxShadow(
              color: cs.primary.withAlpha(8),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Text(mood?.emoji ?? '—',
              style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(_dateLabel(),
                        style: theme.textTheme.labelLarge
                            ?.copyWith(color: cs.primary)),
                    const Spacer(),
                    if (mood != null)
                      Text(mood.label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (reflection.confidence != null)
                      _MiniStat(
                          label: 'Confidence',
                          value: '${reflection.confidence}/5',
                          cs: cs,
                          theme: theme),
                    if (reflection.confidence != null &&
                        reflection.socialConnection != null)
                      const SizedBox(width: 12),
                    if (reflection.socialConnection != null)
                      _MiniStat(
                          label: 'Connection',
                          value: '${reflection.socialConnection}/5',
                          cs: cs,
                          theme: theme),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Reflection saved privately',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withAlpha(110),
                      fontSize: 12,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme cs;
  final ThemeData theme;
  const _MiniStat(
      {required this.label,
      required this.value,
      required this.cs,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(140), fontSize: 12)),
        Text(value,
            style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.primary,
                fontSize: 12)),
      ],
    );
  }
}
