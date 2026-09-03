import 'package:flutter/material.dart';
import '../models/companion_preferences.dart';
import '../models/recovery_state.dart';

enum CompanionAction { idle, waving, breathing, celebrating, thinking, resting }

extension CompanionActionLabel on CompanionAction {
  String get label {
    switch (this) {
      case CompanionAction.idle:
        return 'Here with you';
      case CompanionAction.waving:
        return 'Waving hello';
      case CompanionAction.breathing:
        return 'Calm breathing';
      case CompanionAction.celebrating:
        return 'Celebrating with you';
      case CompanionAction.thinking:
        return 'Thinking gently';
      case CompanionAction.resting:
        return 'Resting quietly';
    }
  }
}

class CompanionProvider extends ChangeNotifier {
  CompanionPreferences _preferences = const CompanionPreferences();
  CompanionAction _action = CompanionAction.idle;

  CompanionPreferences get preferences => _preferences;
  CompanionAction get action => _action;

  void updatePreferences(CompanionPreferences prefs) {
    _preferences = prefs;
    notifyListeners();
  }

  void setAction(CompanionAction action) {
    _action = action;
    notifyListeners();
  }

  /// Derive action from current mood — no diagnosis, just a gentle response.
  void respondToMood(CheckInMood? mood) {
    switch (mood) {
      case CheckInMood.good:
        _action = CompanionAction.celebrating;
        break;
      case CheckInMood.okay:
        _action = CompanionAction.waving;
        break;
      case CheckInMood.low:
      case CheckInMood.overwhelmed:
        _action = CompanionAction.resting;
        break;
      case CheckInMood.stressed:
      case CheckInMood.anxious:
        _action = CompanionAction.breathing;
        break;
      default:
        _action = CompanionAction.idle;
    }
    notifyListeners();
  }

  /// Returns a short mood-aware message based on personality + mood.
  String message(CheckInMood? mood) {
    final p = _preferences.personality;
    switch (mood) {
      case CheckInMood.good:
        switch (p) {
          case CompanionPersonality.calm:
            return 'That sounds like a moment worth noticing.';
          case CompanionPersonality.supportive:
            return 'I\'m glad you\'re feeling this way right now.';
          case CompanionPersonality.playful:
            return 'That\'s a good moment — hold onto it!';
        }
      case CheckInMood.okay:
        switch (p) {
          case CompanionPersonality.calm:
            return 'Take things at your own pace.';
          case CompanionPersonality.supportive:
            return 'I\'m here for this small moment with you.';
          case CompanionPersonality.playful:
            return 'Ready for one tiny step?';
        }
      case CheckInMood.low:
        switch (p) {
          case CompanionPersonality.calm:
            return 'You don\'t have to figure everything out right now.';
          case CompanionPersonality.supportive:
            return 'It\'s okay to just be here for a moment.';
          case CompanionPersonality.playful:
            return 'Even small moments count. I\'m here.';
        }
      case CheckInMood.stressed:
        switch (p) {
          case CompanionPersonality.calm:
            return 'Let\'s slow things down for a moment.';
          case CompanionPersonality.supportive:
            return 'You\'re doing okay. One breath at a time.';
          case CompanionPersonality.playful:
            return 'Pause. Breathe. You\'ve got this moment.';
        }
      case CheckInMood.anxious:
        switch (p) {
          case CompanionPersonality.calm:
            return 'Would a grounding activity feel okay?';
          case CompanionPersonality.supportive:
            return 'I\'m right here. No rush at all.';
          case CompanionPersonality.playful:
            return 'Let\'s try one tiny grounding thing together.';
        }
      case CheckInMood.overwhelmed:
        switch (p) {
          case CompanionPersonality.calm:
            return 'Just this moment. Nothing else is needed right now.';
          case CompanionPersonality.supportive:
            return 'You don\'t have to carry everything at once.';
          case CompanionPersonality.playful:
            return 'One small breath. That\'s enough for now.';
        }
      default:
        switch (p) {
          case CompanionPersonality.calm:
            return 'Whenever you\'re ready, we can take one small step.';
          case CompanionPersonality.supportive:
            return 'Your companion is here with you.';
          case CompanionPersonality.playful:
            return 'Hello! Ready when you are.';
        }
    }
  }

  void reset() {
    _preferences = const CompanionPreferences();
    _action = CompanionAction.idle;
    notifyListeners();
  }
}
