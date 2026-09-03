import 'package:flutter/material.dart';
import '../../../app/app.dart';
import '../../../models/recovery_activity.dart';
import '../../../models/survivor_situation.dart';
import '../../../services/recovery_recommendation_engine.dart';
import 'activity_detail_screen.dart';
import 'guided_activity_screen.dart';
import 'activity_completion_screen.dart';

class RecoverScreen extends StatefulWidget {
  const RecoverScreen({super.key});

  @override
  State<RecoverScreen> createState() => _RecoverScreenState();
}

class _RecoverScreenState extends State<RecoverScreen> {
  ActivityCategory? _filterCategory;

  List<RecoveryActivity> get _filteredActivities {
    if (_filterCategory == null) return kActivityLibrary;
    return kActivityLibrary
        .where((a) => a.category == _filterCategory)
        .toList();
  }

  void _openActivity(BuildContext context, RecoveryActivity activity) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _ActivityFlow(activity: activity),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final profileProvider = SurvivorProfileScope.of(context);
    final profile = profileProvider.profile;
    final reflections = ReflectionScope.of(context);
    final recoveryState = RecoveryStateScope.of(context).state;
    final history = ActivityHistoryScope.of(context);

    final latestReflection = reflections.getTodayReflection() ??
        (reflections.allReflections.isNotEmpty
            ? reflections.allReflections.first
            : null);

    final primaryActivity = profile != null
        ? RecoveryRecommendationEngine.primaryRecommendation(
            profile: profile,
            latestReflection: latestReflection,
            recoveryState: recoveryState,
            history: history,
          )
        : kActivityLibrary.firstWhere((a) => a.id == 'take_gentle_breath');

    final topRecs = profile != null
        ? RecoveryRecommendationEngine.recommend(
            profile: profile,
            latestReflection: latestReflection,
            recoveryState: recoveryState,
            history: history,
            limit: 3,
          )
        : kActivityLibrary.take(3).toList();

    final showSafetyCard = profile?.primarySituation ==
            PrimarySituation.multipleOngoing ||
        (profile?.selectedSubcategories
                .contains('Ongoing unsafe situation') ??
            false);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text('Your Recovery Space',
                  style: theme.textTheme.displaySmall),
              const SizedBox(height: 4),
              Text(
                'Small steps that fit how you\'re feeling today.',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: cs.onSurface.withAlpha(160)),
              ),
              const SizedBox(height: 10),
              _ChoiceNote(cs: cs, theme: theme),
              const SizedBox(height: 20),

              // Safety card (conditional)
              if (showSafetyCard) ...[
                _SafetyCard(cs: cs, theme: theme),
                const SizedBox(height: 16),
              ],

              // Section 1: For You Today
              _SectionHeader(
                  label: 'For you today', cs: cs, theme: theme),
              const SizedBox(height: 12),
              _PrimaryActivityCard(
                activity: primaryActivity,
                onStart: () => _openActivity(context, primaryActivity),
                cs: cs,
                theme: theme,
              ),
              const SizedBox(height: 8),
              // Other top recs (excluding primary)
              ...topRecs
                  .where((a) => a.id != primaryActivity.id)
                  .take(2)
                  .map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ActivityCard(
                          activity: a,
                          onTap: () => _openActivity(context, a),
                          cs: cs,
                          theme: theme,
                        ),
                      )),
              const SizedBox(height: 24),

              // Section 2: Categories
              _SectionHeader(
                  label: 'Supportive activities',
                  cs: cs,
                  theme: theme),
              const SizedBox(height: 12),
              ...ActivityCategory.values.map((cat) => _CategorySection(
                    category: cat,
                    activities: kActivityLibrary
                        .where((a) => a.category == cat)
                        .toList(),
                    onActivityTap: (a) => _openActivity(context, a),
                    cs: cs,
                    theme: theme,
                  )),
              const SizedBox(height: 24),

              // Section 3: Activity Library
              _SectionHeader(
                  label: 'Explore all activities',
                  cs: cs,
                  theme: theme),
              const SizedBox(height: 12),
              _FilterRow(
                selected: _filterCategory,
                onSelect: (cat) =>
                    setState(() => _filterCategory = cat),
                cs: cs,
                theme: theme,
              ),
              const SizedBox(height: 12),
              ..._filteredActivities.map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ActivityCard(
                      activity: a,
                      onTap: () => _openActivity(context, a),
                      cs: cs,
                      theme: theme,
                    ),
                  )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Choice note ───────────────────────────────────────────────────────────────

