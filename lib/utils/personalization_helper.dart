import 'package:flutter/material.dart';
import '../models/survivor_profile.dart';
import '../models/survivor_situation.dart';
import '../models/recovery_state.dart';

// ── Data classes ──────────────────────────────────────────────────────────────

class Recommendation {
  final String title;
  final String description;
  final String category;
  final IconData icon;

  const Recommendation({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
  });
}

class SmallStep {
  final String title;
  final String description;

  const SmallStep({required this.title, required this.description});
}

class SupportOption {
  final String title;
  final String description;
  final IconData icon;

  const SupportOption({
    required this.title,
    required this.description,
    required this.icon,
  });
}

// ── Helper ────────────────────────────────────────────────────────────────────

class PersonalizationHelper {
  PersonalizationHelper._();

  // ── Greeting ─────────────────────────────────────────────────────────────────

  static String greeting(SurvivorProfile profile) {
    final hour = DateTime.now().hour;
    final name = profile.name.isNotEmpty ? profile.name : 'there';
    if (hour >= 5 && hour < 12) return 'Good morning, $name.';
    if (hour >= 12 && hour < 17) return 'Good afternoon, $name.';
    if (hour >= 17 && hour < 21) return 'Good evening, $name.';
    return 'Take a gentle moment for yourself, $name.';
  }

  // ── One Small Step ────────────────────────────────────────────────────────────

  static SmallStep oneSmallStep(SurvivorProfile profile) {
    final concerns = profile.currentConcerns;
    final situation = profile.primarySituation;

    if (situation == PrimarySituation.workplace &&
        concerns.contains('Low confidence')) {
      return const SmallStep(
        title: 'Confidence Reset',
        description:
            'Take 3 minutes to reconnect with your strengths and abilities.',
      );
    }
    if (situation == PrimarySituation.onlineDigital) {
      return const SmallStep(
        title: 'Digital Safety Pause',
        description:
            'Take a moment to review your digital boundaries and give yourself some breathing room.',
      );
    }
    if (situation == PrimarySituation.partnerHusband ||
        situation == PrimarySituation.familyRelative) {
      return const SmallStep(
        title: 'Grounding & Safety Pause',
        description: 'Take a quiet moment to reconnect with yourself.',
      );
    }
    if (concerns.contains('Stress') ||
        concerns.contains('Feeling overwhelmed')) {
      return const SmallStep(
        title: '2-Minute Grounding',
        description: 'Slow down and reconnect with the present moment.',
      );
    }
    if (concerns.contains('Low mood')) {
      return const SmallStep(
        title: 'Gentle Reflection',
        description:
            'Give yourself a few quiet minutes to acknowledge how you\'re feeling.',
      );
    }
    if (concerns.contains('Anxiety')) {
      return const SmallStep(
        title: 'Calm Breathing',
        description: 'A gentle breathing exercise for anxious moments.',
      );
    }
    return const SmallStep(
      title: 'Take a Gentle Breath',
      description: 'Start with one small moment of calm.',
    );
  }

  // ── Detailed Recommendations (3 cards) ───────────────────────────────────────

