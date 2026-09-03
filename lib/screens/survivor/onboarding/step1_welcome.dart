import 'package:flutter/material.dart';

class Step1Welcome extends StatelessWidget {
  final VoidCallback onBegin;
  final VoidCallback onSkip;

  const Step1Welcome({super.key, required this.onBegin, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.favorite_rounded, size: 56, color: cs.primary),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome to NIRBHAYA',
                    style: theme.textTheme.displaySmall
                        ?.copyWith(color: cs.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your recovery. Your choices. Your pace.',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: cs.onSurface.withAlpha(170),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'This is your private recovery space. You can choose what you want to share and skip anything you\'re not comfortable answering.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: cs.onSurface.withAlpha(160),
                      height: 1.7,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  // Privacy indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer.withAlpha(120),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: cs.primary.withAlpha(40)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lock_outline_rounded,
                            color: cs.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your choices stay under your control.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  ElevatedButton(
                    onPressed: onBegin,
                    child: const Text("Let's begin"),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: onSkip,
                    child: Text(
                      'Skip for now',
                      style: TextStyle(
                          color: cs.onSurface.withAlpha(160)),
                    ),
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
