import 'package:flutter/material.dart';
import '../../app/app.dart';
import '../../app/routes/app_routes.dart';
import '../../models/user_role.dart';

class SupporterSubRoleScreen extends StatelessWidget {
  const SupporterSubRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final session = SessionScope.of(context);

    final subRoles = [
      _SubRoleCard(
        icon: Icons.psychology_outlined,
        title: 'Psychologist / Counsellor',
        description: 'Provide professional emotional and recovery support.',
        onTap: () {
          session.setSupporterSubRole(
              SupporterSubRole.psychologistCounsellor);
          Navigator.pushReplacementNamed(context, AppRoutes.supporter);
        },
      ),
      _SubRoleCard(
        icon: Icons.groups_outlined,
        title: 'Peer Supporter',
        description:
            'Provide voluntary peer-based encouragement and support.',
        onTap: () {
          session.setSupporterSubRole(SupporterSubRole.peerSupporter);
          Navigator.pushReplacementNamed(context, AppRoutes.supporter);
        },
      ),
      _SubRoleCard(
        icon: Icons.gavel_rounded,
        title: 'Legal Advocate',
        description:
            'Help users access appropriate legal guidance and resources.',
        onTap: () {
          session.setSupporterSubRole(SupporterSubRole.legalAdvocate);
          Navigator.pushReplacementNamed(context, AppRoutes.supporter);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
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
                    'What is your support role?',
                    style: theme.textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This helps personalise the tools available in your workspace.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurface.withAlpha(150)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  ...subRoles.map((card) => Padding(
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

class _SubRoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _SubRoleCard({
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
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: cs.secondary, size: 28),
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
