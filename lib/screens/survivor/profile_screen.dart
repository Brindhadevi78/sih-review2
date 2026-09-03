import 'package:flutter/material.dart';
import '../../app/app.dart';
import '../../app/routes/app_routes.dart';

class SurvivorProfileScreen extends StatelessWidget {
  const SurvivorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final session = SessionScope.of(context);
    final profileProvider = SurvivorProfileScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Avatar
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person_rounded,
                        size: 36, color: cs.primary),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    session.name.isNotEmpty ? session.name : 'Survivor',
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                Center(
                  child: Text(
                    session.email,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurface.withAlpha(150)),
                  ),
                ),
                const SizedBox(height: 32),
                _SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  label: 'Privacy Center',
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.privacyCenter),
                ),
                _SettingsTile(
                  icon: Icons.psychology_outlined,
                  label: 'AI Consent Settings',
                  subtitle: profileProvider.profile?.aiAnalysisConsent == true
                      ? 'AI analysis enabled'
                      : 'AI analysis not enabled',
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.privacyCenter),
                ),
                _SettingsTile(
                  icon: Icons.tune_rounded,
                  label: 'Update Preferences',
                  subtitle: 'Coming in a future version',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Update Preferences — coming in a future version.'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    ReflectionScope.of(context).clearReflections();
                    RecoveryStateScope.of(context).clear();
                    ActivityHistoryScope.of(context).clearHistory();
                    SupportHistoryScope.of(context).clear();
                    VoiceReflectionScope.of(context).clearAll();
                    ConsentScope.of(context).clear();
                    CompanionScope.of(context).reset();
                    profileProvider.clear();
                    session.clear();
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.login);
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: cs.primary),
      title: Text(label),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
