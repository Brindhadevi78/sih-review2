import 'package:flutter/material.dart';
import '../../app/app.dart';
import '../../models/companion_preferences.dart';
import '../../providers/companion_provider.dart';

class CompanionScreen extends StatefulWidget {
  const CompanionScreen({super.key});

  @override
  State<CompanionScreen> createState() => _CompanionScreenState();
}

class _CompanionScreenState extends State<CompanionScreen> {
  late CompanionPreferences _draft;
  bool _saved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft = CompanionScope.of(context).preferences;
  }

  void _save() {
    CompanionScope.of(context).updatePreferences(_draft);
    setState(() => _saved = true);
    Future.delayed(const Duration(seconds: 2),
        () { if (mounted) setState(() => _saved = false); });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final mood = RecoveryStateScope.of(context).state.mood;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Companion')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Live preview
                  _CompanionPreview(
                    prefs: _draft,
                    mood: mood,
                    action: CompanionScope.of(context).action,
                    theme: theme,
                    cs: cs,
                  ),
                  const SizedBox(height: 24),

                  if (_saved)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withAlpha(120),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(children: [
                        Icon(Icons.check_circle_outline, color: cs.primary, size: 18),
                        const SizedBox(width: 8),
                        Text('Your companion has been updated.',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: cs.primary)),
                      ]),
                    ),

                  // Character
                  _OptionSection<CompanionCharacter>(
                    title: 'Character',
                    values: CompanionCharacter.values,
                    selected: _draft.character,
                    label: (v) => v.label,
                    onSelect: (v) => setState(() => _draft = _draft.copyWith(character: v)),
                    cs: cs, theme: theme,
                  ),
                  const SizedBox(height: 16),

                  // Outfit
                  _OptionSection<CompanionOutfit>(
                    title: 'Outfit',
                    values: CompanionOutfit.values,
                    selected: _draft.outfit,
                    label: (v) => v.label,
                    onSelect: (v) => setState(() => _draft = _draft.copyWith(outfit: v)),
                    cs: cs, theme: theme,
                  ),
                  const SizedBox(height: 16),

                  // Accessory
                  _OptionSection<CompanionAccessory>(
                    title: 'Accessory',
                    values: CompanionAccessory.values,
                    selected: _draft.accessory,
                    label: (v) => v.label,
                    onSelect: (v) => setState(() => _draft = _draft.copyWith(accessory: v)),
                    cs: cs, theme: theme,
                  ),
                  const SizedBox(height: 16),

                  // Background
                  _OptionSection<CompanionBackground>(
                    title: 'Background',
                    values: CompanionBackground.values,
                    selected: _draft.background,
                    label: (v) => v.label,
                    onSelect: (v) => setState(() => _draft = _draft.copyWith(background: v)),
                    cs: cs, theme: theme,
                  ),
                  const SizedBox(height: 16),

                  // Personality
                  _OptionSection<CompanionPersonality>(
                    title: 'Personality',
                    values: CompanionPersonality.values,
                    selected: _draft.personality,
                    label: (v) => v.label,
                    onSelect: (v) => setState(() => _draft = _draft.copyWith(personality: v)),
                    cs: cs, theme: theme,
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Save'),
                  ),
                  const SizedBox(height: 24),

                  // About companion
                  _AboutCompanionCard(theme: theme, cs: cs),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Live Preview ──────────────────────────────────────────────────────────────

class _CompanionPreview extends StatelessWidget {
  final CompanionPreferences prefs;
  final dynamic mood;
  final CompanionAction action;
  final ThemeData theme;
  final ColorScheme cs;

  const _CompanionPreview({
    required this.prefs,
    required this.mood,
    required this.action,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: prefs.background.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.primary.withAlpha(20)),
      ),
      child: Center(
        child: CompanionAvatar(
          prefs: prefs,
          action: action,
          size: 110,
          cs: cs,
        ),
      ),
    );
  }
}

