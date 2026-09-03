import 'package:flutter/material.dart';
import '../../app/app.dart';
import '../../app/routes/app_routes.dart';
import '../../models/recovery_state.dart';
import '../../providers/recovery_state_provider.dart';
import '../../providers/companion_provider.dart';
import '../../utils/personalization_helper.dart';
import 'companion_screen.dart';

class SurvivorScreen extends StatefulWidget {
  final void Function(int)? onSwitchTab;
  const SurvivorScreen({super.key, this.onSwitchTab});

  @override
  State<SurvivorScreen> createState() => _SurvivorScreenState();
}

class _SurvivorScreenState extends State<SurvivorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOnboarding());
  }

  void _checkOnboarding() {
    if (!mounted) return;
    final session = SessionScope.of(context);
    final profileProvider = SurvivorProfileScope.of(context);
    if (profileProvider.profile == null) {
      profileProvider.initProfile(
        userId: session.email,
        name: session.name,
        email: session.email,
      );
    }
    if (!profileProvider.onboardingCompleted) {
      Navigator.pushReplacementNamed(context, AppRoutes.survivorOnboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = SurvivorProfileScope.of(context);
    final profile = profileProvider.profile;

    if (profile == null || !profile.onboardingCompleted) {
      return const SizedBox.shrink();
    }

    final recoveryProvider = RecoveryStateScope.of(context);
    final recovery = recoveryProvider.state;
    final activityHistory = ActivityHistoryScope.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final greeting = PersonalizationHelper.greeting(profile);
    final step = PersonalizationHelper.oneSmallStep(profile);
    final recs = PersonalizationHelper.detailedRecommendations(profile);
    final support = PersonalizationHelper.supportOptions(profile);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Greeting
              _GreetingSection(
                greeting: greeting,
                onboardingSkipped: profile.primarySituation == null &&
                    profile.currentConcerns.isEmpty,
                cs: cs,
                theme: theme,
              ),
              const SizedBox(height: 16),

              // 2. Privacy indicator
              _PrivacyCard(cs: cs, theme: theme),
              const SizedBox(height: 16),

              // 3. Emotional check-in
              _CheckInCard(
                recovery: recovery,
                recoveryProvider: recoveryProvider,
                onGoReflect: () => profileProvider.onboardingCompleted
                    ? (widget.onSwitchTab?.call(1))
                    : null,
                cs: cs,
                theme: theme,
              ),
              const SizedBox(height: 16),

              // 4. One small step
              _SmallStepCard(
                step: step,
                onStart: () => widget.onSwitchTab?.call(2),
                cs: cs,
                theme: theme,
              ),
              const SizedBox(height: 16),

              // 5. Recommendations
              _RecommendationsSection(recs: recs, cs: cs, theme: theme),
              const SizedBox(height: 16),

              // 6. Virtual companion
              _CompanionCard(
                  mood: recovery.mood, cs: cs, theme: theme),
              const SizedBox(height: 16),

              // 7. Recovery progress
              _ProgressCard(
                recovery: recovery,
                completedCount: activityHistory.totalCompleted,
                onViewJourney: () => widget.onSwitchTab?.call(3),
                cs: cs,
                theme: theme,
              ),
              const SizedBox(height: 16),

              // 8. Support options
              _SupportCard(
                options: support,
                onExploreSupport: () => widget.onSwitchTab?.call(4),
                cs: cs,
                theme: theme,
              ),
              const SizedBox(height: 16),

              // 9. AI status + personalization badge
              _AiStatusCard(
                  aiConsent: profile.aiAnalysisConsent, cs: cs, theme: theme),
              const SizedBox(height: 16),

              // 10. Latest reflection insight (non-intrusive, insight only)
              _LatestInsightCard(cs: cs, theme: theme),
              const SizedBox(height: 8),
              _PersonalizationBadge(cs: cs, theme: theme),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 1. Greeting ───────────────────────────────────────────────────────────────

class _GreetingSection extends StatelessWidget {
  final String greeting;
  final bool onboardingSkipped;
  final ColorScheme cs;
  final ThemeData theme;

  const _GreetingSection({
    required this.greeting,
    required this.onboardingSkipped,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(greeting, style: theme.textTheme.displaySmall),
        const SizedBox(height: 4),
        Text(
          onboardingSkipped
              ? 'Welcome to your recovery space.'
              : 'Your recovery. Your choices. Your pace.',
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: cs.onSurface.withAlpha(160)),
        ),
      ],
    );
  }
}

// ── 2. Privacy card ───────────────────────────────────────────────────────────

class _PrivacyCard extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;

  const _PrivacyCard({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.primary.withAlpha(30)),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded, size: 18, color: cs.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your space is private',
                    style: theme.textTheme.labelLarge
                        ?.copyWith(color: cs.primary)),
                Text('Choose what you share and when you share it.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurface.withAlpha(150))),
              ],
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.privacyCenter),
            style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8)),
            child: Text('Privacy',
                style: TextStyle(color: cs.primary, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ── 3. Check-in card ──────────────────────────────────────────────────────────

class _CheckInCard extends StatelessWidget {
  final RecoveryState recovery;
  final RecoveryStateProvider recoveryProvider;
  final VoidCallback? onGoReflect;
  final ColorScheme cs;
  final ThemeData theme;

  const _CheckInCard({
    required this.recovery,
    required this.recoveryProvider,
    this.onGoReflect,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return _DashCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How are you feeling today?',
              style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('A small check-in can help you notice how you\'re doing.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurface.withAlpha(150))),
          const SizedBox(height: 16),

          // Mood selector
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: CheckInMood.values.map((m) {
              final selected = recovery.mood == m;
              return GestureDetector(
                onTap: () => recoveryProvider.setMood(m),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? cs.primaryContainer : cs.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: selected
                          ? cs.primary
                          : cs.primary.withAlpha(40),
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    '${m.emoji} ${m.label}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: selected ? cs.primary : cs.onSurface,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Confidence
          _ScaleRow(
            label: 'Confidence',
            value: recovery.confidence,
            cs: cs,
            theme: theme,
            onChanged: recoveryProvider.setConfidence,
          ),
          const SizedBox(height: 12),

          // Social connection
          _ScaleRow(
            label: 'Social connection',
            value: recovery.socialConnection,
            cs: cs,
            theme: theme,
            onChanged: recoveryProvider.setSocialConnection,
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onGoReflect,
              child: const Text('Continue Check-in'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScaleRow extends StatelessWidget {
  final String label;
  final int value;
  final ColorScheme cs;
  final ThemeData theme;
  final void Function(int) onChanged;

  const _ScaleRow({
    required this.label,
    required this.value,
    required this.cs,
    required this.theme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Row(
          children: List.generate(5, (i) {
            final level = i + 1;
            final active = level <= value;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(level),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 32,
                  decoration: BoxDecoration(
                    color: active ? cs.primary : cs.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$level',
                      style: TextStyle(
                        color: active ? cs.onPrimary : cs.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── 4. One small step ─────────────────────────────────────────────────────────

class _SmallStepCard extends StatelessWidget {
  final SmallStep step;
  final VoidCallback? onStart;
  final ColorScheme cs;
  final ThemeData theme;

  const _SmallStepCard(
      {required this.step, this.onStart, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withAlpha(60),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_outline_rounded,
                  color: cs.onPrimary.withAlpha(200), size: 18),
              const SizedBox(width: 6),
              Text('One Small Step',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: cs.onPrimary.withAlpha(200))),
            ],
          ),
          const SizedBox(height: 10),
          Text(step.title,
              style: theme.textTheme.headlineMedium
                  ?.copyWith(color: cs.onPrimary)),
          const SizedBox(height: 6),
          Text(step.description,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: cs.onPrimary.withAlpha(210), height: 1.5)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.onPrimary,
              foregroundColor: cs.primary,
              minimumSize: const Size(100, 44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

// ── 5. Recommendations ────────────────────────────────────────────────────────

class _RecommendationsSection extends StatelessWidget {
  final List<Recommendation> recs;
  final ColorScheme cs;
  final ThemeData theme;

  const _RecommendationsSection(
      {required this.recs, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recommended for you', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        ...recs.map((r) => _RecCard(rec: r, cs: cs, theme: theme)),
      ],
    );
  }
}

class _RecCard extends StatelessWidget {
  final Recommendation rec;
  final ColorScheme cs;
  final ThemeData theme;

  const _RecCard(
      {required this.rec, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withAlpha(25)),
        boxShadow: [
          BoxShadow(
              color: cs.primary.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(rec.icon, color: cs.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(rec.title,
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontSize: 15)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(rec.category,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 11,
                              color: cs.onSurface.withAlpha(160))),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(rec.description,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurface.withAlpha(150))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: cs.primary.withAlpha(160)),
        ],
      ),
    );
  }
}

// ── 6. Companion ──────────────────────────────────────────────────────────────

class _CompanionCard extends StatelessWidget {
  final CheckInMood? mood;
  final ColorScheme cs;
  final ThemeData theme;

  const _CompanionCard({
    required this.mood,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final companionProvider = CompanionScope.of(context);
    final prefs = companionProvider.preferences;
    final action = companionProvider.action;
    final msg = companionProvider.message(mood);

    return _DashCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CompanionAvatar(
                prefs: prefs,
                action: action,
                size: 72,
                cs: cs,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your companion',
                        style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      msg,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(
                              color: cs.onSurface.withAlpha(160),
                              height: 1.4),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      action.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: cs.primary.withAlpha(180),
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CompanionScreen()),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Customise'),
              ),
              OutlinedButton(
                onPressed: () => _interact(context, companionProvider, mood),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Spend a moment'),
              ),
              OutlinedButton(
                onPressed: () => _showTalkDialog(context, prefs),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Talk'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _interact(BuildContext context, CompanionProvider provider, CheckInMood? mood) {
    // Cycle through a gentle action
    final actions = [
      CompanionAction.waving,
      CompanionAction.breathing,
      CompanionAction.celebrating,
      CompanionAction.thinking,
    ];
    final current = provider.action;
    final next = actions[(actions.indexOf(current) + 1) % actions.length];
    provider.setAction(next);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(next.label),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showTalkDialog(BuildContext context, dynamic prefs) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const prompts = [
      'Take one slow breath.',
      'What feels manageable right now?',
      'Would you like to explore a small recovery activity?',
    ];
    String? selectedPrompt;
    String? response;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Companion conversation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This prototype does not currently include live AI conversation.',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withAlpha(150),
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 14),
              if (response == null) ...[
                Text('Try a calming prompt:',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                ...prompts.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: GestureDetector(
                        onTap: () => setS(() => selectedPrompt = p),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: selectedPrompt == p
                                ? cs.primaryContainer
                                : cs.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: selectedPrompt == p
                                    ? cs.primary
                                    : cs.primary.withAlpha(30)),
                          ),
                          child: Text(p,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: selectedPrompt == p
                                      ? cs.primary
                                      : cs.onSurface)),
                        ),
                      ),
                    )),
              ] else
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withAlpha(80),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(response!,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(height: 1.5)),
                ),
            ],
          ),
          actions: response != null
              ? [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Close'),
                  ),
                ]
              : [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Not now'),
                  ),
                  ElevatedButton(
                    onPressed: selectedPrompt == null
                        ? null
                        : () => setS(() => response =
                            _promptResponse(selectedPrompt!)),
                    child: const Text('Try'),
                  ),
                ],
        ),
      ),
    );
  }

  String _promptResponse(String prompt) {
    if (prompt.contains('breath')) {
      return 'Breathe in slowly for 4 counts... hold for 2... and breathe out for 6. You can do this as many times as feels right.';
    }
    if (prompt.contains('manageable')) {
      return 'Even one small thing counts. Maybe it\'s a glass of water, a short walk, or just sitting quietly for a moment.';
    }
    return 'The Recover tab has gentle activities ready for you whenever you feel like exploring one.';
  }
}

// ── 7. Progress ───────────────────────────────────────────────────────────────

class _ProgressCard extends StatelessWidget {
  final RecoveryState recovery;
  final int completedCount;
  final VoidCallback? onViewJourney;
  final ColorScheme cs;
  final ThemeData theme;

  const _ProgressCard(
      {required this.recovery, required this.completedCount, this.onViewJourney, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return _DashCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your journey',
                        style: theme.textTheme.titleLarge),
                    Text('Recovery isn\'t a straight line.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface.withAlpha(150))),
                  ],
                ),
              ),
              TextButton(
                onPressed: onViewJourney,
                child: const Text('View Journey'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ProgressRow(
              label: 'Recent mood',
              value: recovery.mood != null ? 0.65 : 0.5,
              cs: cs,
              theme: theme),
          const SizedBox(height: 10),
          _ProgressRow(
              label: 'Confidence',
              value: recovery.confidence / 5,
              cs: cs,
              theme: theme),
          const SizedBox(height: 10),
          _ProgressRow(
              label: 'Connection',
              value: recovery.socialConnection / 5,
              cs: cs,
              theme: theme),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatChip(
                label: '$completedCount activities',
                icon: Icons.check_circle_outline_rounded,
                cs: cs,
                theme: theme,
              ),
              const SizedBox(width: 8),
              _StatChip(
                label: '${recovery.milestones} milestones',
                icon: Icons.star_outline_rounded,
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

class _ProgressRow extends StatelessWidget {
  final String label;
  final double value;
  final ColorScheme cs;
  final ThemeData theme;

  const _ProgressRow({
    required this.label,
    required this.value,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500)),
            Text('${(value * 100).round()}%',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: cs.primary, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: cs.primaryContainer,
            valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final ColorScheme cs;
  final ThemeData theme;

  const _StatChip({
    required this.label,
    required this.icon,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(120),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: cs.primary),
          const SizedBox(width: 4),
          Text(label,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.primary, fontSize: 12)),
        ],
      ),
    );
  }
}

// ── 8. Support ────────────────────────────────────────────────────────────────

class _SupportCard extends StatelessWidget {
  final List<SupportOption> options;
  final VoidCallback? onExploreSupport;
  final ColorScheme cs;
  final ThemeData theme;

  const _SupportCard(
      {required this.options, this.onExploreSupport, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return _DashCard(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Support, when you\'re ready',
              style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'You decide when and whether to take the next step.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(150)),
          ),
          const SizedBox(height: 16),
          ...options.map((o) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(o.icon, color: cs.secondary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(o.title,
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w500)),
                          Text(o.description,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurface.withAlpha(150))),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: cs.primary.withAlpha(140)),
                  ],
                ),
              )),
          const SizedBox(height: 4),
          TextButton(
            onPressed: onExploreSupport,
            child: const Text('Explore Support'),
          ),
        ],
      ),
    );
  }
}

