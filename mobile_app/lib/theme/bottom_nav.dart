import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solar_icons/solar_icons.dart';

import '../core/app_strings.dart';
import 'app_theme.dart';

class _NavItem {
  const _NavItem(this.icon, this.activeIcon, this.labelKey);
  final IconData icon;
  final IconData activeIcon;
  final String labelKey;
}

const _navItems = [
  _NavItem(SolarIconsOutline.home2, SolarIconsBold.home2, 'nav_home'),
  _NavItem(SolarIconsOutline.history, SolarIconsBold.history, 'nav_history'),
  _NavItem(SolarIconsOutline.userRounded, SolarIconsBold.userRounded, 'nav_profile'),
  _NavItem(SolarIconsOutline.settings, SolarIconsBold.settings, 'nav_settings'),
];

const _animDuration = Duration(milliseconds: 320);
const _animCurve = Curves.easeOutCubic;

/// Floating clay bottom navigation bar. Inactive tabs are just an icon;
/// the active tab grows into a raised blue clay pill showing a filled icon
/// and its label, and the pill glides between tabs when switching.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);

    // Soft fade behind the floating bar so page content scrolling
    // underneath dissolves into the background instead of peeking out.
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [p.bg.withValues(alpha: 0), p.bg.withValues(alpha: 0.85), p.bg],
          stops: const [0, 0.45, 1],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
          child: Container(
            height: 72,
            padding: const EdgeInsets.all(8),
            decoration: Clay.box(p, color: p.navBg, radius: 36, depth: 1.2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final selected = i == currentIndex;
                return AnimatedFlexible(
                  flex: selected ? 5 : 2,
                  child: _NavTab(
                    icon: selected ? item.activeIcon : item.icon,
                    label: tr(context, item.labelKey),
                    selected: selected,
                    onTap: () {
                      if (!selected) HapticFeedback.selectionClick();
                      onTap(i);
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

/// Animates a tab's share of the bar width so the active pill smoothly
/// widens while the others shrink.
class AnimatedFlexible extends StatelessWidget {
  const AnimatedFlexible({super.key, required this.flex, required this.child});
  final int flex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: flex.toDouble()),
      duration: _animDuration,
      curve: _animCurve,
      builder: (context, value, child) => Expanded(flex: (value * 100).round(), child: child!),
      child: child,
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final idleColor = p.isDark ? p.textSecondary : p.textTertiary;

    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: _animDuration,
          curve: _animCurve,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: selected
              ? Clay.accent(p.primary, radius: 28, depth: 0.55)
              : const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(28))),
          child: ClipRect(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: selected ? 1.0 : 0.92,
                  duration: _animDuration,
                  curve: _animCurve,
                  child: Icon(icon, size: 24, color: selected ? Colors.white : idleColor),
                ),
                // Label slides open only on the active tab.
                Flexible(
                  child: AnimatedSize(
                    duration: _animDuration,
                    curve: _animCurve,
                    child: selected
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
