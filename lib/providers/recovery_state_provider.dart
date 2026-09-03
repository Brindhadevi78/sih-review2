import 'package:flutter/material.dart';
import '../models/recovery_state.dart';

class RecoveryStateProvider extends ChangeNotifier {
  RecoveryState _state = const RecoveryState();

  RecoveryState get state => _state;

  void setMood(CheckInMood mood) {
    _state = _state.copyWith(mood: mood);
    notifyListeners();
  }

  void setConfidence(int value) {
    _state = _state.copyWith(confidence: value.clamp(1, 5));
    notifyListeners();
  }

  void setSocialConnection(int value) {
    _state = _state.copyWith(socialConnection: value.clamp(1, 5));
    notifyListeners();
  }

  void incrementCompletedActivities() {
    _state = _state.copyWith(
        completedActivities: _state.completedActivities + 1);
    notifyListeners();
  }

  void clear() {
    _state = const RecoveryState();
    notifyListeners();
  }
}
