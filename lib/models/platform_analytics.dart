class PlatformAnalytics {
  final int totalCheckIns;
  final int completedActivities;
  final int peerSupportApplications;

  const PlatformAnalytics({
    this.totalCheckIns = 0,
    this.completedActivities = 0,
    this.peerSupportApplications = 0,
  });

  PlatformAnalytics copyWith({
    int? totalCheckIns,
    int? completedActivities,
    int? peerSupportApplications,
  }) {
    return PlatformAnalytics(
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
      completedActivities: completedActivities ?? this.completedActivities,
      peerSupportApplications:
          peerSupportApplications ?? this.peerSupportApplications,
    );
  }
}
