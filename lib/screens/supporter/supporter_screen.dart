import 'package:flutter/material.dart';
import '../../app/app.dart';
import '../../app/routes/app_routes.dart';
import '../../models/user_role.dart';

class SupporterScreen extends StatelessWidget {
  const SupporterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final subRole = session.supporterSubRole;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              session.clear();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DashboardHeader(session: session, subRole: subRole),
                  const SizedBox(height: 16),
                  _PrivacyBanner(),
                  const SizedBox(height: 20),
                  _RoleContent(subRole: subRole),
                  const SizedBox(height: 20),
                  _SupportRequestsSection(),
                  const SizedBox(height: 20),
                  _HowSharingWorksCard(),
                  const SizedBox(height: 20),
                  _ResourcesSection(subRole: subRole),
                  const SizedBox(height: 20),
                  _ProfileSection(session: session, subRole: subRole),
                  const SizedBox(height: 20),
                  _ProductionAccessCard(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

String _subRoleLabel(SupporterSubRole? sub) {
  switch (sub) {
    case SupporterSubRole.psychologistCounsellor:
      return 'Psychologist / Counsellor';
    case SupporterSubRole.peerSupporter:
      return 'Peer Supporter';
    case SupporterSubRole.legalAdvocate:
      return 'Legal Advocate';
    default:
      return 'Supporter';
  }
}

IconData _subRoleIcon(SupporterSubRole? sub) {
  switch (sub) {
    case SupporterSubRole.psychologistCounsellor:
      return Icons.psychology_outlined;
    case SupporterSubRole.peerSupporter:
      return Icons.groups_outlined;
    case SupporterSubRole.legalAdvocate:
      return Icons.gavel_rounded;
    default:
      return Icons.volunteer_activism_outlined;
  }
}

// ── Dashboard Header ──────────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  final dynamic session;
  final SupporterSubRole? subRole;
  const _DashboardHeader({required this.session, required this.subRole});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: cs.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(_subRoleIcon(subRole), size: 26, color: cs.secondary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.name.isNotEmpty ? 'Welcome, ${session.name}' : 'Welcome',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Support people with care, boundaries and consent.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurface.withAlpha(155)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_subRoleIcon(subRole), size: 16, color: cs.primary),
              const SizedBox(width: 6),
              Text(
                _subRoleLabel(subRole),
                style: theme.textTheme.labelLarge?.copyWith(color: cs.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Privacy Banner ────────────────────────────────────────────────────────────

class _PrivacyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(90),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.primary.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.lock_outline_rounded, size: 18, color: cs.primary),
            const SizedBox(width: 8),
            Text('Privacy First',
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: cs.primary)),
          ]),
          const SizedBox(height: 6),
          Text(
            'Survivor information is shared only with explicit consent.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(170), height: 1.4),
          ),
          const SizedBox(height: 4),
          Text(
            'Private journals, voice recordings and sensitive personal information are not automatically accessible.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(150), height: 1.4),
          ),
        ],
      ),
    );
  }
}

// ── Role Content Dispatcher ───────────────────────────────────────────────────

class _RoleContent extends StatelessWidget {
  final SupporterSubRole? subRole;
  const _RoleContent({required this.subRole});

  @override
  Widget build(BuildContext context) {
    switch (subRole) {
      case SupporterSubRole.psychologistCounsellor:
        return const _PsychologistView();
      case SupporterSubRole.peerSupporter:
        return const _PeerSupporterView();
      case SupporterSubRole.legalAdvocate:
        return const _LegalAdvocateView();
      default:
        return const _PsychologistView();
    }
  }
}

// ── Psychologist / Counsellor View ────────────────────────────────────────────

class _PsychologistView extends StatelessWidget {
  const _PsychologistView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InfoCard(
          icon: Icons.favorite_border_rounded,
          title: 'Emotional Support',
          body: 'Provide supportive listening and help survivors explore emotional wellbeing.',
          cs: cs,
          theme: theme,
        ),
        const SizedBox(height: 12),
        _InfoCard(
          icon: Icons.checklist_outlined,
          title: 'Check-in Support',
          body: 'Review information only when a survivor has explicitly chosen to share it.',
          cs: cs,
          theme: theme,
        ),
        const SizedBox(height: 12),
        _BoundaryCard(
          title: 'Professional Boundaries',
          points: const [
            'No diagnosis through this prototype',
            'No automatic access to journals',
            'No automatic data sharing',
            'Survivor controls what is shared',
          ],
          cs: cs,
          theme: theme,
        ),
        const SizedBox(height: 12),
        _SharedInfoCard(cs: cs, theme: theme),
      ],
    );
  }
}

