import 'package:flutter/material.dart';
import '../models/daily_reflection.dart';
import '../services/emotional_analysis_service.dart';
import '../services/mock_emotional_analysis_service.dart';

class ReflectionProvider extends ChangeNotifier {
  final List<DailyReflection> _reflections = [];

  /// The active analysis service. Defaults to mock — works fully offline.
  /// Replace with RemoteEmotionalAnalysisService for future production use.
  final EmotionalAnalysisService _analysisService =
      const MockEmotionalAnalysisService();

  /// The mode of the active service — exposed for UI labelling only.
  AiServiceMode get serviceMode => _analysisService.mode;

  List<DailyReflection> get allReflections =>
      List.unmodifiable(_reflections.reversed.toList());

  List<DailyReflection> getRecentReflections({int limit = 3}) =>
      allReflections.take(limit).toList();

  DailyReflection? getTodayReflection() {
    final today = DateTime.now();
    try {
      return _reflections.lastWhere((r) =>
          r.dateTime.year == today.year &&
          r.dateTime.month == today.month &&
          r.dateTime.day == today.day);
    } catch (_) {
      return null;
    }
  }

  void addReflection(DailyReflection reflection) {
    _reflections.add(reflection);
    notifyListeners();
  }

  /// Saves the reflection, running AI analysis only when:
  ///   1. [aiConsent] is explicitly true (survivor's profile consent).
  ///   2. [reflection.aiAnalysisRequested] is true (per-reflection choice).
  ///
  /// If analysis fails for any reason, the reflection is saved without insight.
  /// Journal text is passed to the service only when both conditions are met.
  /// Journal text is never stored inside this provider.
  void analyzeAndSave(DailyReflection reflection, {required bool aiConsent}) {
    DailyReflection toSave = reflection;

    final shouldAnalyze = aiConsent && reflection.aiAnalysisRequested;

    if (shouldAnalyze) {
      try {
        final insight = _analysisService.analyze(
          reflection,
          includeJournalText: aiConsent,
        );
        toSave = reflection.copyWith(
          aiAnalysisCompleted: true,
          insight: insight,
        );
      } on EmotionalAnalysisException {
        // Analysis failed — save reflection without insight.
        // Do not log the exception message (it may reference private context).
        toSave = reflection.copyWith(
          aiAnalysisRequested: true,
          aiAnalysisCompleted: false,
        );
      } catch (_) {
        // Unexpected failure — preserve reflection, drop insight silently.
        toSave = reflection.copyWith(
          aiAnalysisRequested: true,
          aiAnalysisCompleted: false,
        );
      }
    } else {
      // Consent not given or analysis not requested — save as-is.
      toSave = reflection.copyWith(
        aiAnalysisRequested: false,
        aiAnalysisCompleted: false,
      );
    }

    _reflections.add(toSave);
    notifyListeners();
  }

  /// Clears journal text from all reflections while preserving check-in data.
  void deleteJournalText() {
    for (int i = 0; i < _reflections.length; i++) {
      _reflections[i] = _reflections[i].copyWith(clearJournal: true);
    }
    notifyListeners();
  }

  void clearReflections() {
    _reflections.clear();
    notifyListeners();
  }
}

/// Builds a fresh in-progress reflection with a unique id.
DailyReflection newBlankReflection() => DailyReflection(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dateTime: DateTime.now(),
    );

String confidenceLabel(int? v) {
  switch (v) {
    case 1:
      return 'Very low';
    case 2:
      return 'Low';
    case 3:
      return 'Okay';
    case 4:
      return 'Good';
    case 5:
      return 'Strong';
    default:
      return 'Not recorded';
  }
}

String connectionLabel(int? v) {
  switch (v) {
    case 1:
      return 'Very disconnected';
    case 2:
      return 'A little disconnected';
    case 3:
      return 'Some connection';
    case 4:
      return 'Connected';
    case 5:
      return 'Very connected';
    default:
      return 'Not recorded';
  }
}
