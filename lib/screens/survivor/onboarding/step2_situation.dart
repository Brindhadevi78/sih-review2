import 'package:flutter/material.dart';
import '../../../app/app.dart';
import '../../../models/survivor_situation.dart';
import 'onboarding_shell.dart';

class Step2Situation extends StatefulWidget {
  final int stepNumber;
  final int totalSteps;
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const Step2Situation({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.onContinue,
    required this.onBack,
    required this.onSkip,
  });

  @override
  State<Step2Situation> createState() => _Step2SituationState();
}

class _Step2SituationState extends State<Step2Situation> {
  PrimarySituation? _selected;
  final Set<String> _subcategories = {};

  void _selectPrimary(PrimarySituation s) {
    setState(() {
      _selected = s;
      _subcategories.clear();
    });
  }

  void _toggleSub(String sub) {
    setState(() {
      if (_subcategories.contains(sub)) {
        _subcategories.remove(sub);
      } else {
        _subcategories.add(sub);
      }
    });
  }

  void _save() {
    SurvivorProfileScope.of(context)
        .updateSituation(_selected, _subcategories.toList());
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    final subs = _selected != null
        ? (situationSubcategories[_selected] ?? [])
        : <String>[];

    return OnboardingShell(
      currentStep: widget.stepNumber,
      totalSteps: widget.totalSteps,
      onContinue: _save,
      onBack: widget.onBack,
      onSkip: () {
        SurvivorProfileScope.of(context).updateSituation(null, []);
        widget.onSkip();
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeading(
            title: 'What would you like your recovery space to understand?',
            subtitle:
                "You don't need to share details. Choose only what feels comfortable.",
          ),

          // Primary categories
          ...PrimarySituation.values.map((s) => SelectableOptionCard(
                label: s.label,
                selected: _selected == s,
                onTap: () => _selectPrimary(s),
              )),

          // Subcategories
          if (subs.isNotEmpty && _selected != PrimarySituation.preferNotToSay) ...[
            const SizedBox(height: 20),
            Text(
              'You may also select specific areas (optional):',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(160),
                  ),
            ),
            const SizedBox(height: 12),
            ...subs.map((sub) => SelectableOptionCard(
                  label: sub,
                  selected: _subcategories.contains(sub),
                  onTap: () => _toggleSub(sub),
                )),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