// ── Peer Supporter View ───────────────────────────────────────────────────────

class _PeerSupporterView extends StatelessWidget {
  const _PeerSupporterView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InfoCard(
          icon: Icons.groups_outlined,
          title: 'Peer Connection',
          body: 'Offer lived-experience-informed encouragement and supportive conversation.',
          cs: cs,
          theme: theme,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFFB74D).withAlpha(100)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.info_outline_rounded,
                    size: 18, color: Color(0xFFE65100)),
                const SizedBox(width: 8),
                Text('Peer support is not professional treatment.',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: const Color(0xFFE65100))),
              ]),
              const SizedBox(height: 6),
              Text(
                'Use escalation pathways when a situation requires professional, legal or emergency support.',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFBF360C), height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _BoundaryCard(
          title: 'Support Boundaries',
          points: const [
            'Peer supporters are not therapists',
            'Peer supporters do not provide medical diagnosis',
            'Peer supporters do not provide legal advice',
            'Survivors decide what to share',
            'Survivors can stop participation at any time',
          ],
          cs: cs,
          theme: theme,
        ),
        const SizedBox(height: 12),
        _SharedInfoCard(cs: cs, theme: theme),
      ],
    );
  }
}

// ── Legal Advocate View ───────────────────────────────────────────────────────

class _LegalAdvocateView extends StatelessWidget {
  const _LegalAdvocateView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InfoCard(
          icon: Icons.gavel_rounded,
          title: 'Legal Information',
          body: 'Help survivors understand available legal and support pathways.',
          cs: cs,
          theme: theme,
        ),
        const SizedBox(height: 12),
        _BoundaryCard(
          title: 'Important Boundaries',
          points: const [
            'Provide informational guidance only',
            'Do not make decisions for survivors',
            'Do not automatically report abuse',
            'Do not contact authorities without explicit user action',
            'Survivors decide whether to continue',
          ],
          cs: cs,
          theme: theme,
        ),
        const SizedBox(height: 12),
        _SharedInfoCard(cs: cs, theme: theme),
      ],
    );
  }
}

// ── Support Requests ──────────────────────────────────────────────────────────

class _SupportRequestsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return _SupporterCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.inbox_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Support Requests', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 8),
          Text(
            'No active support requests.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(150)),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cs.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Planned for production',
                style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12, color: cs.onSurface.withAlpha(160))),
          ),
          const SizedBox(height: 10),
          Text(
            'Future features: survivor submits request → supporter accepts → consent-controlled sharing → secure communication → appointment scheduling.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(130),
                fontStyle: FontStyle.italic,
                height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            'Emergency actions are controlled by the survivor. No automatic emergency notifications are sent to supporters.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(140), height: 1.4),
          ),
        ],
      ),
    );
  }
}

// ── How Sharing Works ─────────────────────────────────────────────────────────

