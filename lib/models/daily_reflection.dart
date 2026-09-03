import 'recovery_state.dart';

class DailyReflection {
  final String id;
  final DateTime dateTime;
  final CheckInMood? mood;
  final int? confidence;       // 1–5, null if skipped
  final int? socialConnection; // 1–5, null if skipped
  final String? journalText;
  final bool aiAnalysisRequested;
  final bool aiAnalysisCompleted;
  final EmotionalInsight? insight;

  const DailyReflection({
    required this.id,
    required this.dateTime,
    this.mood,
    this.confidence,
    this.socialConnection,
    this.journalText,
    this.aiAnalysisRequested = false,
    this.aiAnalysisCompleted = false,
    this.insight,
  });

  DailyReflection copyWith({
    CheckInMood? mood,
    bool clearMood = false,
    int? confidence,
    bool clearConfidence = false,
    int? socialConnection,
    bool clearConnection = false,
    String? journalText,
    bool clearJournal = false,
    bool? aiAnalysisRequested,
    bool? aiAnalysisCompleted,
    EmotionalInsight? insight,
  }) {
    return DailyReflection(
      id: id,
      dateTime: dateTime,
      mood: clearMood ? null : (mood ?? this.mood),
      confidence: clearConfidence ? null : (confidence ?? this.confidence),
      socialConnection:
          clearConnection ? null : (socialConnection ?? this.socialConnection),
      journalText:
          clearJournal ? null : (journalText ?? this.journalText),
      aiAnalysisRequested:
          aiAnalysisRequested ?? this.aiAnalysisRequested,
      aiAnalysisCompleted:
          aiAnalysisCompleted ?? this.aiAnalysisCompleted,
      insight: insight ?? this.insight,
    );
  }
}

class EmotionalInsight {
  /// General emotional pattern label — NOT a diagnosis.
  final String pattern;
  final String message;
  final String supportMessage;
  final String suggestedStep;

  const EmotionalInsight({
    required this.pattern,
    required this.message,
    required this.supportMessage,
    required this.suggestedStep,
  });
}
