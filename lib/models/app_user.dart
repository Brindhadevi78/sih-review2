import 'user_role.dart';

class AppUser {
  final String id;
  final String name;
  final UserRole role;
  final SupporterSubRole? supporterSubRole;

  const AppUser({
    required this.id,
    required this.name,
    required this.role,
    this.supporterSubRole,
  });
}
