import 'package:flutter/material.dart';
import '../../app/app.dart';

class PeerSupportScreen extends StatelessWidget {
  const PeerSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peer Support'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  _InfoCard(
                    cs: cs,
                    color: cs.primaryContainer.withAlpha(60),
                    borderColor: cs.primary.withAlpha(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.groups_outlined,
                                size: 22, color: cs.primary),
                            const SizedBox(width: 10),
                            Text('Peer Support',
                                style: theme.textTheme.titleLarge),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Peer support is voluntary. You choose whether to connect, '
                          'and you can stop at any time.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                              color: cs.onSurface.withAlpha(170), height: 1.6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // What peer support means
                  _SectionCard(
                    title: 'What is peer support?',
                    icon: Icons.favorite_border_rounded,
                    cs: cs,
                    theme: theme,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BulletPoint(
                          text:
                              'Peer supporters are people who have chosen to support others through similar experiences.',
                          cs: cs,
                          theme: theme,
                        ),
                        _BulletPoint(
                          text:
                              'They offer a listening ear, encouragement and shared understanding.',
                          cs: cs,
                          theme: theme,
                        ),
                        _BulletPoint(
                          text:
                              'Peer support is not professional counselling or therapy.',
                          cs: cs,
                          theme: theme,
                        ),
                        _BulletPoint(
                          text:
                              'All peer supporters in this platform are volunteers.',
                          cs: cs,
                          theme: theme,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // What they can help with
                  _SectionCard(
                    title: 'What a peer supporter can help with',
                    icon: Icons.check_circle_outline_rounded,
                    cs: cs,
                    theme: theme,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BulletPoint(
                            text: 'Listening without judgement',
                            cs: cs,
                            theme: theme),
                        _BulletPoint(
                            text: 'Sharing their own experience (if they choose)',
                            cs: cs,
                            theme: theme),
                        _BulletPoint(
                            text: 'Offering encouragement and emotional support',
                            cs: cs,
                            theme: theme),
                        _BulletPoint(
                            text:
                                'Pointing you toward resources and information',
                            cs: cs,
                            theme: theme),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // What they cannot provide
                  _SectionCard(
                    title: 'What peer support cannot provide',
                    icon: Icons.do_not_disturb_alt_outlined,
                    cs: cs,
                    theme: theme,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BulletPoint(
                            text: 'Professional counselling or therapy',
                            cs: cs,
                            theme: theme),
                        _BulletPoint(
                            text: 'Medical or legal advice',
                            cs: cs,
                            theme: theme),
                        _BulletPoint(
                            text: 'Crisis intervention',
                            cs: cs,
                            theme: theme),
                        _BulletPoint(
                            text: 'Guaranteed confidentiality beyond this app',
                            cs: cs,
                            theme: theme),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Privacy expectations
                  _SectionCard(
                    title: 'Privacy expectations',
                    icon: Icons.lock_outline_rounded,
                    cs: cs,
                    theme: theme,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BulletPoint(
                          text:
                              'Your private journal and voice recordings are never shared with peer supporters.',
                          cs: cs,
                          theme: theme,
                        ),
                        _BulletPoint(
                          text:
                              'You choose what information, if any, to share before any connection.',
                          cs: cs,
                          theme: theme,
                        ),
                        _BulletPoint(
                          text:
                              'You can stop participating at any time without explanation.',
                          cs: cs,
                          theme: theme,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // How to stop
                  _SectionCard(
                    title: 'How to stop participation',
                    icon: Icons.exit_to_app_rounded,
                    cs: cs,
                    theme: theme,
                    child: Text(
                      'You can withdraw from peer support at any time. '
                      'Simply choose not to continue — no explanation is required. '
                      'Your recovery space remains private and unchanged.',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(height: 1.6, color: cs.onSurface.withAlpha(170)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Become a peer supporter
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: cs.primary.withAlpha(25)),
                      boxShadow: [
                        BoxShadow(
                            color: cs.primary.withAlpha(10),
                            blurRadius: 8,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.volunteer_activism_outlined,
                                size: 20, color: cs.primary),
                            const SizedBox(width: 8),
                            Text('Interested in becoming a Peer Supporter?',
                                style: theme.textTheme.titleLarge
                                    ?.copyWith(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'If you feel ready to support others, you can learn more '
                          'about what it involves. This is entirely voluntary.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withAlpha(160), height: 1.5),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              SupportHistoryScope.of(context)
                                  .record('Viewed peer supporter information');
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    const PeerSupporterInterestScreen(),
                              ));
                            },
                            icon: const Icon(Icons.arrow_forward_rounded,
                                size: 18),
                            label: const Text(
                                'Learn about becoming a Peer Supporter'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 48),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Peer supporter interest / application flow ────────────────────────────────

class PeerSupporterInterestScreen extends StatelessWidget {
  const PeerSupporterInterestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peer Supporter Interest'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Interested in Peer Support?',
                      style: theme.textTheme.displaySmall),
                  const SizedBox(height: 8),
                  Text(
                    'This is a voluntary pathway. Read through each step at your own pace.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurface.withAlpha(160), height: 1.6),
                  ),
                  const SizedBox(height: 20),

                  // Step cards
                  _StepCard(
                    number: '1',
                    title: 'Learn',
                    description:
                        'Understand what peer support involves and what is expected.',
                    cs: cs,
                    theme: theme,
                  ),
                  const SizedBox(height: 10),
                  _StepCard(
                    number: '2',
                    title: 'Understand responsibilities',
                    description:
                        'Peer supporters listen, encourage and respect boundaries. '
                        'They do not provide professional advice.',
                    cs: cs,
                    theme: theme,
                  ),
                  const SizedBox(height: 10),
                  _StepCard(
                    number: '3',
                    title: 'Consent',
                    description:
                        'You choose whether to apply. Nothing happens automatically.',
                    cs: cs,
                    theme: theme,
                  ),
                  const SizedBox(height: 10),
                  _StepCard(
                    number: '4',
                    title: 'Apply',
                    description:
                        'Submit a voluntary expression of interest. '
                        'This is saved locally for demo purposes only.',
                    cs: cs,
                    theme: theme,
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer.withAlpha(60),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            size: 16, color: cs.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You remain a survivor throughout this process. '
                            'Expressing interest does not change your role.',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: cs.primary, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const PeerSupportApplicationScreen()),
                    ),
                    child: const Text('Continue to Application'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Not now'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Peer supporter application screen ────────────────────────────────────────

class PeerSupportApplicationScreen extends StatefulWidget {
  const PeerSupportApplicationScreen({super.key});

  @override
  State<PeerSupportApplicationScreen> createState() =>
      _PeerSupportApplicationScreenState();
}

class _PeerSupportApplicationScreenState
    extends State<PeerSupportApplicationScreen> {
  final _nameCtrl = TextEditingController();
  final _whyCtrl = TextEditingController();
  final _availabilityCtrl = TextEditingController();
  final Set<String> _areas = {};
  bool _submitted = false;

  static const _supportAreas = [
    'Emotional support',
    'Listening',
    'Sharing my experience',
    'Workplace situations',
    'Online / digital safety',
    'Childhood / past experiences',
    'General recovery support',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _whyCtrl.dispose();
    _availabilityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    if (_submitted) {
      return _SubmittedScreen(cs: cs, theme: theme);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expression of Interest'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer.withAlpha(60),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.tune_rounded, size: 16, color: cs.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You choose whether to apply. All fields are optional.',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: cs.primary, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Preferred name
                  Text('Preferred name (optional)',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'How would you like to be known?',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Why interested
                  Text('Why are you interested? (optional)',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _whyCtrl,
                    maxLines: 4,
                    maxLength: 500,
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(
                      hintText: 'Share as much or as little as you like.',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Areas comfortable supporting
                  Text('Areas you feel comfortable supporting (optional)',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _supportAreas.map((area) {
                      final selected = _areas.contains(area);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (selected) {
                            _areas.remove(area);
                          } else {
                            _areas.add(area);
                          }
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? cs.primaryContainer
                                : cs.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? cs.primary
                                  : cs.primary.withAlpha(40),
                              width: selected ? 1.5 : 1,
                            ),
                          ),
                          child: Text(
                            area,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: selected ? cs.primary : cs.onSurface,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Availability
                  Text('Availability (optional)',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _availabilityCtrl,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Weekday evenings, weekends',
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Consent note before submit
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cs.primary.withAlpha(25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lock_outline_rounded,
                                size: 16, color: cs.primary),
                            const SizedBox(width: 8),
                            Text('Before you submit',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: cs.primary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• This application is saved locally on your device only.\n'
                          '• No information is sent to any organisation.\n'
                          '• You remain a survivor — this does not change your role.\n'
                          '• You can withdraw at any time.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withAlpha(160), height: 1.6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () => _confirmSubmit(context),
                    child: const Text('Submit Expression of Interest'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmSubmit(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('You choose whether to apply.'),
        content: const Text(
            'Submitting this saves your expression of interest locally.\n\n'
            'No information is sent anywhere. '
            'You remain a survivor and your role does not change.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(color: cs.onSurface.withAlpha(150))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              SupportHistoryScope.of(context)
                  .record('Started peer supporter application');
              PlatformAnalyticsScope.of(context).incrementPeerSupportApplications();
              setState(() => _submitted = true);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

// ── Submitted confirmation ────────────────────────────────────────────────────

class _SubmittedScreen extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _SubmittedScreen({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_rounded,
                        size: 40, color: cs.primary),
                  ),
                  const SizedBox(height: 28),
                  Text('Demo application saved locally.',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text(
                    'No information was sent to any organisation.\n\n'
                    'You remain a survivor. Your role has not changed.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurface.withAlpha(160), height: 1.6),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                          ..pop()
                          ..pop()
                          ..pop();
                      },
                      child: const Text('Back to Support'),
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

// ── Shared widgets ────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final Widget child;
  final ColorScheme cs;
  final Color? color;
  final Color? borderColor;

  const _InfoCard({
    required this.child,
    required this.cs,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color ?? cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor ?? cs.primary.withAlpha(20)),
        boxShadow: [
          BoxShadow(
              color: cs.primary.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final ColorScheme cs;
  final ThemeData theme;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withAlpha(18)),
        boxShadow: [
          BoxShadow(
              color: cs.primary.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: cs.primary),
              const SizedBox(width: 8),
              Text(title, style: theme.textTheme.titleLarge?.copyWith(fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  final ColorScheme cs;
  final ThemeData theme;

  const _BulletPoint(
      {required this.text, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: cs.primary.withAlpha(160),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(height: 1.5, color: cs.onSurface.withAlpha(170))),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final ColorScheme cs;
  final ThemeData theme;

  const _StepCard({
    required this.number,
    required this.title,
    required this.description,
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
        border: Border.all(color: cs.primary.withAlpha(20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(number,
                  style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withAlpha(160), height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