// ── Option Section ────────────────────────────────────────────────────────────

class _OptionSection<T> extends StatelessWidget {
  final String title;
  final List<T> values;
  final T selected;
  final String Function(T) label;
  final void Function(T) onSelect;
  final ColorScheme cs;
  final ThemeData theme;

  const _OptionSection({
    required this.title,
    required this.values,
    required this.selected,
    required this.label,
    required this.onSelect,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values.map((v) {
            final isSelected = v == selected;
            return GestureDetector(
              onTap: () => onSelect(v),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? cs.primaryContainer : cs.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? cs.primary : cs.primary.withAlpha(40),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  label(v),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected ? cs.primary : cs.onSurface,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── About Companion Card ──────────────────────────────────────────────────────

class _AboutCompanionCard extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme cs;
  const _AboutCompanionCard({required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    const points = [
      'Your companion is a supportive prototype feature.',
      'It is not a therapist.',
      'It does not diagnose.',
      'It does not contact anyone.',
      'It does not report anything automatically.',
      'You control what you interact with.',
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(60),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.primary.withAlpha(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.info_outline_rounded, size: 18, color: cs.primary),
            const SizedBox(width: 8),
            Text('About your companion',
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: cs.primary)),
          ]),
          const SizedBox(height: 10),
          ...points.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 6, color: cs.primary.withAlpha(160)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(p,
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: cs.onSurface.withAlpha(160),
                                height: 1.4))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── Companion Avatar (shared widget) ─────────────────────────────────────────

class CompanionAvatar extends StatefulWidget {
  final CompanionPreferences prefs;
  final CompanionAction action;
  final double size;
  final ColorScheme cs;

  const CompanionAvatar({
    super.key,
    required this.prefs,
    required this.action,
    required this.size,
    required this.cs,
  });

  @override
  State<CompanionAvatar> createState() => _CompanionAvatarState();
}

class _CompanionAvatarState extends State<CompanionAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  IconData get _icon {
    switch (widget.action) {
      case CompanionAction.waving:
        return Icons.waving_hand_rounded;
      case CompanionAction.celebrating:
        return Icons.celebration_rounded;
      case CompanionAction.breathing:
      case CompanionAction.resting:
        return Icons.self_improvement_rounded;
      case CompanionAction.thinking:
        return Icons.lightbulb_outline_rounded;
      default:
        return _characterIcon;
    }
  }

  IconData get _characterIcon {
    switch (widget.prefs.character) {
      case CompanionCharacter.friendly:
        return Icons.sentiment_satisfied_alt_rounded;
      case CompanionCharacter.calm:
        return Icons.self_improvement_rounded;
      case CompanionCharacter.playful:
        return Icons.mood_rounded;
    }
  }

  Color get _bgColor {
    switch (widget.prefs.outfit) {
      case CompanionOutfit.casual:
        return widget.cs.secondaryContainer;
      case CompanionOutfit.cozy:
        return widget.cs.primaryContainer;
      case CompanionOutfit.simple:
        return widget.cs.surfaceContainerHighest;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(_icon,
                size: widget.size * 0.5, color: widget.cs.primary),
          ),
          // Accessory overlay
          if (widget.prefs.accessory != CompanionAccessory.none)
            Positioned(
              top: widget.size * 0.05,
              right: widget.size * 0.05,
              child: Container(
                width: widget.size * 0.28,
                height: widget.size * 0.28,
                decoration: BoxDecoration(
                  color: widget.cs.primary.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _accessoryIcon,
                  size: widget.size * 0.16,
                  color: widget.cs.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData get _accessoryIcon {
    switch (widget.prefs.accessory) {
      case CompanionAccessory.glasses:
        return Icons.remove_red_eye_outlined;
      case CompanionAccessory.headphones:
        return Icons.headphones_rounded;
      case CompanionAccessory.cap:
        return Icons.sports_esports_outlined;
      default:
        return Icons.circle;
    }
  }
}
