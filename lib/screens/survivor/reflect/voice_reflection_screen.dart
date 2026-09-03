import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../app/app.dart';
import '../../../providers/voice_reflection_provider.dart';

class VoiceReflectionScreen extends StatelessWidget {
  const VoiceReflectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = VoiceReflectionScope.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Reflection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
          onPressed: () {
            if (provider.recordingState != RecordingState.idle) {
              provider.cancelRecording();
            }
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: _VoiceBody(provider: provider, cs: cs, theme: theme),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Body dispatcher ───────────────────────────────────────────────────────────

class _VoiceBody extends StatelessWidget {
  final VoiceReflectionProvider provider;
  final ColorScheme cs;
  final ThemeData theme;

  const _VoiceBody(
      {required this.provider, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    switch (provider.recordingState) {
      case RecordingState.idle:
        return _IdleView(provider: provider, cs: cs, theme: theme);
      case RecordingState.recording:
        return _RecordingView(provider: provider, cs: cs, theme: theme);
      case RecordingState.review:
        return _ReviewView(provider: provider, cs: cs, theme: theme);
    }
  }
}

// ── Idle view ─────────────────────────────────────────────────────────────────

class _IdleView extends StatelessWidget {
  final VoiceReflectionProvider provider;
  final ColorScheme cs;
  final ThemeData theme;

  const _IdleView(
      {required this.provider, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Voice Reflection',
            style: theme.textTheme.displaySmall
                ?.copyWith(color: cs.primary)),
        const SizedBox(height: 8),
        Text(
          'Sometimes speaking feels easier than writing.',
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: cs.onSurface.withAlpha(160), height: 1.5),
        ),
        const SizedBox(height: 24),

        _PrivacyNotice(cs: cs, theme: theme),
        const SizedBox(height: 28),

        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.mic_none_rounded,
                size: 44, color: cs.primary),
          ),
        ),
        const SizedBox(height: 32),

        ElevatedButton.icon(
          onPressed: () => _confirmAndRecord(context),
          icon: const Icon(Icons.fiber_manual_record_rounded, size: 18),
          label: const Text('Record a reflection'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Maybe later',
              style: TextStyle(color: cs.onSurface.withAlpha(150))),
        ),

        if (provider.savedCount > 0) ...[
          const SizedBox(height: 32),
          _SavedList(provider: provider, cs: cs, theme: theme),
        ],
      ],
    );
  }

  void _confirmAndRecord(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(Icons.mic_none_rounded,
              color: Theme.of(ctx).colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Before you record'),
        ]),
        content: Text(
          'Your voice reflection stays in this session only.\n\n'
          'Nothing is uploaded or shared.\n'
          'No transcription is created automatically.\n'
          'No AI analysis is performed on your voice.\n\n'
          'Microphone access is needed only if you choose to record.',
          style: Theme.of(ctx)
              .textTheme
              .bodyMedium
              ?.copyWith(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.startRecording();
            },
            child: const Text('Start recording'),
          ),
        ],
      ),
    );
  }
}

// ── Recording view ────────────────────────────────────────────────────────────

class _RecordingView extends StatelessWidget {
  final VoiceReflectionProvider provider;
  final ColorScheme cs;
  final ThemeData theme;

  const _RecordingView(
      {required this.provider, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.red.shade500,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text('Recording',
                style: theme.textTheme.titleLarge
                    ?.copyWith(color: Colors.red.shade600)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Your voice is private. Nothing is being uploaded.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withAlpha(150)),
        ),
        const SizedBox(height: 32),

        Center(
          child: Text(
            provider.elapsedLabel,
            style: theme.textTheme.displaySmall?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w300,
                letterSpacing: 4),
          ),
        ),
        const SizedBox(height: 24),

        _WaveformVisualizer(elapsed: provider.elapsedSeconds, cs: cs),
        const SizedBox(height: 32),

