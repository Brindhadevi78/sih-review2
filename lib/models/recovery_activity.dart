import 'package:flutter/material.dart';
import 'recovery_state.dart';

enum ActivityCategory { relax, express, move, reconnect, grow }

extension ActivityCategoryLabel on ActivityCategory {
  String get label {
    switch (this) {
      case ActivityCategory.relax:
        return 'Relax';
      case ActivityCategory.express:
        return 'Express';
      case ActivityCategory.move:
        return 'Move';
      case ActivityCategory.reconnect:
        return 'Reconnect';
      case ActivityCategory.grow:
        return 'Grow';
    }
  }

  IconData get icon {
    switch (this) {
      case ActivityCategory.relax:
        return Icons.self_improvement_rounded;
      case ActivityCategory.express:
        return Icons.edit_note_rounded;
      case ActivityCategory.move:
        return Icons.directions_walk_rounded;
      case ActivityCategory.reconnect:
        return Icons.groups_outlined;
      case ActivityCategory.grow:
        return Icons.emoji_events_outlined;
    }
  }

  Color get color {
    switch (this) {
      case ActivityCategory.relax:
        return const Color(0xFF7B6FA0);
      case ActivityCategory.express:
        return const Color(0xFFE8A598);
      case ActivityCategory.move:
        return const Color(0xFF81C784);
      case ActivityCategory.reconnect:
        return const Color(0xFF64B5F6);
      case ActivityCategory.grow:
        return const Color(0xFFFFB74D);
    }
  }
}

class RecoveryActivity {
  final String id;
  final String title;
  final ActivityCategory category;
  final String description;
  final String whyItHelps;
  final String duration;
  final IconData icon;
  final List<CheckInMood> suitableForMoods;
  final List<String> suitableForConcerns;
  final List<String> requiredPreferences;
  final List<String> steps;
  final bool isInformational;

  const RecoveryActivity({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.whyItHelps,
    required this.duration,
    required this.icon,
    this.suitableForMoods = const [],
    this.suitableForConcerns = const [],
    this.requiredPreferences = const [],
    required this.steps,
    this.isInformational = false,
  });
}

// ── Full Activity Library ─────────────────────────────────────────────────────

