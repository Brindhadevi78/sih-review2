import 'package:flutter/material.dart';
import '../../../app/app.dart';
import '../../../app/routes/app_routes.dart';
import 'check_in_shell.dart';

class StepAiConsent extends StatelessWidget {
  final int stepNumber;
  final int totalSteps;
  final VoidCallback onAllow;
  final VoidCallback onDecline;
  final VoidCallback onBack;

  const StepAiConsent({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.onAllow,
    required this.onDecline,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final profile = SurvivorProfileScope.of(context).profile;
    final globalConsent = profile?.aiAnalysisConsent ?? false;

    return CheckInShell(
      stepNumber: stepNumber,
      totalSteps: totalSteps,
      continueLabel: 'Keep private',
      onContinue: onDecline,
      onBack: onBack,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CheckInHeading(
            title: 'Your reflection, your choice.',
            subtitle:
                'NIRBHAYA can look at your check-in to identify general emotional patterns and suggest supportive activities.',
          ),

          if (globalConsent) ...[
            // Global consent is ON — offer per-reflection choice
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withAlpha(100),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cs.primary.withAlpha(40)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline_rounded,
                      color: cs.primary, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your AI reflection preference is enabled.',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: cs.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Would you like to analyze this reflection?',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onAllow,
              child: const Text('Analyze this reflection'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onDecline,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Don\'t analyze this'),
            ),
          ] else ...[
            // Global consent is OFF
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cs.primary.withAlpha(30)),
              ),
              child: Row(
                children: [
                  Icon(Icons.do_not_disturb_alt_outlined,
                      color: cs.onSurface.withAlpha(140), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'AI reflection analysis is currently turned off.',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: cs.onSurface.withAlpha(160)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onDecline,
              child: const Text('Keep private'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.privacyCenter),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Change AI preference'),
            ),
          ],

          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 16, color: cs.onSurface.withAlpha(120)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'This is a general emotional reflection, not a medical diagnosis.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withAlpha(140),
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
