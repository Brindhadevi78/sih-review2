import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/recovery_activity.dart';

class GuidedActivityScreen extends StatefulWidget {
  final RecoveryActivity activity;
  final VoidCallback onComplete;
  final VoidCallback onExit;

  const GuidedActivityScreen({
    super.key,
    required this.activity,
    required this.onComplete,
    required this.onExit,
  });

  @override
  State<GuidedActivityScreen> createState() => _GuidedActivityScreenState();
}

class _GuidedActivityScreenState extends State<GuidedActivityScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  bool _isBreathing = false;

  // Breathing state
  static const _breathPhases = [
    _BreathPhase('Breathe in', 4),
    _BreathPhase('Hold', 2),
    _BreathPhase('Breathe out', 6),
    _BreathPhase('Pause', 2),
  ];
  int _breathPhaseIndex = 0;
  int _breathCycle = 0;
  static const _totalCycles = 4;
  int _secondsLeft = 4;
  bool _paused = false;
  Timer? _timer;
  late AnimationController _breathAnim;

  @override
  void initState() {
    super.initState();
    _isBreathing = widget.activity.id == 'breathing_reset';
    _breathAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    if (_isBreathing) _startBreathing();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathAnim.dispose();
    super.dispose();
  }

  void _startBreathing() {
    _breathPhaseIndex = 0;
    _breathCycle = 0;
    _secondsLeft = _breathPhases[0].seconds;
    _paused = false;
    _runBreathTimer();
    _breathAnim.forward();
  }

  void _runBreathTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_paused) return;
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) {
          _breathPhaseIndex++;
          if (_breathPhaseIndex >= _breathPhases.length) {
            _breathPhaseIndex = 0;
            _breathCycle++;
            if (_breathCycle >= _totalCycles) {
              _timer?.cancel();
              widget.onComplete();
              return;
            }
          }
          _secondsLeft = _breathPhases[_breathPhaseIndex].seconds;
          _updateBreathAnim();
        }
      });
    });
  }

  void _updateBreathAnim() {
    final phase = _breathPhases[_breathPhaseIndex];
    _breathAnim.duration = Duration(seconds: phase.seconds);
    if (_breathPhaseIndex == 0) {
      _breathAnim.forward(from: 0);
    } else if (_breathPhaseIndex == 2) {
      _breathAnim.reverse(from: 1);
    }
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
  }

  bool get _isLastStep => _currentStep >= widget.activity.steps.length - 1;

  void _nextStep() {
    if (_isLastStep) {
      widget.onComplete();
    } else {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: cs.primaryContainer.withAlpha(40),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Exit activity',
          onPressed: () => _confirmExit(context),
        ),
        title: Text(
          widget.activity.title,
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: _isBreathing
                  ? _BreathingView(
                      phase: _breathPhases[_breathPhaseIndex],
                      secondsLeft: _secondsLeft,
                      cycle: _breathCycle,
                      totalCycles: _totalCycles,
                      paused: _paused,
                      anim: _breathAnim,
                      onTogglePause: _togglePause,
                      onExit: () => _confirmExit(context),
                      cs: cs,
                      theme: theme,
                    )
                  : _StepView(
                      activity: widget.activity,
                      currentStep: _currentStep,
                      onNext: _nextStep,
                      onPrev: _prevStep,
                      onExit: () => _confirmExit(context),
                      cs: cs,
                      theme: theme,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmExit(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave activity?'),
        content: const Text(
            'Your progress won\'t be saved. You can return whenever you\'d like.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Stay')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Leave')),
        ],
      ),
    );
    if (confirmed == true) widget.onExit();
  }
}

// ── Step-by-step view ─────────────────────────────────────────────────────────

class _StepView extends StatelessWidget {
  final RecoveryActivity activity;
  final int currentStep;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onExit;
  final ColorScheme cs;
  final ThemeData theme;

  const _StepView({
    required this.activity,
    required this.currentStep,
    required this.onNext,
    required this.onPrev,
    required this.onExit,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final total = activity.steps.length;
    final isLast = currentStep >= total - 1;

    return Column(
      children: [
        // Progress
        Row(
          children: [
            Text(
              'Step ${currentStep + 1} of $total',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurface.withAlpha(150)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (currentStep + 1) / total,
                  minHeight: 6,
                  backgroundColor: cs.primaryContainer,
                  valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Step card
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withAlpha(15),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(activity.icon, size: 32, color: cs.primary),
                ),
                const SizedBox(height: 28),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    activity.steps[currentStep],
                    key: ValueKey(currentStep),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Stop note
        Text(
          'Stop whenever you\'d like.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withAlpha(120)),
        ),
        const SizedBox(height: 16),

        // Navigation
        Row(
          children: [
            if (currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: onPrev,
                  child: const Text('Back'),
                ),
              ),
            if (currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: onNext,
                child: Text(isLast ? 'Complete' : 'Next'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onExit,
          child: Text('Exit',
              style: TextStyle(color: cs.onSurface.withAlpha(140))),
        ),
      ],
    );
  }
}

// ── Breathing view ────────────────────────────────────────────────────────────

class _BreathingView extends StatelessWidget {
  final _BreathPhase phase;
  final int secondsLeft;
  final int cycle;
  final int totalCycles;
  final bool paused;
  final AnimationController anim;
  final VoidCallback onTogglePause;
  final VoidCallback onExit;
  final ColorScheme cs;
  final ThemeData theme;

  const _BreathingView({
    required this.phase,
    required this.secondsLeft,
    required this.cycle,
    required this.totalCycles,
    required this.paused,
    required this.anim,
    required this.onTogglePause,
    required this.onExit,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Cycle ${cycle + 1} of $totalCycles',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withAlpha(150)),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (cycle + 1) / totalCycles,
            minHeight: 6,
            backgroundColor: cs.primaryContainer,
            valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
          ),
        ),
        const Spacer(),

        // Animated circle
        AnimatedBuilder(
          animation: anim,
          builder: (context2, child2) {
            final scale = 0.6 + anim.value * 0.4;
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.primary.withAlpha(30),
                  border: Border.all(
                      color: cs.primary.withAlpha(80), width: 2),
                ),
                child: Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.primary.withAlpha(60),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),

        Text(
          phase.label,
          style: theme.textTheme.headlineMedium
              ?.copyWith(color: cs.primary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          '$secondsLeft',
          style: theme.textTheme.displaySmall?.copyWith(
              color: cs.primary.withAlpha(180), fontWeight: FontWeight.w300),
        ),
        const Spacer(),

        Text(
          'Stop whenever you\'d like.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withAlpha(120)),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onTogglePause,
                icon: Icon(paused
                    ? Icons.play_arrow_rounded
                    : Icons.pause_rounded),
                label: Text(paused ? 'Resume' : 'Pause'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextButton(
                onPressed: onExit,
                child: Text('Exit',
                    style: TextStyle(color: cs.onSurface.withAlpha(140))),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BreathPhase {
  final String label;
  final int seconds;
  const _BreathPhase(this.label, this.seconds);
}