class _ChoiceNote extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _ChoiceNote({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(60),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withAlpha(25)),
      ),
      child: Row(
        children: [
          Icon(Icons.tune_rounded, size: 16, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'You choose what feels right. You can skip anything.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Safety card ───────────────────────────────────────────────────────────────

class _SafetyCard extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  const _SafetyCard({required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFB74D).withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined,
                  size: 18, color: Color(0xFFE65100)),
              const SizedBox(width: 8),
              Text(
                'Need immediate support?',
                style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE65100)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Emergency and support resources are available if you choose to explore them.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: const Color(0xFFBF360C)),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Tap "Support" in the bottom navigation to explore support options.'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFE65100),
              side: const BorderSide(color: Color(0xFFE65100)),
              minimumSize: const Size(0, 36),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('View Support'),
          ),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final ColorScheme cs;
  final ThemeData theme;
  const _SectionHeader(
      {required this.label, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: theme.textTheme.titleLarge);
  }
}

// ── Primary activity card ─────────────────────────────────────────────────────

class _PrimaryActivityCard extends StatelessWidget {
  final RecoveryActivity activity;
  final VoidCallback onStart;
  final ColorScheme cs;
  final ThemeData theme;

  const _PrimaryActivityCard({
    required this.activity,
    required this.onStart,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withAlpha(70),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.onPrimary.withAlpha(30),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(activity.icon, size: 24, color: cs.onPrimary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: cs.onPrimary.withAlpha(30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        activity.category.label.toUpperCase(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: cs.onPrimary.withAlpha(200),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.title,
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(color: cs.onPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            activity.description,
            style: theme.textTheme.bodyLarge?.copyWith(
                color: cs.onPrimary.withAlpha(210), height: 1.5),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.schedule_rounded,
                  size: 14, color: cs.onPrimary.withAlpha(180)),
              const SizedBox(width: 4),
              Text(
                activity.duration,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onPrimary.withAlpha(180), fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!activity.isInformational)
            ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.onPrimary,
                foregroundColor: cs.primary,
                minimumSize: const Size(120, 44),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Start Activity'),
            )
          else
            OutlinedButton(
              onPressed: onStart,
              style: OutlinedButton.styleFrom(
                foregroundColor: cs.onPrimary,
                side: BorderSide(color: cs.onPrimary.withAlpha(180)),
                minimumSize: const Size(120, 44),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('View Activity'),
            ),
        ],
      ),
    );
  }
}

// ── Activity card ─────────────────────────────────────────────────────────────

class _ActivityCard extends StatelessWidget {
  final RecoveryActivity activity;
  final VoidCallback onTap;
  final ColorScheme cs;
  final ThemeData theme;

  const _ActivityCard({
    required this.activity,
    required this.onTap,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = activity.category.color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.primary.withAlpha(20)),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: catColor.withAlpha(25),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(activity.icon, size: 22, color: catColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(activity.title,
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontSize: 15)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: catColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          activity.category.label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            color: catColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    activity.description,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurface.withAlpha(150)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded,
                          size: 12,
                          color: cs.onSurface.withAlpha(120)),
                      const SizedBox(width: 4),
                      Text(
                        activity.duration,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            color: cs.onSurface.withAlpha(120)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: cs.primary.withAlpha(140)),
          ],
        ),
      ),
    );
  }
}

