import 'package:flutter/material.dart';
import '../../../models/recovery_activity.dart';

class ActivityCompletionScreen extends StatelessWidget {
  final RecoveryActivity activity;
  final VoidCallback onDone;
  final VoidCallback onTryAnother;
  final VoidCallback onBackToRecover;

  const ActivityCompletionScreen({
    super.key,
    required this.activity,
    required this.onDone,
    required this.onTryAnother,
    required this.onBackToRecover,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: cs.primaryContainer.withAlpha(60),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withAlpha(60),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(Icons.eco_rounded,
                        size: 48, color: cs.onPrimary),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Small step complete 🌱',
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You made time for yourself.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurface.withAlpha(160)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cs.primary.withAlpha(30)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(activity.icon, size: 18, color: cs.primary),
                        const SizedBox(width: 8),
                        Text(
                          activity.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.primary),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            activity.duration,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontSize: 11, color: cs.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onDone,
                      child: const Text('Done'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onTryAnother,
                      child: const Text('Try another activity'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: onBackToRecover,
                    child: const Text('Back to Recover'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
