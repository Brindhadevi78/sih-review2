import 'package:flutter/material.dart';
import '../../../app/app.dart';
import '../../../models/daily_reflection.dart';
import '../../../models/recovery_state.dart';
import 'step_mood.dart';
import 'step_confidence.dart';
import 'step_connection.dart';
import 'step_journal.dart';
import 'step_ai_consent.dart';
import 'step_summary.dart';
import 'step_saved.dart';

/// Manages the in-progress reflection as mutable state during the flow.
class CheckInFlow extends StatefulWidget {
  final VoidCallback onGoHome;
  const CheckInFlow({super.key, required this.onGoHome});

  @override
  State<CheckInFlow> createState() => _CheckInFlowState();
}

class _CheckInFlowState extends State<CheckInFlow> {
  final PageController _page = PageController();
  int _currentPage = 0;
  static const int _total = 6; // steps 1–6 (mood→confidence→connection→journal→consent→summary)

  // In-progress reflection fields
  CheckInMood? _mood;
  int? _confidence;
  int? _connection;
  String? _journalText;
  bool _aiRequested = false;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _total) {
      _page.nextPage(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut);
    }
  }

  void _back() {
    if (_currentPage > 0) {
      _page.previousPage(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut);
    } else {
      Navigator.pop(context);
    }
  }

  void _save() {
    // Read AI consent from profile — null/false both mean no analysis.
    final aiConsent =
        SurvivorProfileScope.of(context).profile?.aiAnalysisConsent ?? false;

    final reflection = DailyReflection(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dateTime: DateTime.now(),
      mood: _mood,
      confidence: _confidence,
      socialConnection: _connection,
      // Journal text is stored in the reflection for the survivor's own view.
      // It is passed to the analysis service only when aiConsent is true.
      journalText: _journalText,
      // Per-reflection request is only meaningful when global consent is on.
      aiAnalysisRequested: aiConsent && _aiRequested,
    );

    // analyzeAndSave checks consent before touching journal text.
    ReflectionScope.of(context)
        .analyzeAndSave(reflection, aiConsent: aiConsent);
    PlatformAnalyticsScope.of(context).incrementCheckIns();
    CompanionScope.of(context).respondToMood(_mood);

    final rsp = RecoveryStateScope.of(context);
    if (_mood != null) rsp.setMood(_mood!);
    if (_confidence != null) rsp.setConfidence(_confidence!);
    if (_connection != null) rsp.setSocialConnection(_connection!);

    _page.animateToPage(6,
        duration: const Duration(milliseconds: 280), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: PageView(
        controller: _page,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (i) => setState(() => _currentPage = i),
        children: [
          // Page 0 — Mood
          StepMood(
            stepNumber: 1,
            totalSteps: _total,
            selected: _mood,
            onSelect: (m) => setState(() => _mood = m),
            onContinue: _next,
            onSkip: _next,
            onBack: _back,
          ),
          // Page 1 — Confidence
          StepConfidence(
            stepNumber: 2,
            totalSteps: _total,
            value: _confidence,
            onSelect: (v) => setState(() => _confidence = v),
            onContinue: _next,
            onSkip: _next,
            onBack: _back,
          ),
          // Page 2 — Connection
          StepConnection(
            stepNumber: 3,
            totalSteps: _total,
            value: _connection,
            onSelect: (v) => setState(() => _connection = v),
            onContinue: _next,
            onSkip: _next,
            onBack: _back,
          ),
          // Page 3 — Journal
          StepJournal(
            stepNumber: 4,
            totalSteps: _total,
            text: _journalText,
            onChanged: (t) => setState(() => _journalText = t),
            onContinue: _next,
            onSkip: _next,
            onBack: _back,
          ),
          // Page 4 — AI Consent
          StepAiConsent(
            stepNumber: 5,
            totalSteps: _total,
            onAllow: () {
              setState(() => _aiRequested = true);
              _next();
            },
            onDecline: () {
              setState(() => _aiRequested = false);
              _next();
            },
            onBack: _back,
          ),
          // Page 5 — Summary
          StepSummary(
            stepNumber: 6,
            totalSteps: _total,
            mood: _mood,
            confidence: _confidence,
            connection: _connection,
            journalText: _journalText,
            aiRequested: _aiRequested,
            onSave: _save,
            onBack: _back,
            onEditMood: () => _page.animateToPage(0,
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut),
          ),
          // Page 6 — Saved
          StepSaved(onGoHome: widget.onGoHome),
        ],
      ),
    );
  }
}
