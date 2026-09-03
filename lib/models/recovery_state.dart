enum CheckInMood { good, okay, low, stressed, anxious, overwhelmed }

extension CheckInMoodLabel on CheckInMood {
  String get emoji {
    switch (this) {
      case CheckInMood.good:
        return '😊';
      case CheckInMood.okay:
        return '🙂';
      case CheckInMood.low:
        return '😔';
      case CheckInMood.stressed:
        return '😰';
      case CheckInMood.anxious:
        return '😟';
      case CheckInMood.overwhelmed:
        return '😵';
    }
  }

  String get label {
    switch (this) {
      case CheckInMood.good:
        return 'Good';
      case CheckInMood.okay:
        return 'Okay';
      case CheckInMood.low:
        return 'Low';
      case CheckInMood.stressed:
        return 'Stressed';
      case CheckInMood.anxious:
        return 'Anxious';
      case CheckInMood.overwhelmed:
        return 'Overwhelmed';
    }
  }
}

class RecoveryState {
  final CheckInMood? mood;
  final int confidence;       // 1–5
  final int socialConnection; // 1–5
  final int completedActivities;
  final int milestones;

  const RecoveryState({
    this.mood,
    this.confidence = 3,
    this.socialConnection = 3,
    this.completedActivities = 3,
    this.milestones = 2,
  });

  RecoveryState copyWith({
    CheckInMood? mood,
    bool clearMood = false,
    int? confidence,
    int? socialConnection,
    int? completedActivities,
    int? milestones,
  }) {
    return RecoveryState(
      mood: clearMood ? null : (mood ?? this.mood),
      confidence: confidence ?? this.confidence,
      socialConnection: socialConnection ?? this.socialConnection,
      completedActivities: completedActivities ?? this.completedActivities,
      milestones: milestones ?? this.milestones,
    );
  }
}