class _HowSharingWorksCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const steps = [
      'Survivor chooses support',
      'Survivor chooses what to share',
      'Survivor confirms',
      'Supporter receives only selected information',
    ];
    return _SupporterCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.share_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('How sharing works', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('${e.key + 1}',
                            style: TextStyle(
                                fontSize: 11,
                                color: cs.primary,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(e.value,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(height: 1.4))),
                  ],
                ),
              )),
          const SizedBox(height: 8),
          Text(
            'Demo only — no real information is transmitted.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(130),
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

// ── Resources ─────────────────────────────────────────────────────────────────

class _ResourcesSection extends StatelessWidget {
  final SupporterSubRole? subRole;
  const _ResourcesSection({required this.subRole});

  List<String> _resources() {
    switch (subRole) {
      case SupporterSubRole.psychologistCounsellor:
        return [
          'Supportive listening techniques',
          'Emotional wellbeing frameworks',
          'Professional boundary guidelines',
        ];
      case SupporterSubRole.peerSupporter:
        return [
          'Peer support principles',
          'Active listening skills',
          'Maintaining healthy boundaries',
          'Escalation awareness pathways',
        ];
      case SupporterSubRole.legalAdvocate:
        return [
          'Legal information resources',
          'Survivor autonomy principles',
          'Documentation best practices',
          'Support pathway overview',
        ];
      default:
        return ['General support guidelines'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return _SupporterCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.menu_book_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Resources', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 4),
          Text(
            'Educational and demo resources for your role.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(150)),
          ),
          const SizedBox(height: 12),
          ..._resources().map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  Icon(Icons.arrow_right_rounded,
                      size: 20, color: cs.primary.withAlpha(180)),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(r, style: theme.textTheme.bodyMedium)),
                ]),
              )),
          const SizedBox(height: 6),
          Text(
            'These are demo resources only and do not constitute official professional guidance.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(120),
                fontStyle: FontStyle.italic,
                fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ── Profile Section ───────────────────────────────────────────────────────────

class _ProfileSection extends StatelessWidget {
  final dynamic session;
  final SupporterSubRole? subRole;
  const _ProfileSection({required this.session, required this.subRole});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return _SupporterCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.badge_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Your Profile', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 12),
          _ProfileRow(label: 'Name',
              value: session.name.isNotEmpty ? session.name : 'Demo Supporter',
              cs: cs, theme: theme),
          const SizedBox(height: 6),
          _ProfileRow(label: 'Role',
              value: _subRoleLabel(subRole), cs: cs, theme: theme),
          const SizedBox(height: 6),
          _ProfileRow(label: 'Status',
              value: 'Demo Supporter', cs: cs, theme: theme),
          const SizedBox(height: 10),
          Text(
            'Production verification would be required before providing professional or peer support.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(130),
                fontStyle: FontStyle.italic,
                height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme cs;
  final ThemeData theme;
  const _ProfileRow(
      {required this.label,
      required this.value,
      required this.cs,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
        width: 70,
        child: Text(label,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(140))),
      ),
      Expanded(
          child: Text(value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500))),
    ]);
  }
}

// ── Production Access Card ────────────────────────────────────────────────────

class _ProductionAccessCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const items = [
      'Role-based access control',
      'Least-privilege access',
      'Consent-based sharing',
      'Authentication & verification',
      'Audit logging',
      'Secure data storage',
      'Secure communication',
    ];
    return _SupporterCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.security_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Production Access Control',
                style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cs.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Planned for production',
                style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12, color: cs.onSurface.withAlpha(160))),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  Icon(Icons.radio_button_unchecked,
                      size: 14, color: cs.primary.withAlpha(140)),
                  const SizedBox(width: 8),
                  Text(item, style: theme.textTheme.bodyMedium),
                ]),
              )),
        ],
      ),
    );
  }
}

// ── Shared Info Card ──────────────────────────────────────────────────────────

class _SharedInfoCard extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _SharedInfoCard({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return _SupporterCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.folder_shared_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Shared Information', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 8),
          Text(
            'No survivor information has been shared with you.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(150)),
          ),
          const SizedBox(height: 8),
          Text(
            'Private survivor data is not available in this prototype. Information appears here only after a survivor explicitly chooses to share it.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(120),
                fontStyle: FontStyle.italic,
                height: 1.4),
          ),
        ],
      ),
    );
  }
}

// ── Info Card ─────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final ColorScheme cs;
  final ThemeData theme;
  const _InfoCard(
      {required this.icon,
      required this.title,
      required this.body,
      required this.cs,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return _SupporterCard(
      cs: cs,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: cs.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withAlpha(160), height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Boundary Card ─────────────────────────────────────────────────────────────

class _BoundaryCard extends StatelessWidget {
  final String title;
  final List<String> points;
  final ColorScheme cs;
  final ThemeData theme;
  const _BoundaryCard(
      {required this.title,
      required this.points,
      required this.cs,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return _SupporterCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.shield_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text(title, style: theme.textTheme.titleMedium),
          ]),
          const SizedBox(height: 10),
          ...points.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_rounded,
                        size: 16, color: cs.primary),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(p,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(height: 1.4))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── Shared Card Container ─────────────────────────────────────────────────────

class _SupporterCard extends StatelessWidget {
  final Widget child;
  final ColorScheme cs;
  const _SupporterCard({required this.child, required this.cs});

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
              color: cs.primary.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}
