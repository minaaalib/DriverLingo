import 'package:flutter/material.dart';

import '../theme/bottom_nav.dart';
import 'history_screen.dart';
import 'home_screen.dart';
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
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: AppBottomNav(currentIndex: _index, onTap: _goTo),
    );
  }
}