// ── 9. AI status ──────────────────────────────────────────────────────────────

class _AiStatusCard extends StatelessWidget {
  final bool aiConsent;
  final ColorScheme cs;
  final ThemeData theme;

  const _AiStatusCard(
      {required this.aiConsent, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.primary.withAlpha(25)),
      ),
      child: Row(
        children: [
          Icon(
            aiConsent
                ? Icons.psychology_outlined
                : Icons.do_not_disturb_alt_outlined,
            color: aiConsent ? cs.primary : cs.onSurface.withAlpha(120),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Reflection Insights',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500)),
                Text(
                  aiConsent ? 'Enabled with your consent' : 'Not enabled',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withAlpha(150)),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.privacyCenter),
            style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8)),
            child: Text('Manage',
                style: TextStyle(color: cs.primary, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ── 10. Latest insight card ──────────────────────────────────────────────────

/// Shows a small non-intrusive card when the latest reflection has an AI
/// insight. Never shows journal text. Never shows a fake insight.
class _LatestInsightCard extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;

  const _LatestInsightCard({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    final latest = ReflectionScope.of(context).allReflections.firstOrNull;
    final insight = latest?.insight;
    if (insight == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(70),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.primary.withAlpha(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology_outlined, size: 16, color: cs.primary),
              const SizedBox(width: 6),
              Text('Your latest reflection',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: cs.primary)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  insight.pattern,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      color: cs.primary,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            insight.supportMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(160), height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Prototype AI insight — not a diagnosis.',
            style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 10,
                color: cs.onSurface.withAlpha(110),
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

// ── 11. Personalization badge ─────────────────────────────────────────────────

class _PersonalizationBadge extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;

  const _PersonalizationBadge({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.tune_rounded, size: 14, color: cs.onSurface.withAlpha(100)),
        const SizedBox(width: 6),
        Text(
          'Your recovery space is tailored to what you chose.',
          style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withAlpha(100), fontSize: 12),
        ),
      ],
    );
  }
}

// ── Shared card container ─────────────────────────────────────────────────────

class _DashCard extends StatelessWidget {
  final Widget child;
  final ColorScheme cs;

  const _DashCard({required this.child, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.primary.withAlpha(20)),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
