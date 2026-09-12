import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

import '../core/app_strings.dart';
import 'app_theme.dart';

class _NavItem {
  const _NavItem(this.icon, this.labelKey);
  final IconData icon;
  final String labelKey;
}

const _navItems = [
  _NavItem(SolarIconsOutline.home2, 'nav_home'),
  _NavItem(SolarIconsOutline.history, 'nav_history'),
  _NavItem(SolarIconsOutline.userRounded, 'nav_profile'),
  _NavItem(SolarIconsOutline.settings, 'nav_settings'),
];

/// Soft neumorphic bottom navigation bar: the whole bar reads as a panel
/// raised off the page (a paired light/dark shadow rather than a border),
/// and the active tab looks pressed into that panel instead of pill-filled.
/// Every tab always shows its label underneath the icon.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: dark ? Colors.black.withValues(alpha: 0.55) : Colors.black.withValues(alpha: 0.12),
            blurRadius: 22,
            offset: const Offset(0, -8),
          ),
          BoxShadow(
            color: dark ? Colors.white.withValues(alpha: 0.04) : Colors.white.withValues(alpha: 0.9),
            blurRadius: 14,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 16, 10, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              return _NeuNavButton(
                icon: item.icon,
                label: tr(context, item.labelKey),
                selected: i == currentIndex,
                dark: dark,
                onTap: () => onTap(i),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NeuNavButton extends StatelessWidget {
  const _NeuNavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.dark,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    // textTertiary reads too faint against the near-black dark background;
    // textSecondary keeps unselected tabs legible without the fully bright
    // "selected" color.
    final unselectedColor = dark ? p.textSecondary : p.textTertiary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          // Must differ from the bar's own background (p.bg) or the
          // pressed-in shadows below have nothing to read against.
          color: selected ? p.surfaceElevated : null,
          boxShadow: selected
              ? [
                  // Pressed-in look: dark shadow on the light-source side,
                  // faint highlight on the opposite side.
                  BoxShadow(
                    color: dark ? Colors.black.withValues(alpha: 0.55) : Colors.black.withValues(alpha: 0.14),
                    blurRadius: 6,
                    offset: const Offset(3, 3),
                  ),
                  BoxShadow(
                    color: dark ? Colors.white.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.9),
                    blurRadius: 6,
                    offset: const Offset(-3, -3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: selected ? p.primary : unselectedColor),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected ? p.primary : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
