import '../models/recovery_activity.dart';
import '../models/survivor_profile.dart';
import '../models/survivor_situation.dart';
import '../models/daily_reflection.dart';
import '../models/recovery_state.dart';
import '../providers/activity_history_provider.dart';

class RecoveryRecommendationEngine {
  RecoveryRecommendationEngine._();

  /// Returns up to [limit] ranked activities.
  static List<RecoveryActivity> recommend({
    required SurvivorProfile profile,
    DailyReflection? latestReflection,
    RecoveryState? recoveryState,
    ActivityHistoryProvider? history,
    int limit = 3,
  }) {
    final mood = latestReflection?.mood ?? recoveryState?.mood;
    final confidence = latestReflection?.confidence ?? recoveryState?.confidence;
    final connection =
        latestReflection?.socialConnection ?? recoveryState?.socialConnection;

    final scores = <String, int>{};

    for (final activity in kActivityLibrary) {
      int score = 0;

      // 1. Mood match (highest priority)
      if (mood != null && activity.suitableForMoods.contains(mood)) {
        score += 40;
      }

      // 2. Confidence
      if (confidence != null && confidence <= 2) {
        if (activity.suitableForConcerns.contains('Low confidence') ||
            activity.category == ActivityCategory.grow) {
          score += 30;
        }
      }

      // 3. Social connection
      if (connection != null && connection <= 2) {
        if (activity.category == ActivityCategory.reconnect) {
          score += 25;
        }
      }

      // 4. Current concerns
      for (final concern in profile.currentConcerns) {
        if (activity.suitableForConcerns.contains(concern)) {
          score += 15;
        }
      }

      // 5. Situation-based boosts
      score += _situationBoost(activity, profile.primarySituation);

      // 6. Activity preferences
      for (final pref in profile.activityPreferences) {
        if (activity.requiredPreferences.contains(pref)) {
          score += 10;
        }
        // Category-level preference match
        if (_prefMatchesCategory(pref, activity.category)) {
          score += 8;
        }
      }

      // 7. Penalise recently completed
      if (history != null && history.wasRecentlyCompleted(activity.id)) {
        score -= 50;
      }

      scores[activity.id] = score;
    }

    final sorted = List<RecoveryActivity>.from(kActivityLibrary)
      ..sort((a, b) => (scores[b.id] ?? 0).compareTo(scores[a.id] ?? 0));

    return sorted.take(limit).toList();
  }

  /// Returns the single best activity for "For You Today".
  static RecoveryActivity primaryRecommendation({
    required SurvivorProfile profile,
    DailyReflection? latestReflection,
    RecoveryState? recoveryState,
    ActivityHistoryProvider? history,
  }) {
    final mood = latestReflection?.mood ?? recoveryState?.mood;
    final confidence = latestReflection?.confidence ?? recoveryState?.confidence;
    final connection =
        latestReflection?.socialConnection ?? recoveryState?.socialConnection;

    // Fast-path: mood-based primary pick
    if (mood != null) {
      final moodPick = _moodPrimaryPick(mood, history);
      if (moodPick != null) return moodPick;
    }

    // Confidence override
    if (confidence != null && confidence <= 2) {
      final pick = _findById('confidence_reset', history);
      if (pick != null) return pick;
    }

    // Social connection override
    if (connection != null && connection <= 2) {
      final pick = _findById('think_someone_trust', history);
      if (pick != null) return pick;
    }

    // Preference-based fallback
    if (profile.activityPreferences.isNotEmpty) {
      final recs = recommend(
        profile: profile,
        latestReflection: latestReflection,
        recoveryState: recoveryState,
        history: history,
        limit: 1,
      );
      if (recs.isNotEmpty) return recs.first;
    }

    // Default
    return kActivityLibrary.firstWhere((a) => a.id == 'take_gentle_breath');
  }

  static RecoveryActivity? _moodPrimaryPick(
      CheckInMood mood, ActivityHistoryProvider? history) {
    final candidates = <String>[];
    switch (mood) {
      case CheckInMood.stressed:
        candidates.addAll(['grounding_2min', 'breathing_reset', 'calm_meditation']);
        break;
      case CheckInMood.anxious:
        candidates.addAll(['breathing_reset', 'grounding_2min', 'grounding_safety_pause']);
        break;
      case CheckInMood.low:
        candidates.addAll(['gentle_reflection', 'calm_meditation', 'confidence_reset']);
        break;
      case CheckInMood.overwhelmed:
        candidates.addAll(['grounding_safety_pause', 'grounding_2min', 'breathing_reset']);
        break;
      case CheckInMood.good:
        candidates.addAll(['celebrate_small_win', 'small_wins', 'explore_hobby']);
        break;
      case CheckInMood.okay:
        candidates.addAll(['confidence_reset', 'gentle_walk', 'private_journaling']);
        break;
    }
    for (final id in candidates) {
      if (history == null || !history.wasRecentlyCompleted(id)) {
        final found = kActivityLibrary.where((a) => a.id == id).toList();
        if (found.isNotEmpty) return found.first;
      }
    }
    return null;
  }

  static RecoveryActivity? _findById(
      String id, ActivityHistoryProvider? history) {
    if (history != null && history.wasRecentlyCompleted(id)) return null;
    final found = kActivityLibrary.where((a) => a.id == id).toList();
    return found.isNotEmpty ? found.first : null;
  }

  static int _situationBoost(
      RecoveryActivity activity, PrimarySituation? situation) {
    if (situation == null) return 0;
    switch (situation) {
      case PrimarySituation.workplace:
        if (activity.id == 'confidence_reset' ||
            activity.id == 'small_wins' ||
            activity.id == 'workplace_resources' ||
            activity.id == 'skill_building') { return 20; }
        break;
      case PrimarySituation.onlineDigital:
        if (activity.id == 'digital_wellbeing_pause' ||
            activity.id == 'digital_safety_resources' ||
            activity.id == 'breathing_reset' ||
            activity.id == 'grounding_2min') { return 20; }
        break;
      case PrimarySituation.partnerHusband:
      case PrimarySituation.familyRelative:
        if (activity.id == 'grounding_safety_pause' ||
            activity.id == 'grounding_2min' ||
            activity.id == 'confidence_reset') { return 20; }
        break;
      case PrimarySituation.childhoodPast:
        if (activity.id == 'gentle_reflection' ||
            activity.id == 'calm_meditation' ||
            activity.id == 'peer_support_info') { return 15; }
        break;
      case PrimarySituation.multipleOngoing:
        if (activity.id == 'grounding_safety_pause' ||
            activity.id == 'breathing_reset') { return 20; }
        break;
      default:
        break;
    }
    return 0;
  }

  static bool _prefMatchesCategory(String pref, ActivityCategory cat) {
    switch (pref) {
      case 'Breathing exercises':
      case 'Meditation':
        return cat == ActivityCategory.relax;
      case 'Journaling':
      case 'Creative activities':
        return cat == ActivityCategory.express;
      case 'Physical movement':
        return cat == ActivityCategory.move;
      case 'Social connection':
        return cat == ActivityCategory.reconnect;
      case 'Confidence building':
      case 'Learning and growth':
        return cat == ActivityCategory.grow;
      default:
        return false;
    }
  }
}