  static List<Recommendation> detailedRecommendations(
      SurvivorProfile profile) {
    final concerns = profile.currentConcerns;
    final situation = profile.primarySituation;
    final results = <Recommendation>[];

    if (situation == PrimarySituation.workplace) {
      results.addAll([
        const Recommendation(
          title: 'Workplace Confidence',
          description: 'Reconnect with your professional strengths.',
          category: 'Grow',
          icon: Icons.emoji_events_outlined,
        ),
        const Recommendation(
          title: 'Strength Reflection',
          description: 'Notice what you have overcome.',
          category: 'Express',
          icon: Icons.edit_note_rounded,
        ),
        const Recommendation(
          title: 'Small Wins Journal',
          description: 'Record one small win from today.',
          category: 'Express',
          icon: Icons.book_outlined,
        ),
      ]);
    } else if (situation == PrimarySituation.onlineDigital) {
      results.addAll([
        const Recommendation(
          title: 'Digital Safety',
          description: 'Review your online boundaries at your own pace.',
          category: 'Grow',
          icon: Icons.security_outlined,
        ),
        const Recommendation(
          title: 'Grounding Exercise',
          description: 'Reconnect with the present moment.',
          category: 'Relax',
          icon: Icons.self_improvement_rounded,
        ),
        const Recommendation(
          title: 'Emotional Reflection',
          description: 'Write a few words about how you are feeling.',
          category: 'Express',
          icon: Icons.edit_note_rounded,
        ),
      ]);
    } else if (situation == PrimarySituation.partnerHusband ||
        situation == PrimarySituation.familyRelative) {
      results.addAll([
        const Recommendation(
          title: 'Grounding',
          description: 'A gentle exercise to feel safe and present.',
          category: 'Relax',
          icon: Icons.self_improvement_rounded,
        ),
        const Recommendation(
          title: 'Confidence Building',
          description: 'Small steps to reconnect with your sense of self.',
          category: 'Grow',
          icon: Icons.emoji_events_outlined,
        ),
        const Recommendation(
          title: "Women's Support Resources",
          description: 'Access support services when you feel ready.',
          category: 'Support',
          icon: Icons.volunteer_activism_outlined,
        ),
      ]);
    } else if (situation == PrimarySituation.childhoodPast) {
      results.addAll([
        const Recommendation(
          title: 'Gentle Reflection',
          description: 'Acknowledge your journey at your own pace.',
          category: 'Express',
          icon: Icons.edit_note_rounded,
        ),
        const Recommendation(
          title: 'Calm Breathing',
          description: 'A breathing exercise for difficult moments.',
          category: 'Relax',
          icon: Icons.air_rounded,
        ),
        const Recommendation(
          title: 'Peer Support',
          description: 'Connect with someone who understands.',
          category: 'Reconnect',
          icon: Icons.groups_outlined,
        ),
      ]);
    } else if (situation == PrimarySituation.strangerPublic ||
        situation == PrimarySituation.datingKnownPerson) {
      results.addAll([
        const Recommendation(
          title: 'Safety Grounding',
          description: 'Reconnect with your sense of safety.',
          category: 'Relax',
          icon: Icons.self_improvement_rounded,
        ),
        const Recommendation(
          title: 'Boundary Reflection',
          description: 'Gently explore what feels safe for you.',
          category: 'Express',
          icon: Icons.edit_note_rounded,
        ),
        const Recommendation(
          title: 'Professional Support',
          description: 'Speak with a counsellor when you are ready.',
          category: 'Support',
          icon: Icons.psychology_outlined,
        ),
      ]);
    } else if (situation == PrimarySituation.multipleOngoing) {
      results.addAll([
        const Recommendation(
          title: 'Safety Resources',
          description: 'Access safety information at your own pace.',
          category: 'Support',
          icon: Icons.shield_outlined,
        ),
        const Recommendation(
          title: 'Grounding',
          description: 'A gentle exercise to feel present and safe.',
          category: 'Relax',
          icon: Icons.self_improvement_rounded,
        ),
        const Recommendation(
          title: 'Professional Support',
          description: 'Speak with a counsellor when you are ready.',
          category: 'Support',
          icon: Icons.psychology_outlined,
        ),
      ]);
    }

    // Concern-based fill-up
    if (results.length < 3 && concerns.contains('Low confidence')) {
      results.add(const Recommendation(
        title: 'Confidence Reset',
        description: 'Small steps to rebuild your sense of self.',
        category: 'Grow',
        icon: Icons.emoji_events_outlined,
      ));
    }
    if (results.length < 3 &&
        (concerns.contains('Stress') ||
            concerns.contains('Feeling overwhelmed'))) {
      results.add(const Recommendation(
        title: '2-Minute Grounding',
        description: 'Slow down and reconnect with the present moment.',
        category: 'Relax',
        icon: Icons.self_improvement_rounded,
      ));
    }
    if (results.length < 3 && concerns.contains('Anxiety')) {
      results.add(const Recommendation(
        title: 'Breathing Reset',
        description: 'A gentle breathing exercise for anxious moments.',
        category: 'Relax',
        icon: Icons.air_rounded,
      ));
    }
    if (results.length < 3 && concerns.contains('Loneliness')) {
      results.add(const Recommendation(
        title: 'Reconnect With Someone',
        description: 'Reach out to a trusted person when you feel ready.',
        category: 'Reconnect',
        icon: Icons.groups_outlined,
      ));
    }
    if (results.length < 3 && concerns.contains('Low mood')) {
      results.add(const Recommendation(
        title: 'Gentle Reflection',
        description: 'Write a few words about how you feel today.',
        category: 'Express',
        icon: Icons.edit_note_rounded,
      ));
    }
    if (results.length < 3 && concerns.contains('Difficulty sleeping')) {
      results.add(const Recommendation(
        title: 'Calm Music',
        description: 'Gentle sounds to help you wind down.',
        category: 'Relax',
        icon: Icons.music_note_outlined,
      ));
    }

    // Fallback
    if (results.isEmpty) {
      results.addAll([
        const Recommendation(
          title: 'Breathing',
          description: 'A simple breathing exercise to start your day.',
          category: 'Relax',
          icon: Icons.air_rounded,
        ),
        const Recommendation(
          title: 'Journaling',
          description: 'Write a few words about how you are feeling.',
          category: 'Express',
          icon: Icons.edit_note_rounded,
        ),
        const Recommendation(
          title: 'Gentle Walking',
          description: 'A short walk to reconnect with your body.',
          category: 'Move',
          icon: Icons.directions_walk_rounded,
        ),
      ]);
    }

    return results.take(3).toList();
  }

