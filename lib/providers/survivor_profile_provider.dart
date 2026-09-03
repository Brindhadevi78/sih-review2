import 'package:flutter/material.dart';
import '../models/survivor_profile.dart';
import '../models/survivor_situation.dart';

class SurvivorProfileProvider extends ChangeNotifier {
  SurvivorProfile? _profile;

  SurvivorProfile? get profile => _profile;
  bool get onboardingCompleted => _profile?.onboardingCompleted ?? false;

  /// Called when a survivor session starts. Creates a fresh in-progress profile.
  void initProfile({required String userId, required String name, required String email}) {
    _profile = SurvivorProfile(
      userId: userId,
      name: name,
      email: email,
    );
    notifyListeners();
  }

  void skipOnboarding() {
    if (_profile == null) return;
    _profile = SurvivorProfile.defaultFor(
      userId: _profile!.userId,
      name: _profile!.name,
      email: _profile!.email,
    );
    notifyListeners();
  }

  /// Directly loads a pre-built completed profile (e.g. for demo mode).
  void loadCompletedProfile(SurvivorProfile profile) {
    _profile = profile;
    notifyListeners();
  }

  void updateSituation(PrimarySituation? situation, List<String> subcategories) {
    if (_profile == null) return;
    _profile = situation == null
        ? _profile!.copyWith(clearSituation: true, selectedSubcategories: [])
        : _profile!.copyWith(
            primarySituation: situation,
            selectedSubcategories: subcategories,
          );
    notifyListeners();
  }

  void updateWellbeing(List<String> concerns) {
    if (_profile == null) return;
    _profile = _profile!.copyWith(currentConcerns: concerns);
    notifyListeners();
  }

  void updateSupportPreferences(List<String> prefs, String? comfort) {
    if (_profile == null) return;
    _profile = comfort == null
        ? _profile!.copyWith(
            supportPreferences: prefs,
            clearCommunicationComfort: true,
          )
        : _profile!.copyWith(
            supportPreferences: prefs,
            communicationComfort: comfort,
          );
    notifyListeners();
  }

  void updateActivityPreferences(List<String> activities) {
    if (_profile == null) return;
    _profile = _profile!.copyWith(activityPreferences: activities);
    notifyListeners();
  }

  void updateAiConsent(bool consent) {
    if (_profile == null) return;
    _profile = _profile!.copyWith(aiAnalysisConsent: consent);
    notifyListeners();
  }

  void completeOnboarding() {
    if (_profile == null) return;
    _profile = _profile!.copyWith(onboardingCompleted: true);
    notifyListeners();
  }

  void clear() {
    _profile = null;
    notifyListeners();
  }
}
