import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'constants/app_constants.dart';
import '../providers/session_provider.dart';
import '../providers/survivor_profile_provider.dart';
import '../providers/recovery_state_provider.dart';
import '../providers/reflection_provider.dart';
import '../providers/activity_history_provider.dart';
import '../providers/support_history_provider.dart';
import '../providers/consent_provider.dart';
import '../providers/platform_analytics_provider.dart';
import '../providers/companion_provider.dart';
import '../providers/voice_reflection_provider.dart';

class NirbhayaApp extends StatefulWidget {
  const NirbhayaApp({super.key});

  @override
  State<NirbhayaApp> createState() => _NirbhayaAppState();
}

class _NirbhayaAppState extends State<NirbhayaApp> {
  final SessionProvider _session = SessionProvider();
  final SurvivorProfileProvider _survivorProfile = SurvivorProfileProvider();
  final RecoveryStateProvider _recoveryState = RecoveryStateProvider();
  final ReflectionProvider _reflections = ReflectionProvider();
  final ActivityHistoryProvider _activityHistory = ActivityHistoryProvider();
  final SupportHistoryProvider _supportHistory = SupportHistoryProvider();
  final ConsentProvider _consent = ConsentProvider();
  final PlatformAnalyticsProvider _platformAnalytics = PlatformAnalyticsProvider();
  final CompanionProvider _companion = CompanionProvider();
  final VoiceReflectionProvider _voiceReflection = VoiceReflectionProvider();

  @override
  void dispose() {
    _session.dispose();
    _survivorProfile.dispose();
    _recoveryState.dispose();
    _reflections.dispose();
    _activityHistory.dispose();
    _supportHistory.dispose();
    _consent.dispose();
    _platformAnalytics.dispose();
    _companion.dispose();
    _voiceReflection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _session,
      builder: (context, _) => SessionScope(
        session: _session,
        child: SurvivorProfileScope(
          provider: _survivorProfile,
          child: RecoveryStateScope(
            provider: _recoveryState,
            child: ReflectionScope(
              provider: _reflections,
              child: ActivityHistoryScope(
                provider: _activityHistory,
                child: SupportHistoryScope(
                  provider: _supportHistory,
                  child: ConsentScope(
                    provider: _consent,
                    child: PlatformAnalyticsScope(
                      provider: _platformAnalytics,
                      child: CompanionScope(
                        provider: _companion,
                        child: VoiceReflectionScope(
                          provider: _voiceReflection,
                          child: MaterialApp(
                            title: AppConstants.appName,
                            debugShowCheckedModeBanner: false,
                            theme: AppTheme.light,
                            initialRoute: AppRoutes.login,
                            routes: AppRouter.routes,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── SessionScope ──────────────────────────────────────────────────────────────

class SessionScope extends InheritedNotifier<SessionProvider> {
  const SessionScope({
    super.key,
    required SessionProvider session,
    required super.child,
  }) : super(notifier: session);

  static SessionProvider of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SessionScope>();
    assert(scope != null, 'No SessionScope found in context');
    return scope!.notifier!;
  }
}

// ── SurvivorProfileScope ──────────────────────────────────────────────────────

class SurvivorProfileScope extends InheritedNotifier<SurvivorProfileProvider> {
  const SurvivorProfileScope({
    super.key,
    required SurvivorProfileProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static SurvivorProfileProvider of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<SurvivorProfileScope>();
    assert(scope != null, 'No SurvivorProfileScope found in context');
    return scope!.notifier!;
  }
}

// ── RecoveryStateScope ────────────────────────────────────────────────────────

class RecoveryStateScope extends InheritedNotifier<RecoveryStateProvider> {
  const RecoveryStateScope({
    super.key,
    required RecoveryStateProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static RecoveryStateProvider of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<RecoveryStateScope>();
    assert(scope != null, 'No RecoveryStateScope found in context');
    return scope!.notifier!;
  }
}

// ── ReflectionScope ───────────────────────────────────────────────────────────

class ReflectionScope extends InheritedNotifier<ReflectionProvider> {
  const ReflectionScope({
    super.key,
    required ReflectionProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static ReflectionProvider of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ReflectionScope>();
    assert(scope != null, 'No ReflectionScope found in context');
    return scope!.notifier!;
  }
}

// ── ActivityHistoryScope ──────────────────────────────────────────────────────

class ActivityHistoryScope extends InheritedNotifier<ActivityHistoryProvider> {
  const ActivityHistoryScope({
    super.key,
    required ActivityHistoryProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static ActivityHistoryProvider of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ActivityHistoryScope>();
    assert(scope != null, 'No ActivityHistoryScope found in context');
    return scope!.notifier!;
  }
}

// ── SupportHistoryScope ───────────────────────────────────────────────────────

class SupportHistoryScope extends InheritedNotifier<SupportHistoryProvider> {
  const SupportHistoryScope({
    super.key,
    required SupportHistoryProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static SupportHistoryProvider of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<SupportHistoryScope>();
    assert(scope != null, 'No SupportHistoryScope found in context');
    return scope!.notifier!;
  }
}

// ── ConsentScope ──────────────────────────────────────────────────────────────

class ConsentScope extends InheritedNotifier<ConsentProvider> {
  const ConsentScope({
    super.key,
    required ConsentProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static ConsentProvider of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ConsentScope>();
    assert(scope != null, 'No ConsentScope found in context');
    return scope!.notifier!;
  }
}

// ── PlatformAnalyticsScope ────────────────────────────────────────────────────

class PlatformAnalyticsScope
    extends InheritedNotifier<PlatformAnalyticsProvider> {
  const PlatformAnalyticsScope({
    super.key,
    required PlatformAnalyticsProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static PlatformAnalyticsProvider of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<PlatformAnalyticsScope>();
    assert(scope != null, 'No PlatformAnalyticsScope found in context');
    return scope!.notifier!;
  }
}

// ── CompanionScope ────────────────────────────────────────────────────────────

class CompanionScope extends InheritedNotifier<CompanionProvider> {
  const CompanionScope({
    super.key,
    required CompanionProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static CompanionProvider of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<CompanionScope>();
    assert(scope != null, 'No CompanionScope found in context');
    return scope!.notifier!;
  }
}

// ── VoiceReflectionScope ──────────────────────────────────────────────────────

class VoiceReflectionScope
    extends InheritedNotifier<VoiceReflectionProvider> {
  const VoiceReflectionScope({
    super.key,
    required VoiceReflectionProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static VoiceReflectionProvider of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<VoiceReflectionScope>();
    assert(scope != null, 'No VoiceReflectionScope found in context');
    return scope!.notifier!;
  }
}
