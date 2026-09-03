import 'package:flutter/material.dart';
import '../../../app/app.dart';
import '../../../app/routes/app_routes.dart';
import 'step1_welcome.dart';
import 'step2_situation.dart';
import 'step3_wellbeing.dart';
import 'step4_support_preferences.dart';
import 'step5_activity_preferences.dart';
import 'step6_ai_consent.dart';
import 'step7_confirmation.dart';

/// Top-level onboarding flow. Manages a PageController across 7 steps.
/// Step 1 (Welcome) is shown first; steps 2-7 use the shared OnboardingShell.
class SurvivorOnboardingFlow extends StatefulWidget {
  const SurvivorOnboardingFlow({super.key});

  @override
  State<SurvivorOnboardingFlow> createState() => _SurvivorOnboardingFlowState();
}

class _SurvivorOnboardingFlowState extends State<SurvivorOnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _totalSteps = 6; // steps 2-7 show progress (1-6)

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < 6) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _back() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipAll() {
    SurvivorProfileScope.of(context).skipOnboarding();
    Navigator.pushReplacementNamed(context, AppRoutes.survivor);
  }

  void _finish() {
    final provider = SurvivorProfileScope.of(context);
    provider.completeOnboarding();
    Navigator.pushReplacementNamed(context, AppRoutes.survivor);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _currentPage > 0) _back();
      },
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (i) => setState(() => _currentPage = i),
        children: [
          // Page 0 — Welcome (no progress bar)
          Step1Welcome(
            onBegin: _next,
            onSkip: _skipAll,
          ),
          // Pages 1-5 — Steps 2-6 (progress 1-5 of 6)
          Step2Situation(
            stepNumber: 1,
            totalSteps: _totalSteps,
            onContinue: _next,
            onBack: _back,
            onSkip: _next,
          ),
          Step3Wellbeing(
            stepNumber: 2,
            totalSteps: _totalSteps,
            onContinue: _next,
            onBack: _back,
            onSkip: _next,
          ),
          Step4SupportPreferences(
            stepNumber: 3,
            totalSteps: _totalSteps,
            onContinue: _next,
            onBack: _back,
            onSkip: _next,
          ),
          Step5ActivityPreferences(
            stepNumber: 4,
            totalSteps: _totalSteps,
            onContinue: _next,
            onBack: _back,
            onSkip: _next,
          ),
          Step6AiConsent(
            stepNumber: 5,
            totalSteps: _totalSteps,
            onContinue: _next,
            onBack: _back,
            onSkip: _next,
          ),
          // Page 6 — Confirmation (step 6 of 6)
          Step7Confirmation(
            stepNumber: 6,
            totalSteps: _totalSteps,
            onConfirm: _finish,
            onBack: _back,
          ),
        ],
      ),
    );
  }
}
