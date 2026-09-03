import 'package:flutter/material.dart';
import '../models/platform_analytics.dart';

class PlatformAnalyticsProvider extends ChangeNotifier {
  PlatformAnalytics _analytics = const PlatformAnalytics();

  PlatformAnalytics get analytics => _analytics;

  void incrementCheckIns() {
    _analytics = _analytics.copyWith(
        totalCheckIns: _analytics.totalCheckIns + 1);
    notifyListeners();
  }

  void incrementCompletedActivities() {
    _analytics = _analytics.copyWith(
        completedActivities: _analytics.completedActivities + 1);
    notifyListeners();
  }

  void incrementPeerSupportApplications() {
    _analytics = _analytics.copyWith(
        peerSupportApplications: _analytics.peerSupportApplications + 1);
    notifyListeners();
  }

  void clear() {
    _analytics = const PlatformAnalytics();
    notifyListeners();
  }
}
