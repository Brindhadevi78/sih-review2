import 'package:flutter/material.dart';

class LegalSupportScreen extends StatelessWidget {
  /// When true, the emergency section is scrolled into view automatically.
  final bool openEmergency;
  const LegalSupportScreen({super.key, this.openEmergency = false});

  @override
  Widget build(BuildContext context) {
    return _LegalSupportBody(openEmergency: openEmergency);
  }
}

class _LegalSupportBody extends StatefulWidget {
  final bool openEmergency;
  const _LegalSupportBody({required this.openEmergency});

  @override
  State<_LegalSupportBody> createState() => _LegalSupportBodyState();
}

class _LegalSupportBodyState extends State<_LegalSupportBody> {
  final _scrollCtrl = ScrollController();
  final _emergencyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.openEmergency) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEmergency());
    }
  }

  void _scrollToEmergency() {
    final ctx = _emergencyKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal & Women\'s Support'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollCtrl,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer.withAlpha(60),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cs.primary.withAlpha(25)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.gavel_rounded, size: 20, color: cs.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Explore resources at your own pace. '
                            'Nothing is shared without your choice.',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: cs.primary, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _DemoDisclaimer(cs: cs, theme: theme),
                  const SizedBox(height: 24),

                  // ── Women's Support ──────────────────────────────────────────
                  _ResourceSection(
                    title: 'Women\'s Support',
                    icon: Icons.favorite_border_rounded,
                    color: const Color(0xFFE8A598),
                    resources: const [
                      _Resource(
                        name: 'Women\'s Helpline (DEMO)',
                        purpose: 'Emotional support and guidance',
                        description:
                            'A helpline for women experiencing abuse or distress. '
                            'Trained counsellors provide confidential support.',
                        tag: 'Demo resource',
                      ),
                      _Resource(
                        name: 'Women\'s Shelter Network (DEMO)',
                        purpose: 'Safe accommodation and support',
                        description:
                            'Provides temporary safe housing and support services '
                            'for women and children fleeing unsafe situations.',
                        tag: 'Demo resource',
                      ),
                      _Resource(
                        name: 'Women\'s Rights Organisation (DEMO)',
                        purpose: 'Advocacy and empowerment',
                        description:
                            'Supports women in understanding their rights and '
                            'accessing appropriate services.',
                        tag: 'Demo resource',
                      ),
                    ],
                    cs: cs,
                    theme: theme,
                  ),
                  const SizedBox(height: 24),

                  // ── Legal Assistance ─────────────────────────────────────────
                  _ResourceSection(
                    title: 'Legal Assistance',
                    icon: Icons.gavel_rounded,
                    color: const Color(0xFF7B6FA0),
                    resources: const [
                      _Resource(
                        name: 'Legal Aid Service (DEMO)',
                        purpose: 'Free legal advice and representation',
                        description:
                            'Provides free or low-cost legal assistance for '
                            'survivors navigating legal processes.',
                        tag: 'Demo resource',
                      ),
                      _Resource(
                        name: 'Protection Order Information (DEMO)',
                        purpose: 'Understanding protection orders',
                        description:
                            'Information about how to apply for protection orders '
                            'and what they cover.',
                        tag: 'Demo resource',
                      ),
                      _Resource(
                        name: 'Workplace Rights Helpline (DEMO)',
                        purpose: 'Workplace harassment and rights',
                        description:
                            'Guidance on workplace harassment, discrimination '
                            'and your legal rights as an employee.',
                        tag: 'Demo resource',
                      ),
                    ],
                    cs: cs,
                    theme: theme,
                  ),
                  const SizedBox(height: 24),

                  // ── Online / Cyber Abuse Support ─────────────────────────────
                  _ResourceSection(
                    title: 'Online / Cyber Abuse Support',
                    icon: Icons.security_outlined,
                    color: const Color(0xFF64B5F6),
                    resources: const [
                      _Resource(
                        name: 'Cyber Safety Helpline (DEMO)',
                        purpose: 'Online harassment and digital safety',
                        description:
                            'Support for people experiencing cyberstalking, '
                            'online harassment, image-based abuse or digital threats.',
                        tag: 'Demo resource',
                      ),
                      _Resource(
                        name: 'Digital Evidence Guide (DEMO)',
                        purpose: 'Preserving evidence of online abuse',
                        description:
                            'Information on how to safely document and preserve '
                            'evidence of online abuse for legal purposes.',
                        tag: 'Demo resource',
                      ),
                      _Resource(
                        name: 'Platform Reporting Guide (DEMO)',
                        purpose: 'Reporting abuse on social platforms',
                        description:
                            'Step-by-step guidance on reporting abusive content '
                            'and accounts on major social media platforms.',
                        tag: 'Demo resource',
                      ),
                    ],
                    cs: cs,
                    theme: theme,
                  ),
                  const SizedBox(height: 24),

                  // ── Emergency / Immediate Safety ─────────────────────────────
                  _EmergencySection(
                    sectionKey: _emergencyKey,
                    cs: cs,
                    theme: theme,
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

// ── Emergency section ─────────────────────────────────────────────────────────

class _EmergencySection extends StatelessWidget {
  final GlobalKey sectionKey;
  final ColorScheme cs;
  final ThemeData theme;

  const _EmergencySection({
    required this.sectionKey,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFB74D).withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emergency_outlined,
                  size: 22, color: Color(0xFFE65100)),
              const SizedBox(width: 8),
              Text(
                'Emergency / Immediate Safety',
                style: theme.textTheme.titleLarge
                    ?.copyWith(color: const Color(0xFFE65100), fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'If you are in immediate danger, emergency services are available. '
            'Nothing is contacted automatically — you choose every action.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFBF360C), height: 1.5),
          ),
          const SizedBox(height: 16),
          _EmergencyOption(
            icon: Icons.local_police_outlined,
            title: 'Emergency Services',
            subtitle: 'Police, ambulance, fire',
            onTap: () => _showEmergencyConfirm(
              context,
              title: 'Emergency Services',
              body:
                  'In a real implementation, this would allow you to call emergency services.\n\n'
                  'Demo only — no call is made.',
            ),
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 10),
          _EmergencyOption(
            icon: Icons.person_outline_rounded,
            title: 'Trusted Contact',
            subtitle: 'Reach out to someone you trust',
            onTap: () => _showEmergencyConfirm(
              context,
              title: 'Trusted Contact',
              body:
                  'In a real implementation, this would allow you to message a trusted contact.\n\n'
                  'Demo only — no message is sent.',
            ),
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 10),
          _EmergencyOption(
            icon: Icons.favorite_border_rounded,
            title: 'Women\'s Support Line',
            subtitle: 'Speak with a support worker',
            onTap: () => _showEmergencyConfirm(
              context,
              title: 'Women\'s Support Line',
              body:
                  'In a real implementation, this would connect you with a women\'s support helpline.\n\n'
                  'Demo only — no call is made.',
            ),
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 10),
          _EmergencyOption(
            icon: Icons.location_on_outlined,
            title: 'Nearby Support',
            subtitle: 'Find support services near you',
            onTap: () => _showEmergencyConfirm(
              context,
              title: 'Nearby Support',
              body:
                  'In a real implementation, this would help you find nearby support services.\n\n'
                  'Demo only — no location is shared.',
            ),
            cs: cs,
            theme: theme,
          ),
        ],
      ),
    );
  }

  void _showEmergencyConfirm(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Do you want to continue?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(body, style: const TextStyle(height: 1.5)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(150))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Demo only — $title was not contacted.'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class _EmergencyOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final ColorScheme cs;
  final ThemeData theme;

  const _EmergencyOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withAlpha(200),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE0B2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFFE65100)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFFBF360C), fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: Color(0xFFE65100)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Resource section ──────────────────────────────────────────────────────────

