import 'package:flutter/material.dart';
import '../../../app/app.dart';
import 'onboarding_shell.dart';

class Step4SupportPreferences extends StatefulWidget {
  final int stepNumber;
  final int totalSteps;
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const Step4SupportPreferences({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.onContinue,
    required this.onBack,
    required this.onSkip,
  });

  @override
  State<Step4SupportPreferences> createState() =>
      _Step4SupportPreferencesState();
}

class _Step4SupportPreferencesState extends State<Step4SupportPreferences> {
  static const _supportOptions = [
    'Self-guided recovery',
    'Emotional support',
    'Professional support',
    'Peer support',
    'Legal resources',
    "Women's support services",
    'Emergency resources',
  ];

  static const _comfortOptions = [
    'I prefer not to talk right now',
    'Maybe later',
    "I'm comfortable talking to someone",
    'I would like support now',
  ];

  final Set<String> _selectedSupport = {};
  String? _selectedComfort;

  void _toggleSupport(String option) {
    setState(() {
      if (_selectedSupport.contains(option)) {
        _selectedSupport.remove(option);
      } else {
        _selectedSupport.add(option);
      }
    });
  }

  void _save() {
    SurvivorProfileScope.of(context).updateSupportPreferences(
      _selectedSupport.toList(),
      _selectedComfort,
    );
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return OnboardingShell(
      currentStep: widget.stepNumber,
      totalSteps: widget.totalSteps,
      onContinue: _save,
      onBack: widget.onBack,
      onSkip: () {
        SurvivorProfileScope.of(context).updateSupportPreferences([], null);
        widget.onSkip();
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeading(
            title: 'What kind of support feels comfortable?',
            subtitle:
                'You decide what support you want. You can change this anytime.',
          ),
          ..._supportOptions.map((o) => SelectableOptionCard(
                label: o,
                selected: _selectedSupport.contains(o),
                onTap: () => _toggleSupport(o),
              )),
          const SizedBox(height: 24),
          Text(
            'How comfortable are you with talking to someone?',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Optional — choose what feels right.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(150)),
          ),
          const SizedBox(height: 16),
          ..._comfortOptions.map((o) => SelectableOptionCard(
                label: o,
                selected: _selectedComfort == o,
                onTap: () =>
                    setState(() => _selectedComfort = _selectedComfort == o ? null : o),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
