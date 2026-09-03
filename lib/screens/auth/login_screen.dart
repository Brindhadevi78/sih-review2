import 'package:flutter/material.dart';
import '../../app/app.dart';
import '../../app/routes/app_routes.dart';
import '../../models/user_role.dart';
import '../../models/survivor_profile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _loading = false);
    SessionScope.of(context).setSession(
      name: _emailCtrl.text.split('@').first,
      email: _emailCtrl.text.trim(),
    );
    Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
  }

  void _showDemoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _DemoSheet(
        onSelect: (role, subRole) {
          Navigator.pop(context);
          final session = SessionScope.of(context);
          final profileProvider = SurvivorProfileScope.of(context);
          session.setSession(name: 'Demo User', email: 'demo@nirbhaya.app');
          session.setRole(role);
          if (subRole != null) session.setSupporterSubRole(subRole);
          if (role == UserRole.survivor) {
            // Demo survivor: load a completed profile so onboarding is skipped.
            profileProvider.loadCompletedProfile(
              SurvivorProfile.defaultFor(
                userId: 'demo@nirbhaya.app',
                name: 'Demo User',
                email: 'demo@nirbhaya.app',
              ),
            );
            Navigator.pushReplacementNamed(context, AppRoutes.survivor);
          } else if (role == UserRole.admin) {
            Navigator.pushReplacementNamed(context, AppRoutes.admin);
          } else {
            if (subRole != null) {
              Navigator.pushReplacementNamed(context, AppRoutes.supporter);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.supporterSubRole);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Brand ──
                  Icon(Icons.favorite_rounded,
                      size: 48, color: cs.primary),
                  const SizedBox(height: 12),
                  Text(
                    'NIRBHAYA',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your recovery. Your choices. Your pace.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: cs.onSurface.withAlpha(180),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'A private space to reflect, recover, and choose the support that feels right for you.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withAlpha(140),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // ── Form ──
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Email address',
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(v.trim())) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _login(),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon:
                                const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (v.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        // Remember me + Forgot password
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (v) =>
                                  setState(() => _rememberMe = v ?? false),
                              visualDensity: VisualDensity.compact,
                            ),
                            Text('Remember me',
                                style: theme.textTheme.bodyMedium),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Forgot password?'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Login button
                        ElevatedButton(
                          onPressed: _loading ? null : _login,
                          child: _loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white),
                                )
                              : const Text('Continue'),
                        ),
                        const SizedBox(height: 20),

                        // Register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('New here?',
                                style: theme.textTheme.bodyMedium),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, AppRoutes.register),
                              child: const Text('Create an account'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Quick Access
                  OutlinedButton.icon(
                    onPressed: _showDemoSheet,
                    icon: const Icon(Icons.play_circle_outline_rounded),
                    label: const Text('Quick Access'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore all roles instantly',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withAlpha(100),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Demo Bottom Sheet ──────────────────────────────────────────────────────

class _DemoSheet extends StatelessWidget {
  final void Function(UserRole role, SupporterSubRole? subRole) onSelect;

  const _DemoSheet({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = [
      _DemoItem('Survivor', Icons.person_outline_rounded, UserRole.survivor,
          null),
      _DemoItem('Psychologist / Counsellor', Icons.psychology_outlined,
          UserRole.supporter, SupporterSubRole.psychologistCounsellor),
      _DemoItem('Peer Supporter', Icons.groups_outlined, UserRole.supporter,
          SupporterSubRole.peerSupporter),
      _DemoItem('Legal Advocate', Icons.gavel_rounded, UserRole.supporter,
          SupporterSubRole.legalAdvocate),
      _DemoItem(
          'Administrator', Icons.admin_panel_settings_outlined, UserRole.admin, null),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withAlpha(40),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Quick Access',
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('Jump directly into any role',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(140)),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ...items.map((item) => _DemoTile(item: item, onSelect: onSelect)),
        ],
      ),
    );
  }
}

class _DemoItem {
  final String label;
  final IconData icon;
  final UserRole role;
  final SupporterSubRole? subRole;
  const _DemoItem(this.label, this.icon, this.role, this.subRole);
}

class _DemoTile extends StatelessWidget {
  final _DemoItem item;
  final void Function(UserRole, SupporterSubRole?) onSelect;

  const _DemoTile({required this.item, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => onSelect(item.role, item.subRole),
        leading: CircleAvatar(
          backgroundColor: cs.primaryContainer,
          child: Icon(item.icon, color: cs.primary, size: 22),
        ),
        title: Text(item.label),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: cs.primary.withAlpha(30)),
        ),
        tileColor: cs.surface,
      ),
    );
  }
}