// ── Category section ──────────────────────────────────────────────────────────

class _CategorySection extends StatelessWidget {
  final ActivityCategory category;
  final List<RecoveryActivity> activities;
  final void Function(RecoveryActivity) onActivityTap;
  final ColorScheme cs;
  final ThemeData theme;

  const _CategorySection({
    required this.category,
    required this.activities,
    required this.onActivityTap,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = category.color;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: catColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(category.icon, size: 16, color: catColor),
              ),
              const SizedBox(width: 10),
              Text(
                category.label.toUpperCase(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: catColor,
                  letterSpacing: 1.0,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: activities.length,
              separatorBuilder: (context2, index2) => const SizedBox(width: 10),
              itemBuilder: (_, i) => _MiniActivityCard(
                activity: activities[i],
                onTap: () => onActivityTap(activities[i]),
                cs: cs,
                theme: theme,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniActivityCard extends StatelessWidget {
  final RecoveryActivity activity;
  final VoidCallback onTap;
  final ColorScheme cs;
  final ThemeData theme;

  const _MiniActivityCard({
    required this.activity,
    required this.onTap,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = activity.category.color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: catColor.withAlpha(40)),
          boxShadow: [
            BoxShadow(
              color: catColor.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(activity.icon, size: 24, color: catColor),
            const SizedBox(height: 8),
            Text(
              activity.title,
              style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              activity.duration,
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 11, color: cs.onSurface.withAlpha(130)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Filter row ────────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final ActivityCategory? selected;
  final void Function(ActivityCategory?) onSelect;
  final ColorScheme cs;
  final ThemeData theme;

  const _FilterRow({
    required this.selected,
    required this.onSelect,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            selected: selected == null,
            color: cs.primary,
            onTap: () => onSelect(null),
            theme: theme,
            cs: cs,
          ),
          const SizedBox(width: 8),
          ...ActivityCategory.values.map((cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _FilterChip(
                  label: cat.label,
                  selected: selected == cat,
                  color: cat.color,
                  onTap: () =>
                      onSelect(selected == cat ? null : cat),
                  theme: theme,
                  cs: cs,
                ),
              )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  final ThemeData theme;
  final ColorScheme cs;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color : cs.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : color.withAlpha(60),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: selected ? Colors.white : color,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── Activity flow (detail → guided → completion) ──────────────────────────────

class _ActivityFlow extends StatefulWidget {
  final RecoveryActivity activity;
  const _ActivityFlow({required this.activity});

  @override
  State<_ActivityFlow> createState() => _ActivityFlowState();
}

class _ActivityFlowState extends State<_ActivityFlow> {
  _FlowStage _stage = _FlowStage.detail;

  void _startActivity() => setState(() => _stage = _FlowStage.guided);

  void _onComplete() {
    // Record completion
    final history = ActivityHistoryScope.of(context);
    final recoveryState = RecoveryStateScope.of(context);
    history.completeActivity(widget.activity);
    recoveryState.incrementCompletedActivities();
    PlatformAnalyticsScope.of(context).incrementCompletedActivities();
    setState(() => _stage = _FlowStage.completion);
  }

  void _onExit() => Navigator.of(context).pop();

  void _onDone() => Navigator.of(context).pop();

  void _onTryAnother() {
    // Pop back to RecoverScreen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    switch (_stage) {
      case _FlowStage.detail:
        return ActivityDetailScreen(
          activity: widget.activity,
          onStart: _startActivity,
        );
      case _FlowStage.guided:
        return GuidedActivityScreen(
          activity: widget.activity,
          onComplete: _onComplete,
          onExit: _onExit,
        );
      case _FlowStage.completion:
        return ActivityCompletionScreen(
          activity: widget.activity,
          onDone: _onDone,
          onTryAnother: _onTryAnother,
          onBackToRecover: _onDone,
        );
    }
  }
}

enum _FlowStage { detail, guided, completion }
