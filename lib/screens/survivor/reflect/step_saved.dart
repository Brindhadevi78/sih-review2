import 'package:flutter/material.dart';
import '../../../app/app.dart';
import '../../../app/routes/app_routes.dart';

class StepSaved extends StatelessWidget {
  final VoidCallback onGoHome;
  const StepSaved({super.key, required this.onGoHome});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final reflection = ReflectionScope.of(context).allReflections.firstOrNull;
    final insight = reflection?.insight;
    final aiRequested = reflection?.aiAnalysisRequested ?? false;
    final aiCompleted = reflection?.aiAnalysisCompleted ?? false;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Confirmation ──────────────────────────────────────────
                  Text('Reflection saved 🌱',
                      style: theme.textTheme.displaySmall
                          ?.copyWith(color: cs.primary),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text(
                    'Thank you for taking a moment for yourself.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurface.withAlpha(160), height: 1.6),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your check-in has been added to your recovery journey.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurface.withAlpha(140)),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 28),

                  // ── AI insight or skipped state ───────────────────────────
                  if (insight != null)
                    _InsightCard(insight: insight, cs: cs, theme: theme)
                  else if (aiRequested && !aiCompleted)
                    _AnalysisFailedCard(cs: cs, theme: theme)
                  else
                    _AiSkippedCard(cs: cs, theme: theme),

                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onGoHome();
                    },
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Insight card ──────────────────────────────────────────────────────────────

class _InsightCard extends StatelessWidget {
  final dynamic insight;
  final ColorScheme cs;
  final ThemeData theme;

  const _InsightCard(
      {required this.insight, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(100),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.primary.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.psychology_outlined, color: cs.primary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Your Reflection Insight',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontSize: 15, color: cs.primary)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // AI insight label
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: cs.primary.withAlpha(30)),
            ),
            child: Text(
              'AI insight — not a diagnosis.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  color: cs.onSurface.withAlpha(150),
                  fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 14),

          // Pattern
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  insight.pattern as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Message
          Text(insight.message as String,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w500, height: 1.5)),
          const SizedBox(height: 8),

          // Support message
          Text(insight.supportMessage as String,
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withAlpha(160), height: 1.5)),
          const SizedBox(height: 14),

          // Suggested step
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.star_outline_rounded,
                    color: cs.primary, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Suggested small step',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.primary)),
                      const SizedBox(height: 2),
                      Text(insight.suggestedStep as String,
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

// ── AI skipped card ───────────────────────────────────────────────────────────

class _AiSkippedCard extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;

  const _AiSkippedCard({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withAlpha(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.do_not_disturb_alt_outlined,
                  size: 18, color: cs.onSurface.withAlpha(120)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI analysis was skipped because you chose not to enable it.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: cs.onSurface.withAlpha(160)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Your reflection has been saved privately. '
            'AI analysis is always optional.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(140), height: 1.4),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.privacyCenter),
            icon: Icon(Icons.tune_rounded, size: 16, color: cs.primary),
            label: Text('Manage AI consent',
                style: TextStyle(color: cs.primary, fontSize: 13)),
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          ),
        ],
      ),
    );
  }
}

// ── Analysis failed card ──────────────────────────────────────────────────────

class _AnalysisFailedCard extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;

  const _AnalysisFailedCard({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withAlpha(20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              size: 18, color: cs.onSurface.withAlpha(120)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your reflection was saved. '
              'AI insight could not be generated this time — '
              'this does not affect your reflection.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurface.withAlpha(160), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