class _ResourceSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<_Resource> resources;
  final ColorScheme cs;
  final ThemeData theme;

  const _ResourceSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.resources,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 10),
            Text(
              title.toUpperCase(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 0.8,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...resources.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ResourceCard(
                resource: r,
                color: color,
                cs: cs,
                theme: theme,
              ),
            )),
      ],
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final _Resource resource;
  final Color color;
  final ColorScheme cs;
  final ThemeData theme;

  const _ResourceCard({
    required this.resource,
    required this.color,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(30)),
        boxShadow: [
          BoxShadow(
              color: color.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(resource.name,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(resource.purpose,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: color, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  resource.tag,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 10,
                      color: color,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(resource.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withAlpha(160), height: 1.5)),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => _showLearnMore(context),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 36),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: BorderSide(color: color.withAlpha(120)),
              foregroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }

  void _showLearnMore(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(resource.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(resource.description,
                style: const TextStyle(height: 1.6)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(80),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Demo resource — verify availability before relying on it.',
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
}

// ── Data ──────────────────────────────────────────────────────────────────────

class _Resource {
  final String name;
  final String purpose;
  final String description;
  final String tag;

  const _Resource({
    required this.name,
    required this.purpose,
    required this.description,
    required this.tag,
  });
}

// ── Demo disclaimer ───────────────────────────────────────────────────────────

class _DemoDisclaimer extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _DemoDisclaimer({required this.cs, required this.theme});

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
              'DEMO — These are example resources. '
              'Verify availability before relying on any resource.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12, color: cs.onSurface.withAlpha(160)),
            ),
          ),
        ],
      ),
    );
  }
}
