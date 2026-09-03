import 'package:flutter/material.dart';
import '../../app/app.dart';
import '../../app/routes/app_routes.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final session = SessionScope.of(context);
    final analytics = PlatformAnalyticsScope.of(context).analytics;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AdminHeader(session: session, theme: theme, cs: cs),
                  const SizedBox(height: 16),
                  _PrivacyBanner(theme: theme, cs: cs),
                  const SizedBox(height: 20),
                  _AnonymousByDesignCard(theme: theme, cs: cs),
                  const SizedBox(height: 20),
                  _PlatformOverview(analytics: analytics, theme: theme, cs: cs),
                  const SizedBox(height: 20),
                  _CheckInAnalytics(analytics: analytics, theme: theme, cs: cs),
                  const SizedBox(height: 20),
                  _ActivityAnalytics(analytics: analytics, theme: theme, cs: cs),
                  const SizedBox(height: 20),
                  _SupportAnalytics(analytics: analytics, theme: theme, cs: cs),
                  const SizedBox(height: 20),
                  _PeerSupportAnalytics(analytics: analytics, theme: theme, cs: cs),
                  const SizedBox(height: 20),
                  _SystemStatus(theme: theme, cs: cs),
                  const SizedBox(height: 20),
                  _WhatAdminCannotSee(theme: theme, cs: cs),
                  const SizedBox(height: 20),
                  _PlannedAnalyticsCard(theme: theme, cs: cs),
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

// ── Header ────────────────────────────────────────────────────────────────────

