import 'package:flutter/material.dart';
import '../../app/app.dart';
import '../../models/recovery_state.dart';

class ProfessionalSupportScreen extends StatelessWidget {
  const ProfessionalSupportScreen({super.key});

  static const _professionals = [
    _ProEntry(
      name: 'Dr. Priya Sharma (DEMO)',
      role: 'Psychologist',
      area: 'Trauma-informed support, anxiety, emotional well-being',
      availability: 'Demo — not a real booking',
    ),
    _ProEntry(
      name: 'Counsellor Meena Iyer (DEMO)',
      role: 'Counsellor',
      area: 'Relationship concerns, confidence, personal growth',
      availability: 'Demo — not a real booking',
    ),
    _ProEntry(
      name: 'Dr. Anita Rao (DEMO)',
      role: 'Clinical Psychologist',
      area: 'Stress, low mood, recovery support',
      availability: 'Demo — not a real booking',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Support'),
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
                  _InfoBanner(
                    icon: Icons.psychology_outlined,
                    title: 'Professional Support',
                    body: 'Explore counsellors, psychologists and trained support '
                        'professionals. You choose if and when to reach out.',
                    cs: cs,
                    theme: theme,
                  ),
                  const SizedBox(height: 8),
                  _DemoNotice(cs: cs, theme: theme),
                  const SizedBox(height: 20),
                  Text('Available professionals',
                      style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  ..._professionals.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ProfessionalCard(
                          entry: p,
                          cs: cs,
                          theme: theme,
                          onLearnMore: () => _showLearnMore(context, p),
                          onRequestSupport: () =>
                              _openConsent(context, p.name),
                        ),
                      )),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLearnMore(BuildContext context, _ProEntry p) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(p.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Role: ${p.role}'),
            const SizedBox(height: 6),
            Text('Area: ${p.area}'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.secondaryContainer.withAlpha(80),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'DEMO — This is an example entry. No real professional is connected.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _openConsent(BuildContext context, String professionalName) {
    SupportHistoryScope.of(context).record('Explored professional support');
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ConsentScreen(recipientLabel: professionalName),
    ));
  }
}

// ── Data ──────────────────────────────────────────────────────────────────────

class _ProEntry {
  final String name;
  final String role;
  final String area;
  final String availability;
  const _ProEntry({
    required this.name,
    required this.role,
    required this.area,
    required this.availability,
  });
}

// ── Professional card ─────────────────────────────────────────────────────────

class _ProfessionalCard extends StatelessWidget {
  final _ProEntry entry;
  final VoidCallback onLearnMore;
  final VoidCallback onRequestSupport;
  final ColorScheme cs;
  final ThemeData theme;

  const _ProfessionalCard({
    required this.entry,
    required this.onLearnMore,
    required this.onRequestSupport,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.primary.withAlpha(20)),
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
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.person_outline_rounded,
                    color: cs.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.name,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(entry.role,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: cs.primary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(entry.area,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurface.withAlpha(160))),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: cs.secondaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(entry.availability,
                style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 11, color: cs.onSurface.withAlpha(160))),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              OutlinedButton(
                onPressed: onLearnMore,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 38),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Learn More'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: onRequestSupport,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 38),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Request Support'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Consent screen ────────────────────────────────────────────────────────────

class ConsentScreen extends StatefulWidget {
  final String recipientLabel;
  const ConsentScreen({super.key, required this.recipientLabel});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Choice'),
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
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('What would you like to share?',
                      style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  Text(
                    'You are in control of what you share.',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: cs.onSurface.withAlpha(160)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer.withAlpha(60),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Sharing with: ${widget.recipientLabel}',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: cs.primary, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ConsentOption(
                    index: 0,
                    selected: _selected,
                    icon: Icons.checklist_rounded,
                    title: 'Selected information',
                    subtitle: 'You choose exactly what to include.',
                    onTap: () => setState(() => _selected = 0),
                    cs: cs,
                    theme: theme,
                  ),
                  const SizedBox(height: 10),
                  _ConsentOption(
                    index: 1,
                    selected: _selected,
                    icon: Icons.mood_rounded,
                    title: 'Only my latest check-in',
                    subtitle: 'Mood, confidence and social connection only.',
                    onTap: () => setState(() => _selected = 1),
                    cs: cs,
                    theme: theme,
                  ),
                  const SizedBox(height: 10),
                  _ConsentOption(
                    index: 2,
                    selected: _selected,
                    icon: Icons.block_rounded,
                    title: 'Nothing',
                    subtitle: 'No information will be shared.',
                    onTap: () => setState(() => _selected = 2),
                    cs: cs,
                    theme: theme,
                  ),
                  const SizedBox(height: 24),
                  if (_selected != null)
                    ElevatedButton(
                      onPressed: () => _proceed(context),
                      child: const Text('Continue'),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _proceed(BuildContext context) {
    switch (_selected) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const SelectedInfoScreen(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const LatestCheckinShareScreen(),
        ));
        break;
      case 2:
        _showNothingShared(context);
        break;
    }
  }

