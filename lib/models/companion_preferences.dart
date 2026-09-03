import 'package:flutter/material.dart';

enum CompanionCharacter { friendly, calm, playful }

enum CompanionOutfit { casual, cozy, simple }

enum CompanionAccessory { none, glasses, headphones, cap }

enum CompanionBackground { room, garden, cozyCorner, nightSky }

enum CompanionPersonality { calm, supportive, playful }

extension CompanionCharacterLabel on CompanionCharacter {
  String get label {
    switch (this) {
      case CompanionCharacter.friendly:
        return 'Friendly';
      case CompanionCharacter.calm:
        return 'Calm';
      case CompanionCharacter.playful:
        return 'Playful';
    }
  }
}

extension CompanionOutfitLabel on CompanionOutfit {
  String get label {
    switch (this) {
      case CompanionOutfit.casual:
        return 'Casual';
      case CompanionOutfit.cozy:
        return 'Cozy';
      case CompanionOutfit.simple:
        return 'Simple';
    }
  }
}

extension CompanionAccessoryLabel on CompanionAccessory {
  String get label {
    switch (this) {
      case CompanionAccessory.none:
        return 'None';
      case CompanionAccessory.glasses:
        return 'Glasses';
      case CompanionAccessory.headphones:
        return 'Headphones';
      case CompanionAccessory.cap:
        return 'Cap';
    }
  }
}

extension CompanionBackgroundLabel on CompanionBackground {
  String get label {
    switch (this) {
      case CompanionBackground.room:
        return 'Room';
      case CompanionBackground.garden:
        return 'Garden';
      case CompanionBackground.cozyCorner:
        return 'Cozy Corner';
      case CompanionBackground.nightSky:
        return 'Night Sky';
    }
  }

  Color get color {
    switch (this) {
      case CompanionBackground.room:
        return const Color(0xFFF3E5F5);
      case CompanionBackground.garden:
        return const Color(0xFFE8F5E9);
      case CompanionBackground.cozyCorner:
        return const Color(0xFFFFF8E1);
      case CompanionBackground.nightSky:
        return const Color(0xFFE8EAF6);
    }
  }
}

extension CompanionPersonalityLabel on CompanionPersonality {
  String get label {
    switch (this) {
      case CompanionPersonality.calm:
        return 'Calm';
      case CompanionPersonality.supportive:
        return 'Supportive';
      case CompanionPersonality.playful:
        return 'Playful';
    }
  }
}

class CompanionPreferences {
  final CompanionCharacter character;
  final CompanionOutfit outfit;
  final CompanionAccessory accessory;
  final CompanionBackground background;
  final CompanionPersonality personality;

  const CompanionPreferences({
    this.character = CompanionCharacter.friendly,
    this.outfit = CompanionOutfit.cozy,
    this.accessory = CompanionAccessory.none,
    this.background = CompanionBackground.room,
    this.personality = CompanionPersonality.supportive,
  });

  CompanionPreferences copyWith({
    CompanionCharacter? character,
    CompanionOutfit? outfit,
    CompanionAccessory? accessory,
    CompanionBackground? background,
    CompanionPersonality? personality,
  }) {
    return CompanionPreferences(
      character: character ?? this.character,
      outfit: outfit ?? this.outfit,
      accessory: accessory ?? this.accessory,
      background: background ?? this.background,
      personality: personality ?? this.personality,
    );
  }
}
