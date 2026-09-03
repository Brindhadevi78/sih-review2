import 'package:flutter/material.dart';
import '../../../app/app.dart';
import '../../../models/survivor_situation.dart';
import 'onboarding_shell.dart';

class Step7Confirmation extends StatelessWidget {
  final int stepNumber;
  final int totalSteps;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  const Step7Confirmation({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.onConfirm,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final profile = SurvivorProfileScope.of(context).profile;

    final situationLabel = profile?.primarySituation?.label ?? 'Prefer not to say';
    final concerns = profile?.currentConcerns ?? [];
    final support = profile?.supportPreferences ?? [];
    final activities = profile?.activityPreferences ?? [];
    final aiConsent = profile?.aiAnalysisConsent ?? false;

    return OnboardingShell(
      currentStep: stepNumber,
      totalSteps: totalSteps,
      continueLabel: 'Enter My Recovery Space',
      onContinue: onConfirm,
      onBack: onBack,
      onSkip: onConfirm,
      skipLabel: 'Enter anyway',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const StepHeading(
            title: 'You are in control.',
            subtitle:
                'Here is a summary of your choices. You can change these anytime from Settings and Privacy Center.',
          ),

          _SummaryCard(
            label: 'Your situation',
            value: situationLabel,
            icon: Icons.person_outline_rounded,
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _SummaryCard(
            label: 'Current concerns',
            value: concerns.isEmpty ? 'Not specified' : concerns.join(', '),
            icon: Icons.favorite_border_rounded,
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _SummaryCard(
            label: 'Support preferences',
            value: support.isEmpty ? 'Not specified' : support.join(', '),
            icon: Icons.volunteer_activism_outlined,
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _SummaryCard(
            label: 'Activity preferences',
            value: activities.isEmpty ? 'Not specified' : activities.join(', '),
            icon: Icons.self_improvement_rounded,
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _SummaryCard(
            label: 'AI analysis',
            value: aiConsent ? 'Allowed' : 'Not enabled',
            icon: aiConsent
                ? Icons.check_circle_outline_rounded
                : Icons.do_not_disturb_alt_outlined,
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withAlpha(80),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Privacy and security features will be implemented as part of the secure backend architecture.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withAlpha(150),
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ColorScheme cs;
  final ThemeData theme;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.primary.withAlpha(30)),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withAlpha(150),
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
