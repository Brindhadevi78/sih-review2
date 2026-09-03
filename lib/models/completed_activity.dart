import 'recovery_activity.dart';

class CompletedActivity {
  final String id;
  final String activityId;
  final String title;
  final ActivityCategory category;
  final DateTime completedAt;
  final String duration;

  const CompletedActivity({
    required this.id,
    required this.activityId,
    required this.title,
    required this.category,
    required this.completedAt,
    required this.duration,
  });
}
