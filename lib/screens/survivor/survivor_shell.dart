import 'package:flutter/material.dart';
import '../../app/app.dart';
import '../../app/routes/app_routes.dart';
import 'survivor_screen.dart';
import 'reflect/reflect_landing.dart';
import 'tabs/recover_screen.dart';
import 'tabs/journey_screen.dart';
import 'tabs/support_tab_screen.dart';

class SurvivorShell extends StatefulWidget {
  const SurvivorShell({super.key});

  @override
  State<SurvivorShell> createState() => _SurvivorShellState();
}

class _SurvivorShellState extends State<SurvivorShell> {
  int _currentIndex = 0;

  static const _tabs = [
    _TabItem(icon: Icons.home_rounded, label: 'Home'),
    _TabItem(icon: Icons.edit_note_rounded, label: 'Reflect'),
    _TabItem(icon: Icons.self_improvement_rounded, label: 'Recover'),
    _TabItem(icon: Icons.timeline_rounded, label: 'Journey'),
    _TabItem(icon: Icons.volunteer_activism_outlined, label: 'Support'),
  ];

  void _switchToHome() => setState(() => _currentIndex = 0);

  Widget _body() {
    switch (_currentIndex) {
      case 0:
        return SurvivorScreen(onSwitchTab: (i) => setState(() => _currentIndex = i));
      case 1:
        return ReflectLanding(onGoHome: _switchToHome);
      case 2:
        return const RecoverScreen();
      case 3:
        return const JourneyScreen();
      case 4:
        return const SupportTabScreen();
      default:
        return SurvivorScreen(onSwitchTab: (i) => setState(() => _currentIndex = i));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final session = SessionScope.of(context);
    final profileProvider = SurvivorProfileScope.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _currentIndex == 0 ? 'NIRBHAYA' : _tabs[_currentIndex].label,
          style: TextStyle(
            color: cs.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: 'Profile',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.survivorProfile),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign out',
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
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: SafeArea(child: _body()),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: cs.surface,
        indicatorColor: cs.primaryContainer,
        destinations: _tabs
            .map((t) => NavigationDestination(
                  icon: Icon(t.icon),
                  label: t.label,
                ))
            .toList(),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  const _TabItem({required this.icon, required this.label});
}
