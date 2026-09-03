import 'package:flutter/material.dart';
import '../../../app/app.dart';
import 'onboarding_shell.dart';

class Step6AiConsent extends StatefulWidget {
  final int stepNumber;
  final int totalSteps;
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const Step6AiConsent({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.onContinue,
    required this.onBack,
    required this.onSkip,
  });

  @override
  State<Step6AiConsent> createState() => _Step6AiConsentState();
}

class _Step6AiConsentState extends State<Step6AiConsent> {
  void _choose(bool value) {
    SurvivorProfileScope.of(context).updateAiConsent(value);
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return OnboardingShell(
      currentStep: widget.stepNumber,
      totalSteps: widget.totalSteps,
      continueLabel: 'Not Now',
      onContinue: () {
        SurvivorProfileScope.of(context).updateAiConsent(false);
        widget.onSkip();
      },
      onBack: widget.onBack,
      onSkip: () {
        SurvivorProfileScope.of(context).updateAiConsent(false);
        widget.onSkip();
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const StepHeading(
            title: 'Your reflections, your choice.',
            subtitle:
                'NIRBHAYA can optionally analyze your check-ins and reflections to identify general emotional patterns and suggest supportive activities.',
          ),

          // Pattern examples
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withAlpha(100),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cs.primary.withAlpha(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('We may identify patterns such as:',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Calm', 'Positive', 'Sad', 'Stressed', 'Anxious', 'Overwhelmed']
                      .map((p) => Chip(
                            label: Text(p,
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: cs.primary)),
                            backgroundColor: cs.surface,
                            side: BorderSide(color: cs.primary.withAlpha(60)),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Disclaimer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 18, color: cs.onSurface.withAlpha(140)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'NIRBHAYA does not diagnose medical conditions.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withAlpha(160),
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          Text(
            'Would you like NIRBHAYA to analyze your reflections?',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () => _choose(true),
            child: const Text('Allow AI Analysis'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => _choose(false),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Not Now'),
          ),
          const SizedBox(height: 20),

          Text(
            'You can change this later in Privacy Center.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(130)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