class _AdminHeader extends StatelessWidget {
  final dynamic session;
  final ThemeData theme;
  final ColorScheme cs;
  const _AdminHeader(
      {required this.session, required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.admin_panel_settings_outlined,
              size: 26, color: cs.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session.name.isNotEmpty
                    ? 'Welcome, ${session.name}'
                    : 'Admin Dashboard',
                style: theme.textTheme.headlineMedium,
              ),
              Text(
                'Platform insights without exposing survivor identities.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: cs.onSurface.withAlpha(155)),
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
  final ThemeData theme;
  final ColorScheme cs;
  const _PrivacyBanner({required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(90),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded, size: 18, color: cs.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Privacy First — Only anonymous aggregate information is available to administrators.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.primary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Anonymous by Design ───────────────────────────────────────────────────────

class _AnonymousByDesignCard extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme cs;
  const _AnonymousByDesignCard({required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    return _AdminCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.shield_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Anonymous by Design', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 8),
          Text(
            'Administrators can monitor platform-level patterns, but private survivor information remains inaccessible.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(160), height: 1.5),
          ),
          const SizedBox(height: 12),
          Text('Admin CANNOT access:',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...[
            'Private journals',
            'Voice recordings',
            'Individual reflections',
            'Individual AI insights',
            'Sensitive onboarding responses',
            'Individual survivor profiles',
            'Individual support conversations',
            'Consent history',
          ].map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(children: [
                  const Icon(Icons.block_rounded,
                      size: 14, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(item, style: theme.textTheme.bodyMedium),
                ]),
              )),
        ],
      ),
    );
  }
}

// ── Platform Overview ─────────────────────────────────────────────────────────

class _PlatformOverview extends StatelessWidget {
  final dynamic analytics;
  final ThemeData theme;
  final ColorScheme cs;
  const _PlatformOverview(
      {required this.analytics, required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    return _AdminCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.bar_chart_rounded, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Platform Overview', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MetricChip(
                label: 'Active Sessions',
                value: 'Local prototype session',
                isDemo: true,
                cs: cs,
                theme: theme,
              ),
              _MetricChip(
                label: 'Emotional Check-ins',
                value: '${analytics.totalCheckIns}',
                isDemo: false,
                cs: cs,
                theme: theme,
              ),
              _MetricChip(
                label: 'Completed Activities',
                value: '${analytics.completedActivities}',
                isDemo: false,
                cs: cs,
                theme: theme,
              ),
              _MetricChip(
                label: 'Support Requests',
                value: 'Backend required',
                isDemo: true,
                cs: cs,
                theme: theme,
              ),
              _MetricChip(
                label: 'Peer Applications',
                value: '${analytics.peerSupportApplications}',
                isDemo: false,
                cs: cs,
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Check-in Analytics ────────────────────────────────────────────────────────

class _CheckInAnalytics extends StatelessWidget {
  final dynamic analytics;
  final ThemeData theme;
  final ColorScheme cs;
  const _CheckInAnalytics(
      {required this.analytics, required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    final total = analytics.totalCheckIns as int;
    return _AdminCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.mood_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Emotional Check-in Activity',
                style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 12),
          _StatRow(
            label: 'Total check-ins (this session)',
            value: '$total',
            theme: theme,
            cs: cs,
          ),
          const SizedBox(height: 8),
          _StatRow(
            label: 'Cross-session aggregation',
            value: 'Production analytics required',
            theme: theme,
            cs: cs,
            isUnavailable: true,
          ),
          const SizedBox(height: 8),
          _StatRow(
            label: 'Mood distribution',
            value: 'Production analytics required',
            theme: theme,
            cs: cs,
            isUnavailable: true,
          ),
          const SizedBox(height: 10),
          Text(
            'Individual survivor mood, confidence or connection data is never shown here.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(130),
                fontStyle: FontStyle.italic,
                fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ── Activity Analytics ────────────────────────────────────────────────────────

class _ActivityAnalytics extends StatelessWidget {
  final dynamic analytics;
  final ThemeData theme;
  final ColorScheme cs;
  const _ActivityAnalytics(
      {required this.analytics, required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    final total = analytics.completedActivities as int;
    final maxVal = total == 0 ? 1 : total;

    final categories = ['Relax', 'Express', 'Move', 'Reconnect', 'Grow'];

    return _AdminCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.self_improvement_rounded, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Recovery Activity', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 12),
          _StatRow(
            label: 'Activities completed (this session)',
            value: '$total',
            theme: theme,
            cs: cs,
          ),
          const SizedBox(height: 14),
          Text('Category distribution',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          ...categories.map((cat) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(cat,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontSize: 13)),
                        Text(
                          total == 0
                              ? 'No data'
                              : 'Demo metric',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 11,
                              color: cs.onSurface.withAlpha(120)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: total == 0 ? 0 : (maxVal * 0.2) / maxVal,
                        minHeight: 7,
                        backgroundColor: cs.primaryContainer,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(cs.primary.withAlpha(160)),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 4),
          Text(
            'Per-category breakdown requires production analytics. Individual activity history is not shown.',
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

// ── Support Analytics ─────────────────────────────────────────────────────────

class _SupportAnalytics extends StatelessWidget {
  final dynamic analytics;
  final ThemeData theme;
  final ColorScheme cs;
  const _SupportAnalytics(
      {required this.analytics, required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    return _AdminCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.support_agent_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Support Engagement', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 12),
          _StatRow(
            label: 'Support requests',
            value: 'Production metric — backend required',
            theme: theme,
            cs: cs,
            isUnavailable: true,
          ),
          const SizedBox(height: 8),
          _StatRow(
            label: 'Peer support applications',
            value: '${analytics.peerSupportApplications}',
            theme: theme,
            cs: cs,
          ),
          const SizedBox(height: 8),
          _StatRow(
            label: 'Professional support interest',
            value: 'Production metric — backend required',
            theme: theme,
            cs: cs,
            isUnavailable: true,
          ),
          const SizedBox(height: 8),
          _StatRow(
            label: 'Legal resource exploration',
            value: 'Production metric — backend required',
            theme: theme,
            cs: cs,
            isUnavailable: true,
          ),
        ],
      ),
    );
  }
}

// ── Peer Support Analytics ────────────────────────────────────────────────────

class _PeerSupportAnalytics extends StatelessWidget {
  final dynamic analytics;
  final ThemeData theme;
  final ColorScheme cs;
  const _PeerSupportAnalytics(
      {required this.analytics, required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    final apps = analytics.peerSupportApplications as int;
    return _AdminCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.groups_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Peer Support', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 12),
          _StatRow(
            label: 'Applications submitted (this session)',
            value: '$apps',
            theme: theme,
            cs: cs,
          ),
          const SizedBox(height: 8),
          _StatRow(
            label: 'Awaiting production verification',
            value: 'Production verification workflow required',
            theme: theme,
            cs: cs,
            isUnavailable: true,
          ),
          const SizedBox(height: 10),
          Text(
            'Applicant identity, application answers and personal messages are never shown here.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(130),
                fontStyle: FontStyle.italic,
                fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ── System Status ─────────────────────────────────────────────────────────────

class _SystemStatus extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme cs;
  const _SystemStatus({required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    final statuses = [
      ('Authentication', 'Local prototype'),
      ('Data storage', 'In-memory prototype'),
      ('AI', 'Mock / prototype'),
      ('Voice', 'Not enabled'),
      ('Backend', 'Not connected'),
      ('Database', 'Not connected'),
    ];

    return _AdminCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.monitor_heart_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('System Status', style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 12),
          ...statuses.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: cs.primary.withAlpha(160),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 130,
                    child: Text(s.$1,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                  ),
                  Expanded(
                    child: Text(s.$2,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface.withAlpha(150))),
                  ),
                ]),
              )),
        ],
      ),
    );
  }
}

// ── What Admin Cannot See ─────────────────────────────────────────────────────

class _WhatAdminCannotSee extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme cs;
  const _WhatAdminCannotSee({required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    final items = [
      'Private journal',
      'Voice recordings',
      'Individual emotional history',
      'Individual AI insights',
      'Sensitive survivor profile',
      'Individual support conversations',
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(60),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.visibility_off_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('What Admin Cannot See',
                style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  const Icon(Icons.close_rounded,
                      size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(item, style: theme.textTheme.bodyMedium),
                ]),
              )),
          const SizedBox(height: 10),
          Text(
            'Admin sees platform patterns, not survivor stories.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ── Planned Analytics ─────────────────────────────────────────────────────────

class _PlannedAnalyticsCard extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme cs;
  const _PlannedAnalyticsCard({required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    const items = [
      'Anonymous event collection',
      'Privacy-preserving aggregation',
      'Role-based access control',
      'Data minimisation',
      'Audit logging',
      'Consent-aware analytics',
      'Secure backend storage',
      'Retention policies',
    ];

    return _AdminCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.analytics_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text('Planned Production Analytics',
                style: theme.textTheme.titleLarge),
          ]),
          const SizedBox(height: 6),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _AdminCard extends StatelessWidget {
  final Widget child;
  final ColorScheme cs;
  const _AdminCard({required this.child, required this.cs});

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

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isDemo;
  final ColorScheme cs;
  final ThemeData theme;
  const _MetricChip(
      {required this.label,
      required this.value,
      required this.isDemo,
      required this.cs,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDemo
            ? cs.secondaryContainer.withAlpha(120)
            : cs.primaryContainer.withAlpha(120),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDemo
                ? cs.onSurface.withAlpha(30)
                : cs.primary.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12, color: cs.onSurface.withAlpha(150))),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 18,
              color: isDemo ? cs.onSurface.withAlpha(120) : cs.primary,
            ),
          ),
          if (isDemo)
            Text('Demo metric',
                style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 10,
                    color: cs.onSurface.withAlpha(100),
                    fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final ColorScheme cs;
  final bool isUnavailable;
  const _StatRow(
      {required this.label,
      required this.value,
      required this.theme,
      required this.cs,
      this.isUnavailable = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(label,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurface.withAlpha(160))),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isUnavailable ? FontWeight.normal : FontWeight.w600,
              color: isUnavailable
                  ? cs.onSurface.withAlpha(110)
                  : cs.primary,
              fontStyle:
                  isUnavailable ? FontStyle.italic : FontStyle.normal,
              fontSize: isUnavailable ? 12 : null,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
