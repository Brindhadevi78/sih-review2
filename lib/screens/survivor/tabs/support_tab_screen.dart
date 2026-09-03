import 'package:flutter/material.dart';
import '../../../app/app.dart';
import '../../../models/survivor_situation.dart';
import '../professional_support_screen.dart';
import '../peer_support_screen.dart';
import '../legal_support_screen.dart';

class SupportTabScreen extends StatelessWidget {
  const SupportTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final profile = SurvivorProfileScope.of(context).profile;
    final history = SupportHistoryScope.of(context).choices;

    final showSafetyCard = profile?.primarySituation == PrimarySituation.multipleOngoing ||
        (profile?.selectedSubcategories.contains('Ongoing unsafe situation') ?? false);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──────────────────────────────────────────────────────
              Text('Support, When You Choose',
                  style: theme.textTheme.displaySmall),
              const SizedBox(height: 6),
              Text(
                'You decide when and how you want to reach out.',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: cs.onSurface.withAlpha(160), height: 1.5),
              ),
              const SizedBox(height: 12),

              // Privacy indicator
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withAlpha(70),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.primary.withAlpha(30)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline_rounded,
                        size: 16, color: cs.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Nothing is shared without your permission.',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: cs.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Ongoing unsafe situation card ────────────────────────────────
              if (showSafetyCard) ...[
                _SafetyCard(cs: cs, theme: theme),
                const SizedBox(height: 20),
              ],

              // ── Three support paths ──────────────────────────────────────────
              _SupportPathCard(
                icon: Icons.psychology_outlined,
                title: 'Professional Support',
                description:
                    'Explore counsellors, psychologists and trained support professionals.',
                color: cs.primary,
                onTap: () {
                  SupportHistoryScope.of(context)
                      .record('Explored professional support');
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ProfessionalSupportScreen(),
                  ));
                },
                cs: cs,
                theme: theme,
              ),
              const SizedBox(height: 12),

              _SupportPathCard(
                icon: Icons.groups_outlined,
                title: 'Peer Support',
                description:
                    'Connect with people who have chosen to support others through similar experiences.',
                color: const Color(0xFF64B5F6),
                onTap: () {
                  SupportHistoryScope.of(context)
                      .record('Viewed peer support information');
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const PeerSupportScreen(),
                  ));
                },
                cs: cs,
                theme: theme,
              ),
              const SizedBox(height: 12),

              _SupportPathCard(
                icon: Icons.gavel_rounded,
                title: 'Legal & Women\'s Support',
                description:
                    'Explore legal information, women\'s support services and safety resources.',
                color: const Color(0xFFFFB74D),
                onTap: () {
                  SupportHistoryScope.of(context)
                      .record('Explored legal resources');
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const LegalSupportScreen(),
                  ));
                },
                cs: cs,
                theme: theme,
              ),
              const SizedBox(height: 24),

              // ── Emergency support ────────────────────────────────────────────
              _EmergencyBanner(cs: cs, theme: theme),
              const SizedBox(height: 24),

              // ── Support history ──────────────────────────────────────────────
              if (history.isNotEmpty) ...[
                Text('Your Support Choices', style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  'A local record of what you\'ve explored.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: cs.onSurface.withAlpha(150)),
                ),
                const SizedBox(height: 12),
                _SupportHistoryList(history: history, cs: cs, theme: theme),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Ongoing unsafe situation card ─────────────────────────────────────────────

class _SafetyCard extends StatefulWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _SafetyCard({required this.cs, required this.theme});

  @override
  State<_SafetyCard> createState() => _SafetyCardState();
}

class _SafetyCardState extends State<_SafetyCard> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();
    final cs = widget.cs;
    final theme = widget.theme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFB74D).withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined,
                  size: 20, color: Color(0xFFE65100)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your safety matters.',
                  style: theme.textTheme.titleLarge?.copyWith(
                      color: const Color(0xFFE65100), fontSize: 16),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded,
                    size: 18, color: cs.onSurface.withAlpha(120)),
                onPressed: () => setState(() => _dismissed = true),
                tooltip: 'Dismiss',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Explore support options whenever you feel ready.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: const Color(0xFFBF360C), height: 1.5),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  SupportHistoryScope.of(context)
                      .record('Viewed safety support options');
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const LegalSupportScreen(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE65100),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 38),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text('View Support'),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () => setState(() => _dismissed = true),
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 38),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('Not now',
                    style: TextStyle(color: cs.onSurface.withAlpha(150))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Support path card ─────────────────────────────────────────────────────────

class _SupportPathCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;
  final ColorScheme cs;
  final ThemeData theme;

  const _SupportPathCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withAlpha(50)),
            boxShadow: [
              BoxShadow(
                  color: color.withAlpha(15),
                  blurRadius: 10,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 26, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withAlpha(160), height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: color.withAlpha(180)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Emergency banner ──────────────────────────────────────────────────────────

class _EmergencyBanner extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _EmergencyBanner({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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
              Icon(Icons.emergency_outlined, size: 20, color: cs.primary),
              const SizedBox(width: 8),
              Text('Need immediate help?',
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Emergency and safety resources are available if you choose to explore them.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(160), height: 1.5),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => _showEmergencyDialog(context),
            icon: const Icon(Icons.shield_outlined, size: 18),
            label: const Text('View Emergency Support'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 42),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _EmergencyDialog(
        cs: cs,
        theme: theme,
        onContinue: () {
          Navigator.pop(ctx);
          SupportHistoryScope.of(context)
              .record('Viewed emergency support options');
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const LegalSupportScreen(openEmergency: true),
          ));
        },
        onCancel: () => Navigator.pop(ctx),
      ),
    );
  }
}

class _EmergencyDialog extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  final VoidCallback onContinue;
  final VoidCallback onCancel;

  const _EmergencyDialog({
    required this.cs,
    required this.theme,
    required this.onContinue,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.shield_outlined, color: cs.primary, size: 22),
          const SizedBox(width: 8),
          const Text('Emergency Support'),
        ],
      ),
      content: Text(
        'This will show emergency and safety resources.\n\n'
        'Nothing will be sent or shared automatically.\n'
        'You remain in control.',
        style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text('Cancel',
              style: TextStyle(color: cs.onSurface.withAlpha(150))),
        ),
        ElevatedButton(
          onPressed: onContinue,
          child: const Text('Continue'),
        ),
      ],
    );
  }
}

// ── Support history list ──────────────────────────────────────────────────────

class _SupportHistoryList extends StatelessWidget {
  final List<dynamic> history;
  final ColorScheme cs;
  final ThemeData theme;

  const _SupportHistoryList(
      {required this.history, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: history.take(8).map((c) {
          final label = c.label as String;
          final chosenAt = c.chosenAt as DateTime;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: cs.primary.withAlpha(160),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(label,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500)),
                ),
                Text(
                  _formatDate(chosenAt),
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11, color: cs.onSurface.withAlpha(120)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}
