import 'package:flutter/material.dart';
import '../../app/app.dart';
import '../../app/routes/app_routes.dart';
import '../../models/consent_record.dart';
import '../../providers/survivor_profile_provider.dart';

class PrivacyCenterScreen extends StatelessWidget {
  const PrivacyCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Center')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PrivacyHeader(cs: cs, theme: theme),
                  const SizedBox(height: 20),
                  _PrivacyOverviewCard(cs: cs, theme: theme),
                  const SizedBox(height: 20),
                  _JournalPrivacySection(cs: cs, theme: theme),
                  const SizedBox(height: 20),
                  _VoiceSection(cs: cs, theme: theme),
                  const SizedBox(height: 20),
                  _CheckInSection(cs: cs, theme: theme),
                  const SizedBox(height: 20),
                  _AiConsentSection(cs: cs, theme: theme),
                  const SizedBox(height: 20),
                  _AboutAiCard(cs: cs, theme: theme),
                  const SizedBox(height: 20),
                  _ConsentHistorySection(cs: cs, theme: theme),
                  const SizedBox(height: 20),
                  _SupportSharingSection(cs: cs, theme: theme),
                  const SizedBox(height: 20),
                  _ConsentPrinciplesSection(cs: cs, theme: theme),
                  const SizedBox(height: 20),
                  _FutureSecuritySection(cs: cs, theme: theme),
                  const SizedBox(height: 20),
                  _DeleteAllSection(cs: cs, theme: theme),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _PrivacyHeader extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _PrivacyHeader({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Privacy Center', style: theme.textTheme.displaySmall),
        const SizedBox(height: 6),
        Text('You are in control of your information.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: cs.onSurface.withAlpha(160))),
        const SizedBox(height: 10),
        Text('Choose what you want to keep, analyze, share, or delete.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(150))),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withAlpha(80),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.primary.withAlpha(30)),
          ),
          child: Text(
            'Privacy controls — production encryption and backend security will be implemented separately.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.primary, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}

// ── Privacy Overview Card ─────────────────────────────────────────────────────

class _PrivacyOverviewCard extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _PrivacyOverviewCard({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    final profile = SurvivorProfileScope.of(context).profile;
    final reflections = ReflectionScope.of(context).allReflections;
    final hasJournal = reflections.any((r) => (r.journalText ?? '').isNotEmpty);
    final voiceCount = VoiceReflectionScope.of(context).savedCount;

    final rows = [
      ('Journal', hasJournal ? 'Private' : 'No entries'),
      ('Voice reflections', voiceCount == 0 ? 'No recordings' : '$voiceCount saved this session'),
      ('Emotional check-ins', reflections.isNotEmpty ? 'Stored locally' : 'No entries'),
      ('AI analysis', profile?.aiAnalysisConsent == true ? 'Allowed' : 'Not requested'),
      ('Support sharing', 'Not shared'),
    ];

    return _SectionCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Privacy Choices', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          ...rows.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: cs.primary.withAlpha(160)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(r.$1, style: theme.textTheme.bodyMedium)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withAlpha(120),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(r.$2,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12, color: cs.primary)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── Journal Privacy ───────────────────────────────────────────────────────────

class _JournalPrivacySection extends StatefulWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _JournalPrivacySection({required this.cs, required this.theme});

  @override
  State<_JournalPrivacySection> createState() => _JournalPrivacySectionState();
}

class _JournalPrivacySectionState extends State<_JournalPrivacySection> {
  bool _deleted = false;

  @override
  Widget build(BuildContext context) {
    final cs = widget.cs;
    final theme = widget.theme;

    return _SectionCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.book_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Private Journal', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 8),
          Text(
            'Your journal entries are private to you unless you explicitly choose otherwise.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(160), height: 1.5),
          ),
          const SizedBox(height: 14),
          if (_deleted)
            _StatusBanner(
              message: 'Your journal entries were deleted from this session.',
              cs: cs,
              theme: theme,
            )
          else
            OutlinedButton.icon(
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text('Delete Journal Entries'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade300),
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete all journal entries?'),
        content: const Text(
          'This cannot be undone.\n\nYour check-in data (mood, confidence, connection) will be preserved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ReflectionScope.of(context).deleteJournalText();
              ConsentScope.of(context).record(
                action: 'Journal entries deleted',
                description: 'Journal text removed; check-in data preserved.',
                status: 'Completed',
              );
              setState(() => _deleted = true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── Voice Section ─────────────────────────────────────────────────────────────

class _VoiceSection extends StatefulWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _VoiceSection({required this.cs, required this.theme});

  @override
  State<_VoiceSection> createState() => _VoiceSectionState();
}

class _VoiceSectionState extends State<_VoiceSection> {
  bool _deleted = false;

  @override
  Widget build(BuildContext context) {
    final cs = widget.cs;
    final theme = widget.theme;
    final voice = VoiceReflectionScope.of(context);
    final count = voice.savedCount;

    return _SectionCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.mic_none_rounded, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Voice Reflections', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 8),
          Text(
            'Voice reflections are stored only for this session. '
            'No audio is uploaded, shared, or automatically transcribed. '
            'No AI analysis is performed on your voice.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(160), height: 1.5),
          ),
          const SizedBox(height: 6),
          Text(
            count == 0
                ? 'No voice recordings stored.'
                : '$count voice reflection${count == 1 ? '' : 's'} stored this session.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.primary, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 14),
          if (_deleted)
            _StatusBanner(
              message: 'Voice reflections deleted from this session.',
              cs: cs,
              theme: theme,
            )
          else
            OutlinedButton.icon(
              onPressed: count == 0 ? null : () => _confirmDelete(context),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text('Delete Voice Reflections'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade300),
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete all voice reflections?'),
        content: const Text(
          'This removes all voice reflections from this session.\n\nThis cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              VoiceReflectionScope.of(context).clearAll();
              ConsentScope.of(context).record(
                action: 'Voice reflections deleted',
                description: 'All voice reflections removed from this session.',
                status: 'Completed',
              );
              setState(() => _deleted = true);
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

// ── Check-in Section ──────────────────────────────────────────────────────────

class _CheckInSection extends StatefulWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _CheckInSection({required this.cs, required this.theme});

  @override
  State<_CheckInSection> createState() => _CheckInSectionState();
}

class _CheckInSectionState extends State<_CheckInSection> {
  bool _deleted = false;

  @override
  Widget build(BuildContext context) {
    final cs = widget.cs;
    final theme = widget.theme;
    final count = ReflectionScope.of(context).allReflections.length;

    return _SectionCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.mood_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Emotional Check-ins', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 8),
          Text(
            'Your mood, confidence and social connection check-ins are used to personalise your experience.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(160), height: 1.5),
          ),
          const SizedBox(height: 6),
          Text('$count check-in(s) stored locally.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.primary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 14),
          if (_deleted)
            _StatusBanner(
              message: 'Check-in history removed from this session.',
              cs: cs,
              theme: theme,
            )
          else
            OutlinedButton.icon(
              onPressed: count == 0 ? null : () => _confirmDelete(context),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text('Delete Check-in History'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade300),
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete all check-in history?'),
        content: const Text(
          'This removes your saved reflection and check-in history from this session.\n\nYour profile and preferences will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ReflectionScope.of(context).clearReflections();
              RecoveryStateScope.of(context).clear();
              ConsentScope.of(context).record(
                action: 'Check-in history deleted',
                description: 'All reflection and check-in records removed.',
                status: 'Completed',
              );
              setState(() => _deleted = true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── AI Consent Section ────────────────────────────────────────────────────────

class _AiConsentSection extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _AiConsentSection({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    final profileProvider = SurvivorProfileScope.of(context);
    final aiConsent = profileProvider.profile?.aiAnalysisConsent ?? false;

    return _SectionCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.psychology_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('AI Emotional Insights', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 8),
          Text(
            'When enabled, emotional analysis may use your current '
            'check-in and, when you choose to analyse it, your current journal entry.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(160), height: 1.5),
          ),
          const SizedBox(height: 6),
          Text(
            'AI analysis is optional. Changing this setting affects future '
            'reflections only — existing insights are not removed.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(150), height: 1.5),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Icon(
              aiConsent
                  ? Icons.check_circle_outline
                  : Icons.do_not_disturb_alt_outlined,
              size: 18,
              color: aiConsent ? cs.primary : cs.onSurface.withAlpha(120),
            ),
            const SizedBox(width: 8),
            Text(
              'AI analysis is currently: ${aiConsent ? "Enabled" : "Not enabled"}',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ]),
          const SizedBox(height: 6),
          Text(
            'AI analysis only — no external AI service is connected. '
            'Results are general emotional observations, not medical diagnoses.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(140),
                fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () =>
                _showAiConsentDialog(context, aiConsent, profileProvider),
            icon: const Icon(Icons.tune_rounded, size: 18),
            label: const Text('Manage AI Consent'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 46),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  void _showAiConsentDialog(
      BuildContext context,
      bool current,
      SurvivorProfileProvider profileProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('AI Emotional Insights'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'When enabled, AI may use your check-in mood, '
              'confidence, and social connection ratings to provide a general '
              'emotional observation.\n\n'
              'When you choose to analyse a specific reflection, your journal '
              'entry for that reflection may also be used — only at that moment, '
              'and only locally.\n\n'
              'AI insights are supportive observations only. '
              'They are not medical diagnoses and will never automatically '
              'report, share, or contact anyone.',
              style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Current setting: ${current ? "Enabled" : "Not enabled"}',
              style: Theme.of(ctx)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              profileProvider.updateAiConsent(false);
              ConsentScope.of(context).record(
                action: 'AI analysis disabled',
                description: 'Survivor chose to disable AI emotional insights.',
                status: 'Updated',
              );
            },
            child: const Text('Disable'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              profileProvider.updateAiConsent(true);
              ConsentScope.of(context).record(
                action: 'AI analysis enabled',
                description: 'Survivor chose to enable AI emotional insights.',
                status: 'Updated',
              );
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }
}

// ── About AI Card ─────────────────────────────────────────────────────────────

class _AboutAiCard extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _AboutAiCard({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    const points = [
      'AI only — no external AI service is connected.',
      'Provides general emotional observations based on your check-in.',
      'Does not diagnose any condition.',
      'Does not replace professional support.',
      'Does not contact authorities or emergency services.',
      'Does not automatically share any information.',
      'Journal text is used only locally, only when you choose to analyse a reflection.',
      'You control whether AI analysis is enabled.',
    ];

    return _SectionCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.info_outline_rounded, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('About AI Support', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 12),
          ...points.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_rounded, size: 16, color: cs.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(p,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(height: 1.4)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── Consent History ───────────────────────────────────────────────────────────

class _ConsentHistorySection extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _ConsentHistorySection({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    final records = ConsentScope.of(context).records;

    return _SectionCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.history_rounded, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Consent History', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 8),
          Text(
            'A local record of privacy decisions made during this session.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(160)),
          ),
          const SizedBox(height: 12),
          if (records.isEmpty)
            Text('No privacy decisions recorded yet.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: cs.onSurface.withAlpha(120)))
          else
            ...records.map((r) => _ConsentRecordTile(record: r, cs: cs, theme: theme)),
        ],
      ),
    );
  }
}

class _ConsentRecordTile extends StatelessWidget {
  final ConsentRecord record;
  final ColorScheme cs;
  final ThemeData theme;
  const _ConsentRecordTile(
      {required this.record, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    final dt = record.timestamp;
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    final label =
        '${dt.day} ${months[dt.month - 1]}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: cs.primary.withAlpha(160),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.action,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text(record.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withAlpha(150), fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11, color: cs.onSurface.withAlpha(120))),
              Text(record.status,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      color: cs.primary,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Support Sharing ───────────────────────────────────────────────────────────

class _SupportSharingSection extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _SupportSharingSection({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    final choices = SupportHistoryScope.of(context).choices;

    return _SectionCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.share_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Support Sharing', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 8),
          Text(
            'Support information is shared only after you explicitly choose what to share.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(160), height: 1.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Nothing is currently being shared. All actions below are local records only — no information was transmitted.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(140),
                fontStyle: FontStyle.italic),
          ),
          if (choices.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...choices.take(5).map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(children: [
                    Icon(Icons.circle, size: 7, color: cs.primary.withAlpha(140)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(c.label,
                            style: theme.textTheme.bodyMedium)),
                  ]),
                )),
          ],
        ],
      ),
    );
  }
}

// ── Consent Principles ────────────────────────────────────────────────────────

class _ConsentPrinciplesSection extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _ConsentPrinciplesSection({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    const principles = [
      'Nothing is shared without your permission.',
      'AI insights are optional.',
      'You can change your choices.',
      'You can delete your information.',
      'You can choose not to continue.',
      'Support is voluntary.',
    ];

    return _SectionCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.favorite_border_rounded, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Your choices matter', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 12),
          ...principles.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_rounded, size: 16, color: cs.primary),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(p, style: theme.textTheme.bodyMedium
                            ?.copyWith(height: 1.4))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── Future Security ───────────────────────────────────────────────────────────

class _FutureSecuritySection extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _FutureSecuritySection({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    const items = [
      'Secure authentication',
      'Encryption at rest',
      'Encryption in transit',
      'Role-based access control',
      'Consent-based data sharing',
      'Minimal data collection',
      'Secure deletion',
      'Audit logging',
    ];

    return _SectionCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.security_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Future Security Architecture',
                style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cs.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Planned for production',
                style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12, color: cs.onSurface.withAlpha(160))),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  Icon(Icons.radio_button_unchecked,
                      size: 14, color: cs.primary.withAlpha(140)),
                  const SizedBox(width: 8),
                  Text(item, style: theme.textTheme.bodyMedium),
                ]),
              )),
        ],
      ),
    );
  }
}

// ── Delete All ────────────────────────────────────────────────────────────────

class _DeleteAllSection extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _DeleteAllSection({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.warning_amber_rounded,
                color: Colors.red.shade700, size: 20),
            const SizedBox(width: 8),
            Text('Delete My Data',
                style: theme.textTheme.titleLarge
                    ?.copyWith(color: Colors.red.shade700)),
          ]),
          const SizedBox(height: 8),
          Text(
            'This will remove all your local data. This action cannot be undone.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: Colors.red.shade800, height: 1.5),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _confirmDeleteAll(context),
              icon: const Icon(Icons.delete_forever_rounded),
              label: const Text('Delete All Personal Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
          const SizedBox(width: 8),
          const Text('Delete everything?'),
        ]),
        content: const Text(
          'This will remove your local data, including reflections, recovery activity history, support choices and personalisation data.\n\nThis cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteAll(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }

  void _deleteAll(BuildContext context) {
    ReflectionScope.of(context).clearReflections();
    RecoveryStateScope.of(context).clear();
    ActivityHistoryScope.of(context).clearHistory();
    SupportHistoryScope.of(context).clear();
    VoiceReflectionScope.of(context).clearAll();
    ConsentScope.of(context).clear();
    CompanionScope.of(context).reset();
    SurvivorProfileScope.of(context).clear();
    SessionScope.of(context).clear();
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.login, (_) => false);
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  final ColorScheme cs;
  const _SectionCard({required this.child, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withAlpha(20)),
        boxShadow: [
          BoxShadow(
              color: cs.primary.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String message;
  final ColorScheme cs;
  final ThemeData theme;
  const _StatusBanner(
      {required this.message, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(100),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        Icon(Icons.check_circle_outline, color: cs.primary, size: 18),
        const SizedBox(width: 8),
        Expanded(
            child: Text(message,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: cs.primary))),
      ]),
    );
  }
}
