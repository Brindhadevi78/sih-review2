import 'package:flutter/material.dart';
import 'check_in_shell.dart';

class StepConnection extends StatelessWidget {
  final int stepNumber;
  final int totalSteps;
  final int? value;
  final void Function(int) onSelect;
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  const StepConnection({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.value,
    required this.onSelect,
    required this.onContinue,
    required this.onSkip,
    required this.onBack,
  });

  static const _labels = [
    'Very disconnected',
    'A little disconnected',
    'Some connection',
    'Connected',
    'Very connected',
  ];

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
            title: 'How connected do you feel today?',
            subtitle:
                'This can mean feeling connected to yourself, someone you trust, or your community.',
          ),
          ScaleSelector(
            value: value,
            labels: _labels,
            onSelect: onSelect,
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