final List<RecoveryActivity> kActivityLibrary = [
  // RELAX
  RecoveryActivity(
    id: 'grounding_2min',
    title: '2-Minute Grounding',
    category: ActivityCategory.relax,
    description: 'A gentle exercise to reconnect with the present moment.',
    whyItHelps:
        'This activity is designed to give you a few quiet minutes to reconnect with the present moment. Grounding can help when feelings become overwhelming.',
    duration: '2 min',
    icon: Icons.self_improvement_rounded,
    suitableForMoods: [CheckInMood.stressed, CheckInMood.overwhelmed, CheckInMood.anxious],
    suitableForConcerns: ['Stress', 'Feeling overwhelmed', 'Anxiety'],
    steps: [
      'Find a comfortable position and take a slow breath.',
      'Notice five things you can see around you.',
      'Notice four things you can physically touch.',
      'Notice three things you can hear.',
      'Take another slow, gentle breath.',
      'You are here. You are safe in this moment.',
    ],
  ),
  RecoveryActivity(
    id: 'breathing_reset',
    title: 'Breathing Reset',
    category: ActivityCategory.relax,
    description: 'A simple breathing pattern to calm your nervous system.',
    whyItHelps:
        'Slow, intentional breathing can help ease anxious feelings and bring a sense of calm. This is a gentle tool you can use anywhere.',
    duration: '3 min',
    icon: Icons.air_rounded,
    suitableForMoods: [CheckInMood.anxious, CheckInMood.stressed, CheckInMood.overwhelmed],
    suitableForConcerns: ['Anxiety', 'Stress', 'Feeling overwhelmed'],
    steps: [
      'Breathe in slowly for 4 counts.',
      'Hold gently for 2 counts.',
      'Breathe out slowly for 6 counts.',
      'Pause for 2 counts.',
      'Repeat this cycle 4 times at your own pace.',
      'Notice how your body feels after each breath.',
    ],
  ),
  RecoveryActivity(
    id: 'calm_meditation',
    title: 'Calm Meditation',
    category: ActivityCategory.relax,
    description: 'A short guided moment of stillness and quiet.',
    whyItHelps:
        'Taking a few minutes of stillness can help you reconnect with yourself and create a small sense of peace in a busy day.',
    duration: '5 min',
    icon: Icons.spa_outlined,
    suitableForMoods: [CheckInMood.stressed, CheckInMood.low, CheckInMood.overwhelmed],
    suitableForConcerns: ['Stress', 'Low mood', 'Difficulty sleeping'],
    steps: [
      'Sit or lie down in a comfortable position.',
      'Close your eyes or soften your gaze.',
      'Take three slow, deep breaths.',
      'Let your thoughts pass like clouds — you don\'t need to hold onto them.',
      'Focus gently on the sensation of breathing.',
      'Stay here for as long as feels right.',
    ],
  ),
  RecoveryActivity(
    id: 'calm_music',
    title: 'Calm Music',
    category: ActivityCategory.relax,
    description: 'Take a few minutes to listen to something soothing.',
    whyItHelps:
        'Gentle music can create a calming space and help ease tension. This is a simple, low-effort well-being activity.',
    duration: '5–10 min',
    icon: Icons.music_note_outlined,
    suitableForMoods: [CheckInMood.low, CheckInMood.stressed, CheckInMood.overwhelmed],
    suitableForConcerns: ['Difficulty sleeping', 'Stress', 'Low mood'],
    steps: [
      'Find a comfortable spot where you won\'t be disturbed.',
      'Choose music that feels gentle and calming to you.',
      'Close your eyes if that feels comfortable.',
      'Let the music be your only focus for a few minutes.',
      'Notice how you feel when the music ends.',
    ],
  ),

  // EXPRESS
  RecoveryActivity(
    id: 'private_journaling',
    title: 'Private Journaling',
    category: ActivityCategory.express,
    description: 'Write freely — just for yourself, with no judgement.',
    whyItHelps:
        'Writing your thoughts privately can help you process feelings at your own pace. Nothing you write here is shared with anyone.',
    duration: '5–10 min',
    icon: Icons.book_outlined,
    suitableForMoods: [CheckInMood.low, CheckInMood.stressed, CheckInMood.anxious],
    suitableForConcerns: ['Low mood', 'Stress', 'Anxiety'],
    steps: [
      'Find a quiet moment and a comfortable place.',
      'Write whatever comes to mind — there is no right or wrong.',
      'You might start with: "Today I feel..."',
      'Write for as long as feels helpful.',
      'You don\'t need to re-read what you wrote.',
      'Close the journal when you\'re ready.',
    ],
  ),
  RecoveryActivity(
    id: 'voice_reflection',
    title: 'Voice Reflection',
    category: ActivityCategory.express,
    description: 'Speak your thoughts aloud — just for yourself.',
    whyItHelps:
        'Sometimes saying things out loud can help you process feelings in a different way. This is a private, personal activity.',
    duration: '3–5 min',
    icon: Icons.mic_none_rounded,
    suitableForMoods: [CheckInMood.low, CheckInMood.stressed],
    suitableForConcerns: ['Low mood', 'Stress'],
    steps: [
      'Find a private space where you feel comfortable.',
      'Take a breath and speak freely — no one is listening.',
      'You might say: "Right now I feel..."',
      'Let yourself speak without editing or judging.',
      'Finish when it feels right.',
    ],
  ),
  RecoveryActivity(
    id: 'draw_feelings',
    title: 'Draw Your Feelings',
    category: ActivityCategory.express,
    description: 'Express yourself through simple drawing or doodling.',
    whyItHelps:
        'Creative expression can help you process emotions that are hard to put into words. There is no skill required — this is just for you.',
    duration: '5–10 min',
    icon: Icons.brush_outlined,
    suitableForMoods: [CheckInMood.low, CheckInMood.anxious, CheckInMood.overwhelmed],
    suitableForConcerns: ['Low mood', 'Anxiety'],
    steps: [
      'Get any paper and something to draw with.',
      'Take a breath and let your hand move freely.',
      'Draw shapes, colours, or anything that comes to mind.',
      'There is no right or wrong — this is just expression.',
      'When you\'re done, notice how you feel.',
    ],
  ),
  RecoveryActivity(
    id: 'creative_writing',
    title: 'Creative Writing',
    category: ActivityCategory.express,
    description: 'Write a short story, poem, or anything creative.',
    whyItHelps:
        'Creative writing gives you a safe space to explore feelings through imagination. It can be a gentle way to process experiences.',
    duration: '10 min',
    icon: Icons.create_outlined,
    suitableForMoods: [CheckInMood.okay, CheckInMood.good, CheckInMood.low],
    suitableForConcerns: ['Low mood'],
    steps: [
      'Choose a simple prompt: "A place I feel safe is..."',
      'Write freely without worrying about grammar or structure.',
      'Let your imagination guide you.',
      'Write for as long as feels enjoyable.',
      'You can keep or discard what you write.',
    ],
  ),

  // MOVE
  RecoveryActivity(
    id: 'gentle_walk',
    title: 'Gentle Walk',
    category: ActivityCategory.move,
    description: 'A short, gentle walk to reconnect with your body.',
    whyItHelps:
        'Light movement can help shift your mood and give you a sense of gentle accomplishment. Even a few minutes outside can make a difference.',
    duration: '5–10 min',
    icon: Icons.directions_walk_rounded,
    suitableForMoods: [CheckInMood.low, CheckInMood.stressed, CheckInMood.okay],
    suitableForConcerns: ['Low mood', 'Stress', 'Feeling overwhelmed'],
    requiredPreferences: ['Physical movement'],
    steps: [
      'Put on comfortable shoes.',
      'Step outside or find a safe space to walk.',
      'Walk at whatever pace feels comfortable.',
      'Notice what you see, hear, and feel around you.',
      'Return when you\'re ready — even 5 minutes counts.',
    ],
  ),
  RecoveryActivity(
    id: 'stretch_breathe',
    title: 'Stretch & Breathe',
    category: ActivityCategory.move,
    description: 'Gentle stretches combined with slow breathing.',
    whyItHelps:
        'Gentle stretching can release physical tension that builds up when we\'re stressed or anxious. Combined with breathing, it can feel very calming.',
    duration: '5 min',
    icon: Icons.accessibility_new_rounded,
    suitableForMoods: [CheckInMood.stressed, CheckInMood.anxious, CheckInMood.overwhelmed],
    suitableForConcerns: ['Stress', 'Anxiety', 'Feeling overwhelmed'],
    requiredPreferences: ['Physical movement'],
    steps: [
      'Stand or sit comfortably.',
      'Slowly roll your shoulders back three times.',
      'Gently tilt your head to each side and hold for a breath.',
      'Reach your arms above your head and take a deep breath.',
      'Lower your arms slowly as you breathe out.',
      'Repeat as many times as feels good.',
    ],
  ),
  RecoveryActivity(
    id: 'light_movement',
    title: 'Light Movement',
    category: ActivityCategory.move,
    description: 'Simple, gentle movement at your own pace.',
    whyItHelps:
        'Any gentle movement can help reconnect you with your body and release tension. This is entirely at your own pace.',
    duration: '5 min',
    icon: Icons.fitness_center_outlined,
    suitableForMoods: [CheckInMood.low, CheckInMood.okay],
    suitableForConcerns: ['Low mood'],
    requiredPreferences: ['Physical movement'],
    steps: [
      'Find a comfortable space.',
      'Gently shake out your hands and arms.',
      'Roll your ankles and wrists slowly.',
      'Take a few slow steps in place.',
      'Move in whatever way feels natural and gentle.',
      'Stop whenever you\'re ready.',
    ],
  ),

  // RECONNECT
  RecoveryActivity(
    id: 'think_someone_trust',
    title: 'Think of Someone You Trust',
    category: ActivityCategory.reconnect,
    description: 'Bring to mind someone who makes you feel safe.',
    whyItHelps:
        'Thinking about a trusted person can bring a sense of warmth and connection, even without reaching out. This is a gentle, private activity.',
    duration: '3 min',
    icon: Icons.favorite_border_rounded,
    suitableForMoods: [CheckInMood.low, CheckInMood.anxious, CheckInMood.stressed],
    suitableForConcerns: ['Loneliness', 'Low mood'],
    steps: [
      'Close your eyes or soften your gaze.',
      'Bring to mind someone who has made you feel safe or cared for.',
      'It could be a friend, family member, or anyone you trust.',
      'Notice the warmth that comes with thinking of them.',
      'You don\'t need to contact them — just hold that feeling for a moment.',
      'Take a gentle breath and open your eyes when ready.',
    ],
    isInformational: true,
  ),
  RecoveryActivity(
    id: 'send_simple_message',
    title: 'Send a Simple Message',
    category: ActivityCategory.reconnect,
    description: 'Reach out to someone you trust with a simple message.',
    whyItHelps:
        'A small connection can ease feelings of isolation. You choose who to reach out to and what to say — there is no pressure.',
    duration: '5 min',
    icon: Icons.message_outlined,
    suitableForMoods: [CheckInMood.low, CheckInMood.okay],
    suitableForConcerns: ['Loneliness'],
    steps: [
      'Think of one person you feel comfortable with.',
      'Send a simple message — it can be as short as "Thinking of you."',
      'You don\'t need to explain how you\'re feeling.',
      'Notice how it feels to reach out.',
    ],
    isInformational: true,
  ),
  RecoveryActivity(
    id: 'gentle_social',
    title: 'Gentle Social Activity',
    category: ActivityCategory.reconnect,
    description: 'A low-pressure way to spend time with others.',
    whyItHelps:
        'Being around others — even quietly — can ease loneliness. This activity is about gentle presence, not performance.',
    duration: '15–30 min',
    icon: Icons.groups_outlined,
    suitableForMoods: [CheckInMood.okay, CheckInMood.good],
    suitableForConcerns: ['Loneliness'],
    steps: [
      'Choose a low-pressure social setting — a café, a park, or a friend\'s home.',
      'You don\'t need to talk much — just being present counts.',
      'Notice how it feels to be around others.',
      'Leave whenever you\'re ready.',
    ],
    isInformational: true,
  ),
  RecoveryActivity(
    id: 'peer_support_info',
    title: 'Peer Support Information',
    category: ActivityCategory.reconnect,
    description: 'Learn about peer support options available to you.',
    whyItHelps:
        'Connecting with someone who has had similar experiences can feel validating and less isolating. This activity provides information only.',
    duration: '5 min',
    icon: Icons.people_outline_rounded,
    suitableForMoods: [CheckInMood.low, CheckInMood.okay],
    suitableForConcerns: ['Loneliness', 'Low mood'],
    steps: [
      'Peer support connects you with trained individuals who have lived experience.',
      'You can choose to connect when you feel ready — there is no pressure.',
      'Peer support is confidential and voluntary.',
      'The Support tab in this app has more information when you\'re ready.',
    ],
    isInformational: true,
  ),

  // GROW
  RecoveryActivity(
    id: 'confidence_reset',
    title: 'Confidence Reset',
    category: ActivityCategory.grow,
    description: 'Small steps to reconnect with your strengths.',
    whyItHelps:
        'This activity gently invites you to notice your own strengths and abilities. It is not about achieving anything — just reconnecting with yourself.',
    duration: '5 min',
    icon: Icons.emoji_events_outlined,
    suitableForMoods: [CheckInMood.low, CheckInMood.stressed, CheckInMood.okay],
    suitableForConcerns: ['Low confidence', 'Low mood'],
    steps: [
      'Find a quiet moment.',
      'Think of one thing you have managed or handled recently — however small.',
      'Write it down or say it quietly to yourself.',
      'Notice that you did that. It counts.',
      'Think of one quality you have that helps you get through difficult times.',
      'Carry that with you today.',
    ],
  ),
  RecoveryActivity(
    id: 'small_wins',
    title: 'Small Wins',
    category: ActivityCategory.grow,
    description: 'Notice and celebrate the small things you\'ve done.',
    whyItHelps:
        'Recognising small wins builds a sense of progress and self-worth. Every step forward matters, no matter how small.',
    duration: '3 min',
    icon: Icons.star_outline_rounded,
    suitableForMoods: [CheckInMood.okay, CheckInMood.good, CheckInMood.low],
    suitableForConcerns: ['Low confidence', 'Low mood'],
    steps: [
      'Think about today or this week.',
      'Name three things you did — however small.',
      'Getting out of bed counts. Making a meal counts. Reading this counts.',
      'Write them down if you\'d like.',
      'Acknowledge yourself for each one.',
    ],
  ),
  RecoveryActivity(
    id: 'explore_hobby',
    title: 'Explore a Hobby',
    category: ActivityCategory.grow,
    description: 'Spend a few minutes on something you enjoy.',
    whyItHelps:
        'Engaging in something enjoyable — even briefly — can restore a sense of identity and pleasure that difficult times can take away.',
    duration: '10–20 min',
    icon: Icons.palette_outlined,
    suitableForMoods: [CheckInMood.okay, CheckInMood.good],
    suitableForConcerns: ['Low mood'],
    requiredPreferences: ['Creative activities'],
    steps: [
      'Choose something you enjoy or used to enjoy.',
      'Give yourself permission to do it just for fun.',
      'Don\'t worry about doing it well — just enjoy the process.',
      'Notice how you feel while doing it.',
    ],
  ),
  RecoveryActivity(
    id: 'learn_something_new',
    title: 'Learn Something New',
    category: ActivityCategory.grow,
    description: 'Explore a topic that interests you.',
    whyItHelps:
        'Learning something new can spark curiosity and a sense of forward movement. It\'s a gentle way to invest in yourself.',
    duration: '10 min',
    icon: Icons.lightbulb_outline_rounded,
    suitableForMoods: [CheckInMood.okay, CheckInMood.good],
    suitableForConcerns: [],
    requiredPreferences: ['Learning and growth'],
    steps: [
      'Choose a topic that interests you — anything at all.',
      'Read an article, watch a short video, or listen to a podcast.',
      'Notice what you find interesting.',
      'You don\'t need to remember everything — just enjoy exploring.',
    ],
  ),
  RecoveryActivity(
    id: 'skill_building',
    title: 'Skill Building',
    category: ActivityCategory.grow,
    description: 'Practice a skill you\'d like to develop.',
    whyItHelps:
        'Building a skill — even in small steps — creates a sense of progress and capability. This is about your growth, at your pace.',
    duration: '15 min',
    icon: Icons.trending_up_rounded,
    suitableForMoods: [CheckInMood.okay, CheckInMood.good],
    suitableForConcerns: ['Low confidence'],
    requiredPreferences: ['Learning and growth'],
    steps: [
      'Choose one skill you\'d like to develop.',
      'Break it into the smallest possible step.',
      'Spend 15 minutes on just that one step.',
      'Notice what you learned or practised.',
      'Acknowledge yourself for showing up.',
    ],
  ),
  // Special informational activities
  RecoveryActivity(
    id: 'digital_wellbeing_pause',
    title: 'Digital Wellbeing Pause',
    category: ActivityCategory.relax,
    description: 'Take a mindful break from screens and digital spaces.',
    whyItHelps:
        'A short break from digital spaces can reduce stress and help you feel more grounded. This is especially helpful if online experiences have been difficult.',
    duration: '5 min',
    icon: Icons.phone_android_outlined,
    suitableForMoods: [CheckInMood.stressed, CheckInMood.anxious, CheckInMood.overwhelmed],
    suitableForConcerns: ['Stress', 'Anxiety'],
    steps: [
      'Put your phone or device face-down or in another room.',
      'Take three slow breaths.',
      'Notice how it feels to be away from the screen.',
      'Spend 5 minutes doing something offline — stretching, looking out a window, or just sitting.',
      'Return to your device when you feel ready.',
    ],
  ),
  RecoveryActivity(
    id: 'grounding_safety_pause',
    title: 'Grounding & Safety Pause',
    category: ActivityCategory.relax,
    description: 'A gentle pause to reconnect with your sense of safety.',
    whyItHelps:
        'This activity gently invites you to notice that you are safe in this moment. It is designed for times when you feel unsettled or unsafe.',
    duration: '3 min',
    icon: Icons.shield_outlined,
    suitableForMoods: [CheckInMood.anxious, CheckInMood.stressed, CheckInMood.overwhelmed],
    suitableForConcerns: ['Anxiety', 'Stress', 'Feeling overwhelmed'],
    steps: [
      'Find a place where you feel as safe as possible right now.',
      'Take a slow breath and notice your surroundings.',
      'Name three things you can see that are calm or neutral.',
      'Place your feet flat on the floor and feel the ground beneath you.',
      'Remind yourself: "I am here. I am safe in this moment."',
      'Take another slow breath.',
    ],
  ),
  RecoveryActivity(
    id: 'gentle_reflection',
    title: 'Gentle Reflection',
    category: ActivityCategory.express,
    description: 'A quiet moment to acknowledge how you\'re feeling.',
    whyItHelps:
        'Gently acknowledging your feelings — without judgement — can ease their intensity. This is a compassionate activity for difficult days.',
    duration: '5 min',
    icon: Icons.edit_note_rounded,
    suitableForMoods: [CheckInMood.low, CheckInMood.overwhelmed, CheckInMood.stressed],
    suitableForConcerns: ['Low mood', 'Feeling overwhelmed'],
    steps: [
      'Find a quiet moment.',
      'Ask yourself: "How am I really feeling right now?"',
      'Name the feeling without judging it.',
      'Say to yourself: "It\'s okay to feel this way."',
      'Take a gentle breath.',
      'You don\'t need to fix anything right now.',
    ],
  ),
  RecoveryActivity(
    id: 'workplace_resources',
    title: 'Workplace Resources',
    category: ActivityCategory.grow,
    description: 'Information about workplace rights and support options.',
    whyItHelps:
        'Understanding your rights and available options can help you feel more informed and empowered. This activity provides information only.',
    duration: '5 min',
    icon: Icons.work_outline_rounded,
    suitableForMoods: [],
    suitableForConcerns: ['Low confidence'],
    steps: [
      'Workplace support resources are available to help you understand your rights.',
      'You can explore these at your own pace — there is no pressure to act.',
      'The Support tab in this app has more information when you\'re ready.',
      'You are not alone in navigating this.',
    ],
    isInformational: true,
  ),
  RecoveryActivity(
    id: 'digital_safety_resources',
    title: 'Digital Safety Resources',
    category: ActivityCategory.grow,
    description: 'Information about protecting yourself online.',
    whyItHelps:
        'Understanding digital safety options can help you feel more in control of your online spaces. This activity provides information only.',
    duration: '5 min',
    icon: Icons.security_outlined,
    suitableForMoods: [],
    suitableForConcerns: [],
    steps: [
      'Digital safety resources can help you review your online privacy settings.',
      'You can explore these at your own pace.',
      'The Support tab in this app has more information when you\'re ready.',
      'Your safety online matters.',
    ],
    isInformational: true,
  ),
  RecoveryActivity(
    id: 'celebrate_small_win',
    title: 'Celebrate a Small Win',
    category: ActivityCategory.grow,
    description: 'Take a moment to acknowledge something you\'ve done well.',
    whyItHelps:
        'Celebrating small wins — even privately — builds a sense of progress and self-worth. You deserve to acknowledge your efforts.',
    duration: '3 min',
    icon: Icons.celebration_outlined,
    suitableForMoods: [CheckInMood.good, CheckInMood.okay],
    suitableForConcerns: [],
    steps: [
      'Think of one thing you\'ve done recently that took effort.',
      'It doesn\'t need to be big — showing up counts.',
      'Say to yourself: "I did that. That matters."',
      'Take a moment to feel good about it.',
    ],
  ),
  RecoveryActivity(
    id: 'take_gentle_breath',
    title: 'Take a Gentle Breath',
    category: ActivityCategory.relax,
    description: 'Start with one small moment of calm.',
    whyItHelps:
        'A single gentle breath is always available to you. It\'s a small, simple act of self-care that requires nothing except a moment of your time.',
    duration: '1 min',
    icon: Icons.air_rounded,
    suitableForMoods: [],
    suitableForConcerns: [],
    steps: [
      'Wherever you are, take a slow breath in.',
      'Hold it gently for a moment.',
      'Let it out slowly.',
      'Notice how you feel.',
      'That\'s it. You did something kind for yourself.',
    ],
  ),
];
