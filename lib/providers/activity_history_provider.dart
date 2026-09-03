import 'package:flutter/material.dart';
import '../models/completed_activity.dart';
import '../models/recovery_activity.dart';

class ActivityHistoryProvider extends ChangeNotifier {
  final List<CompletedActivity> _history = [];

  List<CompletedActivity> get completedActivities =>
      List.unmodifiable(_history.reversed.toList());

  int get totalCompleted => _history.length;

  void completeActivity(RecoveryActivity activity) {
    _history.add(CompletedActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      activityId: activity.id,
      title: activity.title,
      category: activity.category,
      completedAt: DateTime.now(),
      duration: activity.duration,
    ));
    notifyListeners();
  }

  List<CompletedActivity> getCompletedActivities() => completedActivities;

  /// Returns true if the activity was completed within the last 24 hours.
  bool wasRecentlyCompleted(String activityId) {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    return _history.any(
      (c) => c.activityId == activityId && c.completedAt.isAfter(cutoff),
    );
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
