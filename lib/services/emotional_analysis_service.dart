// ── AI Service Abstraction ────────────────────────────────────────────────────
//
// EmotionalAnalysisService defines the contract for all emotional analysis
// implementations — mock or future production.
//
// PRODUCTION ARCHITECTURE (do not implement here):
//   Flutter app
//     ↓  (authenticated HTTPS)
//   Secure backend
//     ↓  (sanitized request — no raw journal text in logs)
//   AI provider
//     ↓  (sanitized emotional result only)
//   Flutter app
//
// NEVER place a production AI API key directly in the Flutter client.
// The RemoteEmotionalAnalysisService stub below marks the integration boundary.

import '../models/daily_reflection.dart';
import '../models/recovery_state.dart';

// ── Service mode ──────────────────────────────────────────────────────────────

/// Indicates which analysis implementation is active.
/// Remote is a future integration boundary — it does NOT call any API now.
enum AiServiceMode {
  /// Rule-based mock. Works fully offline. Clearly labelled in UI.
  mock,

  /// Future production boundary. Not implemented. Requires secure backend.
  remote,
}

// ── Abstract contract ─────────────────────────────────────────────────────────

/// Contract for all emotional analysis implementations.
///
/// Implementations must:
/// - Never retain raw journal text after the call returns.
/// - Never log journal text.
/// - Return only general emotional patterns — not diagnoses.
/// - Work without network access (or degrade gracefully).
abstract class EmotionalAnalysisService {
  /// The mode this service operates in.
  AiServiceMode get mode;

  /// Analyzes the given reflection and returns a general emotional insight.
  ///
  /// [reflection] — the current check-in data.
  /// [includeJournalText] — true only when AI consent is explicitly enabled
  ///   and the survivor has chosen to analyze this reflection.
  ///   When false, journal text must NOT be read from the reflection.
  ///
  /// Throws [EmotionalAnalysisException] on failure.
  /// The caller must catch this and preserve the reflection without insight.
  EmotionalInsight analyze(
    DailyReflection reflection, {
    required bool includeJournalText,
  });
}

// ── Exception ─────────────────────────────────────────────────────────────────

/// Thrown when analysis fails. Message must never contain journal text.
class EmotionalAnalysisException implements Exception {
  final String safeMessage;
  const EmotionalAnalysisException(this.safeMessage);

  @override
  String toString() => 'EmotionalAnalysisException: $safeMessage';
}

// ── Remote stub (future integration boundary) ─────────────────────────────────

/// Placeholder for a future secure backend integration.
/// This class intentionally does NOT implement any network call.
///
/// To integrate a real AI service:
/// 1. Implement this class with authenticated HTTPS calls to your backend.
/// 2. The backend sanitizes the request before forwarding to the AI provider.
/// 3. Only the sanitized EmotionalInsight result is returned to the client.
/// 4. Never include raw journal text in network logs or error messages.
class RemoteEmotionalAnalysisService implements EmotionalAnalysisService {
  const RemoteEmotionalAnalysisService();

  @override
  AiServiceMode get mode => AiServiceMode.remote;

  @override
  EmotionalInsight analyze(
    DailyReflection reflection, {
    required bool includeJournalText,
  }) {
    // Not implemented — production backend integration required.
    throw const EmotionalAnalysisException(
      'Remote AI service is not configured in this prototype.',
    );
  }
}

// ── Keyword categories for journal-aware mock analysis ────────────────────────

/// Simple keyword sets used by the mock engine.
/// These are intentionally broad and transparent — not a trained model.
const _stressWords = [
  'stress', 'stressed', 'pressure', 'overwhelm', 'too much',
  'deadline', 'exhausted', 'tired', 'burden', 'heavy',
];

const _worryWords = [
  'worry', 'worried', 'anxious', 'anxiety', 'nervous',
  'scared', 'fear', 'afraid', 'panic', 'uneasy',
];

const _sadWords = [
  'sad', 'lonely', 'alone', 'empty', 'hopeless',
  'cry', 'crying', 'hurt', 'pain', 'lost',
];

const _calmWords = [
  'calm', 'peaceful', 'okay', 'fine', 'settled',
  'quiet', 'rest', 'relax', 'breathe', 'steady',
];

const _positiveWords = [
  'happy', 'good', 'great', 'grateful', 'thankful',
  'hopeful', 'better', 'smile', 'joy', 'proud',
];

const _overwhelmedWords = [
  'overwhelmed', 'cannot cope', "can't cope", 'too much',
  'breaking', 'falling apart', 'no way out', 'stuck',
];

/// Returns a mood hint from journal text keyword matching, or null if no
/// strong signal is found. Used only when AI consent is explicitly enabled.
/// Journal text is NOT retained after this call.
CheckInMood? journalMoodHint(String journalText) {
  final lower = journalText.toLowerCase();

  int score(List<String> words) =>
      words.where((w) => lower.contains(w)).length;

  final scores = {
    CheckInMood.overwhelmed: score(_overwhelmedWords),
    CheckInMood.stressed: score(_stressWords),
    CheckInMood.anxious: score(_worryWords),
    CheckInMood.low: score(_sadWords),
    CheckInMood.good: score(_positiveWords),
    CheckInMood.okay: score(_calmWords),
  };

  final best = scores.entries
      .where((e) => e.value > 0)
      .fold<MapEntry<CheckInMood, int>?>(null, (prev, e) {
    if (prev == null || e.value > prev.value) return e;
    return prev;
  });

  return best?.key;
}
