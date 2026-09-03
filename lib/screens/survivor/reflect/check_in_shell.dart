import 'package:flutter/material.dart';

/// Shared scaffold for each check-in step.
class CheckInShell extends StatelessWidget {
  final int stepNumber;
  final int totalSteps;
  final Widget body;
  final String continueLabel;
  final VoidCallback onContinue;
  final VoidCallback? onSkip;
  final VoidCallback onBack;

  const CheckInShell({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.body,
    this.continueLabel = 'Continue',
    required this.onContinue,
    this.onSkip,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: onBack,
        ),
        title: _StepProgress(
            current: stepNumber, total: totalSteps, color: cs.primary),
        actions: [
          if (onSkip != null)
            TextButton(
              onPressed: onSkip,
              child: Text('Skip',
                  style: TextStyle(
                      color: cs.onSurface.withAlpha(150), fontSize: 13)),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: body,
                ),
              ),
            ),
            _BottomAction(
                label: continueLabel, onTap: onContinue, cs: cs),
          ],
        ),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  final int current;
  final int total;
  final Color color;
  const _StepProgress(
      {required this.current, required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Step $current of $total',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        SizedBox(
          width: 140,
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

class _BottomAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final ColorScheme cs;
  const _BottomAction(
      {required this.label, required this.onTap, required this.cs});

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
              offset: const Offset(0, -4)),
        ],
      ),
      child: ElevatedButton(onPressed: onTap, child: Text(label)),
    );
  }
}

/// Reusable heading block.
class CheckInHeading extends StatelessWidget {
  final String title;
  final String subtitle;
  const CheckInHeading(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
                color: cs.onSurface.withAlpha(160), height: 1.6)),
        const SizedBox(height: 28),
      ],
    );
  }
}

/// Reusable 1–5 scale selector.
class ScaleSelector extends StatelessWidget {
  final int? value;
  final List<String> labels; // length 5
  final void Function(int) onSelect;
  final ColorScheme cs;
  final ThemeData theme;

  const ScaleSelector({
    super.key,
    required this.value,
    required this.labels,
    required this.onSelect,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (i) {
        final level = i + 1;
        final selected = value == level;
        return GestureDetector(
          onTap: () => onSelect(level),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 10),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: selected ? cs.primaryContainer : cs.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? cs.primary : cs.primary.withAlpha(40),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: selected ? cs.primary : cs.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('$level',
                        style: TextStyle(
                          color: selected ? cs.onPrimary : cs.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        )),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(labels[i],
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: selected ? cs.primary : cs.onSurface,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      )),
                ),
                if (selected)
                  Icon(Icons.check_circle_rounded,
                      color: cs.primary, size: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}
