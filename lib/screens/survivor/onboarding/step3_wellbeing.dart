import 'package:flutter/material.dart';
import '../../../app/app.dart';
import 'onboarding_shell.dart';

class Step3Wellbeing extends StatefulWidget {
  final int stepNumber;
  final int totalSteps;
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const Step3Wellbeing({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.onContinue,
    required this.onBack,
    required this.onSkip,
  });

  @override
  State<Step3Wellbeing> createState() => _Step3WellbeingState();
}

class _Step3WellbeingState extends State<Step3Wellbeing> {
  static const _options = [
    'Low mood',
    'Stress',
    'Anxiety',
    'Low confidence',
    'Feeling overwhelmed',
    'Loneliness',
    'Difficulty sleeping',
    'Difficulty concentrating',
    'Feeling calm',
    'Feeling positive',
    'Prefer not to say',
  ];

  final Set<String> _selected = {};

  void _toggle(String option) {
    setState(() {
      if (option == 'Prefer not to say') {
        _selected.clear();
        _selected.add(option);
        return;
      }
      _selected.remove('Prefer not to say');
      if (_selected.contains(option)) {
        _selected.remove(option);
      } else {
        _selected.add(option);
      }
    });
  }

  void _save() {
    SurvivorProfileScope.of(context).updateWellbeing(_selected.toList());
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: widget.stepNumber,
      totalSteps: widget.totalSteps,
      onContinue: _save,
      onBack: widget.onBack,
      onSkip: () {
        SurvivorProfileScope.of(context).updateWellbeing([]);
        widget.onSkip();
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeading(
            title: 'How have you been feeling recently?',
            subtitle:
                'This helps us suggest small recovery activities. You can change these later.',
          ),
          ..._options.map((o) => SelectableOptionCard(
                label: o,
                selected: _selected.contains(o),
                onTap: () => _toggle(o),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
