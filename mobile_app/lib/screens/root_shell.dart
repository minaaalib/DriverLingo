import 'package:flutter/material.dart';

import '../services/exam_service.dart';
import '../theme/bottom_nav.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

/// Hosts the four bottom-nav tabs (Home, History, Profile, Settings) as a
/// single persistent shell, so switching tabs doesn't rebuild them.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  void _goTo(int index) => setState(() => _index = index);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowOnboarding());
  }

  /// A user with no exam attempts yet is treated as "new" and required to
  /// complete the onboarding walkthrough + a practice exam (OnboardingScreen)
  /// before using the rest of the app. Runs on every RootShell mount (i.e.
  /// every login), which is what makes it self-resolving: once they have at
  /// least one attempt, this is a no-op forever after - no separate
  /// "onboarding complete" flag to maintain. A failed history fetch (e.g.
  /// offline) is treated as "skip" rather than blocking a returning user.
  Future<void> _maybeShowOnboarding() async {
    try {
      final history = await ExamService().getHistory();
      if (history.isEmpty && mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const OnboardingScreen(), fullscreenDialog: true),
        );
      }
    } catch (_) {
      // Offline or request failed - don't block a possibly-returning user.
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      // The clay nav bar floats, so let each tab's background run behind it.
      extendBody: true,
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: AppBottomNav(currentIndex: _index, onTap: _goTo),
    );
  }
}
