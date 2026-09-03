import 'package:flutter/material.dart';
import '../../../models/recovery_state.dart';
import '../../../providers/reflection_provider.dart';
import 'check_in_shell.dart';

class StepSummary extends StatelessWidget {
  final int stepNumber;
  final int totalSteps;
  final CheckInMood? mood;
  final int? confidence;
  final int? connection;
  final String? journalText;
  final bool aiRequested;
  final VoidCallback onSave;
  final VoidCallback onBack;
  final VoidCallback onEditMood;

  const StepSummary({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.mood,
    required this.confidence,
    required this.connection,
    required this.journalText,
    required this.aiRequested,
    required this.onSave,
    required this.onBack,
    required this.onEditMood,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return CheckInShell(
      stepNumber: stepNumber,
      totalSteps: totalSteps,
      continueLabel: 'Save Reflection',
      onContinue: onSave,
      onBack: onBack,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CheckInHeading(
            title: 'Your reflection',
            subtitle:
                'Take a moment to review before saving. You can go back to edit.',
          ),

          _SummaryRow(
            label: 'Mood',
            value: mood != null
                ? '${mood!.emoji} ${mood!.label}'
                : 'Not recorded',
            cs: cs,
            theme: theme,
          ),
          _SummaryRow(
            label: 'Confidence',
            value: confidenceLabel(confidence),
            cs: cs,
            theme: theme,
          ),
          _SummaryRow(
            label: 'Connection',
            value: connectionLabel(connection),
            cs: cs,
            theme: theme,
          ),
          _SummaryRow(
            label: 'Note',
            value: journalText != null && journalText!.isNotEmpty
                ? journalText!
                : 'Not recorded',
            cs: cs,
            theme: theme,
            multiline: true,
          ),
          _SummaryRow(
            label: 'AI analysis',
            value: aiRequested ? 'Requested' : 'Not requested',
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 16),

          TextButton.icon(
            onPressed: onEditMood,
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text('Edit'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme cs;
  final ThemeData theme;
  final bool multiline;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.cs,
    required this.theme,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withAlpha(25)),
      ),
      child: multiline
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withAlpha(150),
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            )
          : Row(
              children: [
                Text('$label: ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withAlpha(150),
                        fontWeight: FontWeight.w500)),
                Expanded(
                  child: Text(value,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
    );
  }
}
