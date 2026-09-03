import 'package:flutter/material.dart';
import '../../../models/recovery_state.dart';
import 'check_in_shell.dart';

class StepMood extends StatelessWidget {
  final int stepNumber;
  final int totalSteps;
  final CheckInMood? selected;
  final void Function(CheckInMood) onSelect;
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  const StepMood({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.selected,
    required this.onSelect,
    required this.onContinue,
    required this.onSkip,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return CheckInShell(
      stepNumber: stepNumber,
      totalSteps: totalSteps,
      onContinue: onContinue,
      onSkip: onSkip,
      onBack: onBack,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CheckInHeading(
            title: 'How are you feeling right now?',
            subtitle:
                'Choose the feeling that fits best. There are no right or wrong answers.',
          ),
          ...CheckInMood.values.map((m) {
            final isSelected = selected == m;
            return GestureDetector(
              onTap: () => onSelect(m),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? cs.primaryContainer : cs.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? cs.primary
                        : cs.primary.withAlpha(40),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(m.emoji,
                        style: const TextStyle(fontSize: 26)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(m.label,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isSelected ? cs.primary : cs.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          )),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle_rounded,
                          color: cs.primary, size: 20),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
