import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/role_selection_screen.dart';
import '../../screens/survivor/onboarding/survivor_onboarding_flow.dart';
import '../../screens/survivor/survivor_shell.dart';
import '../../screens/survivor/profile_screen.dart';
import '../../screens/survivor/companion_screen.dart';
import '../../screens/supporter/supporter_subrole_screen.dart';
import '../../screens/supporter/supporter_screen.dart';
import '../../screens/admin/admin_screen.dart';
import '../../screens/common/privacy_center_screen.dart';

class AppRouter {
  AppRouter._();

  static Map<String, WidgetBuilder> get routes => {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.roleSelection: (_) => const RoleSelectionScreen(),
        AppRoutes.survivorOnboarding: (_) => const SurvivorOnboardingFlow(),
        AppRoutes.survivor: (_) => const SurvivorShell(),
        AppRoutes.survivorProfile: (_) => const SurvivorProfileScreen(),
        AppRoutes.companion: (_) => const CompanionScreen(),
        AppRoutes.privacyCenter: (_) => const PrivacyCenterScreen(),
        AppRoutes.supporterSubRole: (_) => const SupporterSubRoleScreen(),
        AppRoutes.supporter: (_) => const SupporterScreen(),
        AppRoutes.admin: (_) => const AdminScreen(),
      };
}
