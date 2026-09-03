import 'package:flutter/material.dart';
import '../../../app/app.dart';
import 'onboarding_shell.dart';

class Step5ActivityPreferences extends StatefulWidget {
  final int stepNumber;
  final int totalSteps;
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const Step5ActivityPreferences({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.onContinue,
    required this.onBack,
    required this.onSkip,
  });

  @override
  State<Step5ActivityPreferences> createState() =>
      _Step5ActivityPreferencesState();
}

class _Step5ActivityPreferencesState extends State<Step5ActivityPreferences> {
  static const _groups = [
    _ActivityGroup('Relax', Icons.self_improvement_rounded, [
      'Breathing',
      'Meditation',
      'Grounding',
      'Calm music',
    ]),
    _ActivityGroup('Express', Icons.edit_note_rounded, [
      'Journaling',
      'Voice reflection',
      'Drawing',
      'Creative writing',
    ]),
    _ActivityGroup('Move', Icons.directions_walk_rounded, [
      'Walking',
      'Stretching',
      'Light exercise',
    ]),
    _ActivityGroup('Reconnect', Icons.groups_outlined, [
      'Trusted person',
      'Peer support',
      'Social activity',
    ]),
    _ActivityGroup('Grow', Icons.emoji_events_outlined, [
      'Confidence building',
      'Hobbies',
      'Learning',
      'Skill development',
    ]),
  ];

  final Set<String> _selected = {};

  void _toggle(String item) {
    setState(() {
      if (_selected.contains(item)) {
        _selected.remove(item);
      } else {
        _selected.add(item);
      }
    });
  }

  void _save() {
    SurvivorProfileScope.of(context)
        .updateActivityPreferences(_selected.toList());
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
        SurvivorProfileScope.of(context).updateActivityPreferences([]);
        widget.onSkip();
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeading(
            title: 'What kinds of activities feel comfortable for you?',
            subtitle:
                'Choose anything that sounds helpful. There are no right answers.',
          ),
          ..._groups.map((group) => _GroupSection(
                group: group,
                selected: _selected,
                onToggle: _toggle,
                theme: theme,
                cs: cs,
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ActivityGroup {
  final String name;
  final IconData icon;
  final List<String> items;
  const _ActivityGroup(this.name, this.icon, this.items);
}

class _GroupSection extends StatelessWidget {
  final _ActivityGroup group;
  final Set<String> selected;
  final void Function(String) onToggle;
  final ThemeData theme;
  final ColorScheme cs;

  const _GroupSection({
    required this.group,
    required this.selected,
    required this.onToggle,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 4),
          child: Row(
            children: [
              Icon(group.icon, size: 18, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                group.name,
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: cs.primary),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: group.items
              .map((item) => _Chip(
                    label: item,
                    selected: selected.contains(item),
                    onTap: () => onToggle(item),
                    cs: cs,
                    theme: theme,
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme cs;
  final ThemeData theme;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? cs.primaryContainer : cs.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? cs.primary : cs.primary.withAlpha(50),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: selected ? cs.primary : cs.onSurface,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
