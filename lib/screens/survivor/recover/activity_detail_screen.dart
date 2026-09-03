import 'package:flutter/material.dart';
import '../../../models/recovery_activity.dart';

class ActivityDetailScreen extends StatelessWidget {
  final RecoveryActivity activity;
  final VoidCallback onStart;

  const ActivityDetailScreen({
    super.key,
    required this.activity,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final catColor = activity.category.color;

    return Scaffold(
      appBar: AppBar(
        title: Text(activity.category.label),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
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
                  // Header card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cs.primary.withAlpha(20)),
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withAlpha(12),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: catColor.withAlpha(30),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(activity.icon,
                                  size: 28, color: catColor),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _CategoryBadge(
                                      activity: activity, cs: cs, theme: theme),
                                  const SizedBox(height: 4),
                                  Text(activity.title,
                                      style: theme.textTheme.headlineMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.schedule_rounded,
                                size: 16,
                                color: cs.onSurface.withAlpha(140)),
                            const SizedBox(width: 6),
                            Text(activity.duration,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    color: cs.onSurface.withAlpha(140))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(activity.description,
                            style: theme.textTheme.bodyLarge?.copyWith(
                                color: cs.onSurface.withAlpha(170))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Why it helps
                  _SectionCard(
                    title: 'Why this may help',
                    icon: Icons.favorite_border_rounded,
                    cs: cs,
                    theme: theme,
                    child: Text(
                      activity.whyItHelps,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // How it works
                  _SectionCard(
                    title: 'How it works',
                    icon: Icons.list_alt_rounded,
                    cs: cs,
                    theme: theme,
                    child: Column(
                      children: activity.steps
                          .asMap()
                          .entries
                          .map((e) => _StepRow(
                                number: e.key + 1,
                                text: e.value,
                                cs: cs,
                                theme: theme,
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Actions
                  if (!activity.isInformational)
                    ElevatedButton(
                      onPressed: onStart,
                      child: const Text('Start'),
                    ),
                  if (activity.isInformational)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withAlpha(60),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cs.primary.withAlpha(30)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 18, color: cs.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'This is an informational activity. No action is taken on your behalf.',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: cs.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Not now'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final RecoveryActivity activity;
  final ColorScheme cs;
  final ThemeData theme;

  const _CategoryBadge(
      {required this.activity, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    final color = activity.category.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        activity.category.label.toUpperCase(),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final ColorScheme cs;
  final ThemeData theme;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.primary.withAlpha(18)),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: cs.primary),
              const SizedBox(width: 8),
              Text(title, style: theme.textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int number;
  final String text;
  final ColorScheme cs;
  final ThemeData theme;

  const _StepRow(
      {required this.number,
      required this.text,
      required this.cs,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
          ),
        ],
      ),
    );
  }
}
