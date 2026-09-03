import 'package:flutter/material.dart';
import 'check_in_shell.dart';

class StepConfidence extends StatelessWidget {
  final int stepNumber;
  final int totalSteps;
  final int? value;
  final void Function(int) onSelect;
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  const StepConfidence({
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
    'Very low',
    'Low',
    'Okay',
    'Good',
    'Strong',
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
            title: 'How confident do you feel today?',
            subtitle:
                'Choose a level that feels closest to how you feel.',
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
