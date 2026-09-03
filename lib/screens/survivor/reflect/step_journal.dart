import 'package:flutter/material.dart';
import 'check_in_shell.dart';

class StepJournal extends StatefulWidget {
  final int stepNumber;
  final int totalSteps;
  final String? text;
  final void Function(String?) onChanged;
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  const StepJournal({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.text,
    required this.onChanged,
    required this.onContinue,
    required this.onSkip,
    required this.onBack,
  });

  @override
  State<StepJournal> createState() => _StepJournalState();
}

class _StepJournalState extends State<StepJournal> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.text ?? '');
    _ctrl.addListener(() {
      final t = _ctrl.text.trim().isEmpty ? null : _ctrl.text;
      widget.onChanged(t);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _showVoiceDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.mic_rounded),
            SizedBox(width: 8),
            Text('Voice reflection'),
          ],
        ),
        content: const Text(
            'Voice recording will be available in a future version.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final charCount = _ctrl.text.length;

    return CheckInShell(
      stepNumber: widget.stepNumber,
      totalSteps: widget.totalSteps,
      onContinue: widget.onContinue,
      onSkip: widget.onSkip,
      onBack: widget.onBack,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CheckInHeading(
            title: 'Would you like to write something down?',
            subtitle:
                'This space is yours. You can write as much or as little as you want.',
          ),

          // Privacy note
          Row(
            children: [
              Icon(Icons.lock_outline_rounded,
                  size: 14, color: cs.primary),
              const SizedBox(width: 6),
              Text('Private reflection',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),

          // Text field
          TextField(
            controller: _ctrl,
            maxLines: 8,
            maxLength: 1000,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: 'What\'s on your mind today?',
              hintStyle: TextStyle(color: cs.onSurface.withAlpha(100)),
              alignLabelWithHint: true,
              counterText: '$charCount / 1000',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),

          // Voice reflection placeholder
          OutlinedButton.icon(
            onPressed: _showVoiceDialog,
            icon: const Icon(Icons.mic_rounded, size: 18),
            label: const Text('Voice reflection'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 4),
          Text('Prefer speaking?',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurface.withAlpha(130), fontSize: 12)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