  // Legacy alias
  static List<Recommendation> recommendations(SurvivorProfile profile) =>
      detailedRecommendations(profile);

  // ── Support Options ───────────────────────────────────────────────────────────

  static List<SupportOption> supportOptions(SurvivorProfile profile) {
    switch (profile.primarySituation) {
      case PrimarySituation.workplace:
        return [
          const SupportOption(
            title: 'Professional Support',
            description: 'Speak with a counsellor at your own pace.',
            icon: Icons.psychology_outlined,
          ),
          const SupportOption(
            title: 'Workplace Resources',
            description: 'Understand your rights and available options.',
            icon: Icons.work_outline_rounded,
          ),
        ];
      case PrimarySituation.onlineDigital:
        return [
          const SupportOption(
            title: 'Digital Safety Resources',
            description: 'Guidance on protecting yourself online.',
            icon: Icons.security_outlined,
          ),
          const SupportOption(
            title: 'Professional Support',
            description: 'Speak with a counsellor when you are ready.',
            icon: Icons.psychology_outlined,
          ),
        ];
      case PrimarySituation.partnerHusband:
        return [
          const SupportOption(
            title: "Women's Support",
            description: 'Access women\'s support services.',
            icon: Icons.favorite_border_rounded,
          ),
          const SupportOption(
            title: 'Legal Assistance',
            description: 'Understand your legal options.',
            icon: Icons.gavel_rounded,
          ),
        ];
      case PrimarySituation.familyRelative:
        return [
          const SupportOption(
            title: 'Professional Support',
            description: 'Speak with a counsellor at your own pace.',
            icon: Icons.psychology_outlined,
          ),
          const SupportOption(
            title: "Women's Support",
            description: 'Access women\'s support services.',
            icon: Icons.favorite_border_rounded,
          ),
        ];
      case PrimarySituation.childhoodPast:
        return [
          const SupportOption(
            title: 'Professional Support',
            description: 'Speak with a counsellor at your own pace.',
            icon: Icons.psychology_outlined,
          ),
          const SupportOption(
            title: 'Peer Support',
            description: 'Connect with a peer supporter.',
            icon: Icons.groups_outlined,
          ),
        ];
      case PrimarySituation.multipleOngoing:
        return [
          const SupportOption(
            title: 'Safety Resources',
            description: 'Access safety information at your own pace.',
            icon: Icons.shield_outlined,
          ),
          const SupportOption(
            title: 'Professional Support',
            description: 'Speak with a counsellor when you are ready.',
            icon: Icons.psychology_outlined,
          ),
        ];
      default:
        return [
          const SupportOption(
            title: 'Professional Support',
            description: 'Speak with a counsellor at your own pace.',
            icon: Icons.psychology_outlined,
          ),
          const SupportOption(
            title: 'Peer Support',
            description: 'Connect with a peer supporter.',
            icon: Icons.groups_outlined,
          ),
        ];
    }
  }

  // Legacy alias
  static String primarySupportLabel(SurvivorProfile profile) {
    final opts = supportOptions(profile);
    return opts.isNotEmpty ? opts.first.title : 'General Recovery Support';
  }

  // ── Companion state ───────────────────────────────────────────────────────────

  static String companionState(CheckInMood? mood) {
    switch (mood) {
      case CheckInMood.good:
      case CheckInMood.okay:
        return 'waving';
      case CheckInMood.low:
      case CheckInMood.overwhelmed:
        return 'sitting';
      case CheckInMood.stressed:
      case CheckInMood.anxious:
        return 'sitting';
      default:
        return 'standing';
    }
  }
}
