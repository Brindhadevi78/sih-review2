import 'package:flutter/material.dart';

/// Shared scaffold for every onboarding step.
/// Provides: progress bar, back button, scrollable body, bottom action area.
class OnboardingShell extends StatelessWidget {
  final int currentStep;   // 1-based
  final int totalSteps;
  final Widget body;
  final String continueLabel;
  final VoidCallback onContinue;
  final String skipLabel;
  final VoidCallback onSkip;
  final bool showBack;
  final VoidCallback? onBack;

  const OnboardingShell({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.body,
    this.continueLabel = 'Continue',
    required this.onContinue,
    this.skipLabel = 'Skip for now',
    required this.onSkip,
    this.showBack = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: showBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: onBack ?? () => Navigator.maybePop(context),
              )
            : null,
        title: _ProgressIndicator(
          current: currentStep,
          total: totalSteps,
          color: cs.primary,
        ),
        actions: [
          TextButton(
            onPressed: onSkip,
            child: Text(
              skipLabel,
              style: TextStyle(color: cs.onSurface.withAlpha(160), fontSize: 13),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: body,
                ),
              ),
            ),
            _BottomBar(
              continueLabel: continueLabel,
              onContinue: onContinue,
              cs: cs,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final int current;
  final int total;
  final Color color;

  const _ProgressIndicator({
    required this.current,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Step $current of $total',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: color, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 160,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: current / total,
              backgroundColor: color.withAlpha(40),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 5,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  final String continueLabel;
  final VoidCallback onContinue;
  final ColorScheme cs;
  final ThemeData theme;

  const _BottomBar({
    required this.continueLabel,
    required this.onContinue,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: cs.primary.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onContinue,
        child: Text(continueLabel),
      ),
    );
  }
}

/// Reusable selectable chip/card for onboarding option lists.
class SelectableOptionCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const SelectableOptionCard({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? cs.primaryContainer : cs.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? cs.primary : cs.primary.withAlpha(40),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: cs.primary.withAlpha(20),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 20,
                  color: selected ? cs.primary : cs.onSurface.withAlpha(140)),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: selected ? cs.primary : cs.onSurface,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, color: cs.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Step heading block reused across all steps.
class StepHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const StepHeading({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: cs.onSurface.withAlpha(160), height: 1.6),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}