  void _showNothingShared(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('No information shared'),
        content: const Text(
            'No information will be shared. '
            'You can return to support options whenever you feel ready.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// ── Consent option tile ───────────────────────────────────────────────────────

class _ConsentOption extends StatelessWidget {
  final int index;
  final int? selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final ColorScheme cs;
  final ThemeData theme;

  const _ConsentOption({
    required this.index,
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == index;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? cs.primaryContainer.withAlpha(80) : cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? cs.primary : cs.primary.withAlpha(30),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 22,
                color:
                    isSelected ? cs.primary : cs.onSurface.withAlpha(140)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? cs.primary : null)),
                  Text(subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withAlpha(150))),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: cs.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Selected information screen ───────────────────────────────────────────────

class SelectedInfoScreen extends StatefulWidget {
  const SelectedInfoScreen({super.key});

  @override
  State<SelectedInfoScreen> createState() => _SelectedInfoScreenState();
}

class _SelectedInfoScreenState extends State<SelectedInfoScreen> {
  final Set<int> _chosen = {};

  static const _items = [
    'Mood / check-in',
    'Recovery preferences',
    'Selected recovery progress',
    'Personal message',
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Information'),
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
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Choose what to include',
                      style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer.withAlpha(60),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lock_outline_rounded,
                            size: 16, color: cs.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Private journal, voice recordings and sensitive details are never included.',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: cs.primary, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._items.asMap().entries.map((e) => CheckboxListTile(
                        value: _chosen.contains(e.key),
                        onChanged: (v) => setState(() {
                          if (v == true) {
                            _chosen.add(e.key);
                          } else {
                            _chosen.remove(e.key);
                          }
                        }),
                        title: Text(e.value,
                            style: theme.textTheme.bodyLarge),
                        activeColor: cs.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      )),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed:
                        _chosen.isEmpty ? null : () => _confirm(context),
                    child: const Text('Confirm Selection'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('You chose exactly what to share.'),
        content: const Text(
            'Demo only — no information was actually sent.\n\n'
            'In a real implementation, only your selected items would be shared '
            'with your explicit consent.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context)
                ..pop()
                ..pop()
                ..pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

// ── Latest check-in share screen ──────────────────────────────────────────────

class LatestCheckinShareScreen extends StatelessWidget {
  const LatestCheckinShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final reflections = ReflectionScope.of(context);
    final latest = reflections.getTodayReflection() ??
        (reflections.allReflections.isNotEmpty
            ? reflections.allReflections.first
            : null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest Check-in'),
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
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('What would be shared',
                      style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  Text(
                    'Only these items — nothing else.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurface.withAlpha(160)),
                  ),
                  const SizedBox(height: 20),
                  if (latest == null)
                    _InfoCard(
                      cs: cs,
                      child: Text(
                        'No check-in is available to share yet.',
                        style: theme.textTheme.bodyLarge,
                      ),
                    )
                  else
                    _InfoCard(
                      cs: cs,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (latest.mood != null)
                            _ShareRow(
                              label: 'Mood',
                              value:
                                  '${latest.mood!.emoji} ${latest.mood!.label}',
                              theme: theme,
                              cs: cs,
                            ),
                          if (latest.confidence != null)
                            _ShareRow(
                              label: 'Confidence',
                              value: '${latest.confidence}/5',
                              theme: theme,
                              cs: cs,
                            ),
                          if (latest.socialConnection != null)
                            _ShareRow(
                              label: 'Social connection',
                              value: '${latest.socialConnection}/5',
                              theme: theme,
                              cs: cs,
                            ),
                          if (latest.mood == null &&
                              latest.confidence == null &&
                              latest.socialConnection == null)
                            Text(
                              'No mood, confidence or connection data recorded in this check-in.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurface.withAlpha(150)),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (latest != null)
                    ElevatedButton(
                      onPressed: () => _confirm(context),
                      child: const Text('Confirm & Continue'),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Demo only'),
        content: const Text(
            'No information was actually sent.\n\n'
            'In a real implementation, only your latest check-in would be shared '
            'with your explicit consent.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context)
                ..pop()
                ..pop()
                ..pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final ColorScheme cs;
  final ThemeData theme;

  const _InfoBanner({
    required this.icon,
    required this.title,
    required this.body,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(60),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withAlpha(25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        theme.textTheme.titleLarge?.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(body,
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

class _DemoNotice extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _DemoNotice({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.secondaryContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.secondary.withAlpha(60)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: cs.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'DEMO — These are example entries. No real professionals are connected.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontSize: 12, color: cs.onSurface.withAlpha(160)),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  final ColorScheme cs;
  const _InfoCard({required this.child, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withAlpha(20)),
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

class _ShareRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final ColorScheme cs;

  const _ShareRow({
    required this.label,
    required this.value,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: cs.onSurface.withAlpha(150))),
          ),
          Text(value,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
