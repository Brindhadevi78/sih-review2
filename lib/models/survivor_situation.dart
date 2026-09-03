/// Primary situation categories a survivor may identify with.
enum PrimarySituation {
  partnerHusband,
  familyRelative,
  datingKnownPerson,
  workplace,
  childhoodPast,
  strangerPublic,
  onlineDigital,
  multipleOngoing,
  preferNotToSay,
}

extension PrimarySituationLabel on PrimarySituation {
  String get label {
    switch (this) {
      case PrimarySituation.partnerHusband:
        return 'Partner / Husband';
      case PrimarySituation.familyRelative:
        return 'Family / Relative';
      case PrimarySituation.datingKnownPerson:
        return 'Dating / Known Person';
      case PrimarySituation.workplace:
        return 'Workplace / Harassment';
      case PrimarySituation.childhoodPast:
        return 'Childhood / Past';
      case PrimarySituation.strangerPublic:
        return 'Stranger / Public Space';
      case PrimarySituation.onlineDigital:
        return 'Online / Digital';
      case PrimarySituation.multipleOngoing:
        return 'Multiple / Ongoing';
      case PrimarySituation.preferNotToSay:
        return 'Prefer not to say';
    }
  }
}

/// Returns subcategory labels for a given primary situation.
Map<PrimarySituation, List<String>> get situationSubcategories => {
      PrimarySituation.partnerHusband: [
        'Physical violence',
        'Sexual violence',
        'Emotional / verbal abuse',
        'Financial abuse',
        'Controlling behaviour',
        'Threats / intimidation',
      ],
      PrimarySituation.familyRelative: [
        'Physical abuse',
        'Sexual abuse',
        'Emotional abuse',
        'Threats / control',
      ],
      PrimarySituation.datingKnownPerson: [
        'Physical violence',
        'Sexual coercion',
        'Emotional abuse',
        'Stalking',
        'Threats',
      ],
      PrimarySituation.workplace: [
        'Sexual harassment',
        'Verbal harassment',
        'Physical abuse',
        'Abuse of authority',
        'Workplace intimidation',
      ],
      PrimarySituation.childhoodPast: [
        'Childhood physical abuse',
        'Childhood sexual abuse',
        'Past emotional abuse',
        'Long-term recovery support',
      ],
      PrimarySituation.strangerPublic: [
        'Physical assault',
        'Sexual assault',
        'Harassment',
        'Stalking',
      ],
      PrimarySituation.onlineDigital: [
        'Cyberstalking',
        'Online sexual harassment',
        'Threats',
        'Image-based abuse',
        'Blackmail',
      ],
      PrimarySituation.multipleOngoing: [
        'Multiple forms of abuse',
        'Multiple abusers',
        'Ongoing unsafe situation',
      ],
      PrimarySituation.preferNotToSay: [],
    };