        ElevatedButton.icon(
          onPressed: provider.stopRecording,
          icon: const Icon(Icons.stop_rounded, size: 20),
          label: const Text('Stop recording'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            backgroundColor: cs.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 12),

        OutlinedButton.icon(
          onPressed: () => _confirmCancel(context),
          icon: const Icon(Icons.delete_outline_rounded, size: 18),
          label: const Text('Cancel and discard'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            foregroundColor: cs.onSurface.withAlpha(160),
            side: BorderSide(color: cs.primary.withAlpha(40)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Discard recording?'),
        content: const Text(
            'This will delete the current recording. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep recording'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.cancelRecording();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }
}

// ── Review view ───────────────────────────────────────────────────────────────

class _ReviewView extends StatelessWidget {
  final VoiceReflectionProvider provider;
  final ColorScheme cs;
  final ThemeData theme;

  const _ReviewView(
      {required this.provider, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Review your reflection',
            style: theme.textTheme.displaySmall
                ?.copyWith(color: cs.primary)),
        const SizedBox(height: 8),
        Text(
          'Your recording is ready to review. Nothing has been saved yet.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withAlpha(160), height: 1.5),
        ),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withAlpha(80),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.primary.withAlpha(30)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.mic_rounded,
                    color: cs.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Voice reflection',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontSize: 15)),
                  Text(
                    'Duration: ${provider.elapsedLabel}',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurface.withAlpha(150)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.primary.withAlpha(20)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 16, color: cs.onSurface.withAlpha(120)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Playback will be available in a future update.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withAlpha(150),
                      fontStyle: FontStyle.italic,
                      fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _TranscriptionPlaceholder(cs: cs, theme: theme),
        const SizedBox(height: 24),

        ElevatedButton.icon(
          onPressed: () => _save(context),
          icon: const Icon(Icons.save_outlined, size: 18),
          label: const Text('Save reflection'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 12),

        OutlinedButton.icon(
          onPressed: () => _confirmDiscard(context),
          icon: const Icon(Icons.delete_outline_rounded, size: 18),
          label: const Text('Delete this recording'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            foregroundColor: Colors.red.shade700,
            side: BorderSide(color: Colors.red.shade300),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  void _save(BuildContext context) {
    provider.saveRecording();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Voice reflection saved.'),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _confirmDiscard(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete this recording?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.cancelRecording();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── Saved list ────────────────────────────────────────────────────────────────

class _SavedList extends StatelessWidget {
  final VoiceReflectionProvider provider;
  final ColorScheme cs;
  final ThemeData theme;

  const _SavedList(
      {required this.provider, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    final reflections = provider.savedReflections;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Saved this session',
            style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'These recordings are stored locally on your device.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withAlpha(140), fontSize: 12),
        ),
        const SizedBox(height: 12),
        ...reflections.map((r) => _SavedTile(
              reflection: r,
              provider: provider,
              cs: cs,
              theme: theme,
            )),
      ],
    );
  }
}

class _SavedTile extends StatelessWidget {
  final dynamic reflection;
  final VoiceReflectionProvider provider;
  final ColorScheme cs;
  final ThemeData theme;

  const _SavedTile({
    required this.reflection,
    required this.provider,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final dt = reflection.createdAt as DateTime;
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    final dateLabel =
        '${dt.day} ${months[dt.month - 1]}, '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withAlpha(20)),
      ),
      child: Row(
        children: [
          Icon(Icons.mic_rounded, size: 20, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateLabel,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500)),
                Text(
                  'Duration: ${reflection.durationLabel}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: cs.onSurface.withAlpha(130)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded,
                size: 20, color: Colors.red.shade400),
            tooltip: 'Delete this recording',
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete this recording?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.deleteReflection(reflection.id as String);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── Waveform visualizer ───────────────────────────────────────────────────────

/// Simple animated waveform using built-in Flutter widgets.
/// Uses elapsed seconds as a seed for pseudo-random bar heights.
class _WaveformVisualizer extends StatelessWidget {
  final int elapsed;
  final ColorScheme cs;

  const _WaveformVisualizer({required this.elapsed, required this.cs});

  @override
  Widget build(BuildContext context) {
    const barCount = 28;
    final rng = math.Random(elapsed);

    return SizedBox(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(barCount, (i) {
          final center = barCount / 2;
          final distFromCenter = (i - center).abs() / center;
          final maxH = 48.0 * (1 - distFromCenter * 0.5);
          final h = 6.0 + rng.nextDouble() * maxH;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 4,
              height: h,
              decoration: BoxDecoration(
                color: cs.primary.withAlpha(180),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Transcription placeholder ─────────────────────────────────────────────────

class _TranscriptionPlaceholder extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;

  const _TranscriptionPlaceholder(
      {required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.secondaryContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withAlpha(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.text_snippet_outlined,
                size: 16, color: cs.onSurface.withAlpha(140)),
            const SizedBox(width: 8),
            Text('Transcription',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('Coming in a future update',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      color: cs.onSurface.withAlpha(130))),
            ),
          ]),
          const SizedBox(height: 8),
          Text(
            'You will be able to choose whether to create a '
            'transcription before any AI analysis. '
            'Transcription will require its own separate consent.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(140),
                fontSize: 12,
                height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ── Privacy notice ────────────────────────────────────────────────────────────

class _PrivacyNotice extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;

  const _PrivacyNotice({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.primary.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.lock_outline_rounded,
                size: 16, color: cs.primary),
            const SizedBox(width: 8),
            Text('Your voice is private.',
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: cs.primary)),
          ]),
          const SizedBox(height: 8),
          ...[
            'Recording is optional.',
            'Nothing is automatically shared.',
            'No audio is uploaded or sent anywhere.',
            'No AI analysis is performed on your voice.',
            'You can delete anytime.',
          ].map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_rounded,
                        size: 14, color: cs.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(line,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withAlpha(160),
                              fontSize: 13)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
