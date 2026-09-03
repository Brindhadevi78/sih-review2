import 'package:flutter/material.dart';
import '../../app/app.dart';
import '../../app/routes/app_routes.dart';
import '../../models/user_role.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final session = SessionScope.of(context);

    final roles = [
      _RoleCard(
        icon: Icons.person_outline_rounded,
        title: 'Survivor',
        description:
            'A private space for reflection, recovery, and support at your own pace.',
        onTap: () {
          session.setRole(UserRole.survivor);
          // Init a fresh profile so onboarding gate triggers.
          SurvivorProfileScope.of(context).initProfile(
            userId: session.email,
            name: session.name,
            email: session.email,
          );
          Navigator.pushReplacementNamed(context, AppRoutes.survivor);
        },
      ),
      _RoleCard(
        icon: Icons.volunteer_activism_outlined,
        title: 'Supporter',
        description:
            'Provide support through your approved role while respecting survivor choices and consent.',
        onTap: () {
          session.setRole(UserRole.supporter);
          Navigator.pushReplacementNamed(context, AppRoutes.supporterSubRole);
        },
      ),
      _RoleCard(
        icon: Icons.admin_panel_settings_outlined,
        title: 'Administrator',
        description:
            'Access anonymous platform insights and manage support operations.',
        onTap: () {
          session.setRole(UserRole.admin);
          Navigator.pushReplacementNamed(context, AppRoutes.admin);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, AppRoutes.login),
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'How would you like to continue?',
                    style: theme.textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose the space that matches your role.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurface.withAlpha(150)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  ...roles.map((card) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: card,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: cs.primary.withAlpha(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: cs.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withAlpha(160), height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: cs.primary),
            ],
          ),
        ),
      ),
    );
  }
}
