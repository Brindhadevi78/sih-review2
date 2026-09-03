import 'package:flutter/material.dart';
import '../../models/daily_reflection.dart';
import '../../models/recovery_state.dart';
import '../../providers/reflection_provider.dart';

class ReflectionDetailScreen extends StatelessWidget {
  final DailyReflection reflection;

  const ReflectionDetailScreen({super.key, required this.reflection});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Reflection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back to Journey',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Date header
                  _DetailCard(
                    cs: cs,
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(Icons.calendar_today_rounded,
                              size: 22, color: cs.primary),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatDate(reflection.dateTime),
                              style: theme.textTheme.titleLarge,
                            ),
                            Text(
                              _formatTime(reflection.dateTime),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurface.withAlpha(150)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Mood
                  if (reflection.mood != null)
                    _DetailCard(
                      cs: cs,
                      child: _LabeledRow(
                        icon: Icons.mood_rounded,
                        label: 'Mood',
                        value:
                            '${reflection.mood!.emoji}  ${reflection.mood!.label}',
                        cs: cs,
                        theme: theme,
                      ),
                    ),
                  if (reflection.mood != null) const SizedBox(height: 10),

                  // Confidence
                  if (reflection.confidence != null)
                    _DetailCard(
                      cs: cs,
                      child: _LabeledRow(
                        icon: Icons.shield_outlined,
                        label: 'Confidence',
                        value: '${reflection.confidence}/5 — '
                            '${confidenceLabel(reflection.confidence)}',
                        cs: cs,
                        theme: theme,
                      ),
                    ),
                  if (reflection.confidence != null) const SizedBox(height: 10),

                  // Social connection
                  if (reflection.socialConnection != null)
                    _DetailCard(
                      cs: cs,
                      child: _LabeledRow(
                        icon: Icons.people_outline_rounded,
                        label: 'Social connection',
                        value: '${reflection.socialConnection}/5 — '
                            '${connectionLabel(reflection.socialConnection)}',
                        cs: cs,
                        theme: theme,
                      ),
                    ),
                  if (reflection.socialConnection != null)
                    const SizedBox(height: 10),

                  // Private journal
                  if (reflection.journalText != null &&
                      reflection.journalText!.trim().isNotEmpty) ...[
                    _DetailCard(
                      cs: cs,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lock_outline_rounded,
                                  size: 16, color: cs.primary),
                              const SizedBox(width: 8),
                              Text('Private journal',
                                  style: theme.textTheme.titleLarge
                                      ?.copyWith(fontSize: 15)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: cs.primaryContainer.withAlpha(80),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Only visible to you',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 10,
                                      color: cs.primary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            reflection.journalText!,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(height: 1.6),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  // AI insight
                  _AiInsightSection(
                      reflection: reflection, cs: cs, theme: theme),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
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

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ── AI insight section ────────────────────────────────────────────────────────

class _AiInsightSection extends StatelessWidget {
  final DailyReflection reflection;
  final ColorScheme cs;
  final ThemeData theme;

  const _AiInsightSection(
      {required this.reflection, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    // No AI analysis was requested for this reflection.
    if (!reflection.aiAnalysisRequested) {
      return _DetailCard(
        cs: cs,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.do_not_disturb_alt_outlined,
                    size: 18, color: cs.onSurface.withAlpha(120)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'No AI insight was generated for this reflection.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurface.withAlpha(150)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'AI analysis was not requested when this reflection was saved.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurface.withAlpha(120), fontSize: 12),
            ),
          ],
        ),
      );
    }

    // Analysis was requested but did not complete (e.g. service error).
    if (reflection.aiAnalysisRequested && !reflection.aiAnalysisCompleted) {
      return _DetailCard(
        cs: cs,
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded,
                size: 18, color: cs.onSurface.withAlpha(120)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'AI insight was requested but could not be generated. '
                'Your reflection was saved safely.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: cs.onSurface.withAlpha(150)),
              ),
            ),
          ],
        ),
      );
    }

    if (reflection.insight == null) return const SizedBox.shrink();

    final insight = reflection.insight!;
    return _DetailCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.psychology_outlined, size: 18, color: cs.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Your Reflection Insight',
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 15)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Prototype disclaimer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withAlpha(60),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Prototype AI insight — not a diagnosis.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  color: cs.onSurface.withAlpha(140),
                  fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 14),
          // Pattern chip
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              insight.pattern,
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.primary, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          Text(insight.message,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w500, height: 1.5)),
          const SizedBox(height: 8),
          Text(insight.supportMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withAlpha(160), height: 1.5)),
          const SizedBox(height: 12),
          // Suggested step
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withAlpha(60),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.star_outline_rounded,
                    size: 14, color: cs.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Suggested small step',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.primary,
                              fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(insight.suggestedStep,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _DetailCard extends StatelessWidget {
  final Widget child;
  final ColorScheme cs;

  const _DetailCard({required this.child, required this.cs});

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

class _LabeledRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme cs;
  final ThemeData theme;

  const _LabeledRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: cs.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withAlpha(150), fontSize: 12)),
            Text(value,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}
