// MOCK ONLY — Prototype AI. Not a real AI service. Not a diagnosis.
//
// This service uses simple rule-based logic and optional keyword matching.
// It does NOT diagnose conditions. It does NOT contact any external service.
// It does NOT retain journal text after the analyze() call returns.

import '../models/daily_reflection.dart';
import '../models/recovery_state.dart';
import 'emotional_analysis_service.dart';

class MockEmotionalAnalysisService implements EmotionalAnalysisService {
  const MockEmotionalAnalysisService();

  @override
  AiServiceMode get mode => AiServiceMode.mock;

  /// Analyzes the reflection using mood, confidence, social connection, and
  /// (only when [includeJournalText] is true) simple keyword matching on the
  /// journal text.
  ///
  /// Journal text is read locally and immediately discarded — it is never
  /// stored, logged, or passed to any external service.
  @override
  EmotionalInsight analyze(
    DailyReflection reflection, {
    required bool includeJournalText,
  }) {
    CheckInMood? effectiveMood = reflection.mood;

    if (includeJournalText &&
        reflection.journalText != null &&
        reflection.journalText!.trim().isNotEmpty) {
      // Journal keyword hint — used only to strengthen the signal, never
      // to override a clear mood selection with a less distressed one.
      final hint = journalMoodHint(reflection.journalText!);
      if (hint != null && effectiveMood == null) {
        effectiveMood = hint;
      } else if (hint != null && _isMoreNegative(hint, effectiveMood!)) {
        effectiveMood = hint;
      }
      // Journal text is not retained beyond this point.
    }

    final conf = reflection.confidence;
    final conn = reflection.socialConnection;
    final lowConf = conf != null && conf <= 2;
    final lowConn = conn != null && conn <= 2;

    return _buildInsight(effectiveMood, lowConf: lowConf, lowConn: lowConn);
  }

  // ── Insight builder ─────────────────────────────────────────────────────────

  EmotionalInsight _buildInsight(
    CheckInMood? mood, {
    required bool lowConf,
    required bool lowConn,
  }) {
    switch (mood) {
      case CheckInMood.good:
        return EmotionalInsight(
          pattern: 'Positive',
          message:
              'Your check-in suggests you may be feeling good today. That\'s worth noticing.',
          supportMessage:
              'Take a moment to acknowledge what contributed to this feeling. '
              'You don\'t have to do anything with it — just notice it.',
          suggestedStep: lowConn
              ? 'Consider reaching out to someone you trust, even briefly.'
              : 'Write one thing you\'re grateful for today.',
        );

      case CheckInMood.okay:
        return EmotionalInsight(
          pattern: 'Calm',
          message:
              'Your check-in suggests you may be feeling steady today.',
          supportMessage:
              'Steady days are valuable. You don\'t have to feel great to be doing well. '
              'Being okay is enough.',
          suggestedStep: lowConf
              ? 'Try a short breathing exercise to stay grounded.'
              : 'Take a gentle walk or a quiet moment for yourself.',
        );

      case CheckInMood.low:
        return EmotionalInsight(
          pattern: 'Sad',
          message:
              'Your check-in suggests you may be feeling low today. That\'s okay.',
          supportMessage:
              'Difficult days are part of recovery. You don\'t have to solve everything at once. '
              'Being here and checking in is already a step.',
          suggestedStep:
              'Try a gentle reflection — write one small thing that felt okay today, '
              'even if it was very small.',
        );

      case CheckInMood.stressed:
        return EmotionalInsight(
          pattern: 'Stressed',
          message:
              'Your check-in suggests you may be feeling tense or stressed today.',
          supportMessage:
              'Stress can feel heavy. You don\'t have to carry it all at once. '
              'It\'s okay to take a small break.',
          suggestedStep: lowConf
              ? 'Try a 2-minute grounding exercise — notice 5 things you can see around you.'
              : 'Try a short breathing exercise: breathe in for 4, hold for 2, out for 6.',
        );

      case CheckInMood.anxious:
        return EmotionalInsight(
          pattern: 'Anxious',
          message:
              'Your check-in suggests you may be feeling anxious or unsettled today.',
          supportMessage:
              'Anxiety can feel overwhelming. You are not alone in this. '
              'It\'s okay to slow down.',
          suggestedStep:
              'Try a calm breathing exercise — breathe in for 4 counts, '
              'hold for 4, breathe out for 4. Repeat as many times as feels right.',
        );

      case CheckInMood.overwhelmed:
        return EmotionalInsight(
          pattern: 'Overwhelmed',
          message:
              'Your check-in suggests you may be feeling overwhelmed today.',
          supportMessage:
              'It\'s okay to feel overwhelmed. You don\'t need to do everything right now. '
              'One small thing at a time is enough.',
          suggestedStep: lowConn
              ? 'Reach out to someone you trust, or explore the Support tab when you\'re ready.'
              : 'Take one small step — even just a glass of water and a quiet moment.',
        );

      default:
        return EmotionalInsight(
          pattern: 'Calm',
          message: 'Thank you for taking a moment to check in today.',
          supportMessage:
              'Every check-in is a small act of self-care. '
              'You showed up for yourself today.',
          suggestedStep:
              'Take a gentle breath and notice how you feel right now.',
        );
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  bool _isMoreNegative(CheckInMood hint, CheckInMood current) {
    const order = [
      CheckInMood.good,
      CheckInMood.okay,
      CheckInMood.low,
      CheckInMood.anxious,
      CheckInMood.stressed,
      CheckInMood.overwhelmed,
    ];
    return order.indexOf(hint) > order.indexOf(current);
  }
}
