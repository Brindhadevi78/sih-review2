import 'survivor_situation.dart';

class SurvivorProfile {
  final String userId;
  final String name;
  final String email;

  // Step 2
  final PrimarySituation? primarySituation;
  final List<String> selectedSubcategories;

  // Step 3
  final List<String> currentConcerns;

  // Step 4
  final List<String> supportPreferences;
  final String? communicationComfort;

  // Step 5
  final List<String> activityPreferences;

  // Step 6
  final bool aiAnalysisConsent;

  // Completion flag
  final bool onboardingCompleted;

  const SurvivorProfile({
    required this.userId,
    required this.name,
    required this.email,
    this.primarySituation,
    this.selectedSubcategories = const [],
    this.currentConcerns = const [],
    this.supportPreferences = const [],
    this.communicationComfort,
    this.activityPreferences = const [],
    this.aiAnalysisConsent = false,
    this.onboardingCompleted = false,
  });

  SurvivorProfile copyWith({
    PrimarySituation? primarySituation,
    bool clearSituation = false,
    List<String>? selectedSubcategories,
    List<String>? currentConcerns,
    List<String>? supportPreferences,
    String? communicationComfort,
    bool clearCommunicationComfort = false,
    List<String>? activityPreferences,
    bool? aiAnalysisConsent,
    bool? onboardingCompleted,
  }) {
    return SurvivorProfile(
      userId: userId,
      name: name,
      email: email,
      primarySituation:
          clearSituation ? null : (primarySituation ?? this.primarySituation),
      selectedSubcategories:
          selectedSubcategories ?? this.selectedSubcategories,
      currentConcerns: currentConcerns ?? this.currentConcerns,
      supportPreferences: supportPreferences ?? this.supportPreferences,
      communicationComfort: clearCommunicationComfort
          ? null
          : (communicationComfort ?? this.communicationComfort),
      activityPreferences: activityPreferences ?? this.activityPreferences,
      aiAnalysisConsent: aiAnalysisConsent ?? this.aiAnalysisConsent,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  /// Returns a default completed profile (used when user skips onboarding).
  factory SurvivorProfile.defaultFor({
    required String userId,
    required String name,
    required String email,
  }) {
    return SurvivorProfile(
      userId: userId,
      name: name,
      email: email,
      onboardingCompleted: true,
    );
  }
}
