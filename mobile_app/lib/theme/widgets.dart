import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:solar_icons/solar_icons.dart';

import '../core/constants.dart';
import 'app_theme.dart';

/// Fades and slides a whole screen's content up on first build — a
/// reusable page-entrance animation so every tab feels alive without each
/// screen wiring its own AnimationController.
class PageEntrance extends StatefulWidget {
  const PageEntrance({super.key, required this.child, this.delay = Duration.zero});
  final Widget child;
  final Duration delay;

  @override
  State<PageEntrance> createState() => _PageEntranceState();
}

class _PageEntranceState extends State<PageEntrance> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  );
  late final Animation<double> _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// Fades and slides a list item up shortly after its turn — gives list
/// screens (history, reviewer) a staggered cascade instead of everything
/// popping in at once. Cheap per item: only animates the first dozen or so
/// since later ones build off-screen anyway.
class StaggeredListItem extends StatefulWidget {
  const StaggeredListItem({super.key, required this.index, required this.child});
  final int index;
  final Widget child;

  @override
  State<StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<StaggeredListItem> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  );
  late final Animation<double> _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    final delay = Duration(milliseconds: 35 * widget.index.clamp(0, 10));
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// A soft diagonal gradient wash plus three glow blobs behind the page
/// content — a gentle primary-to-success tint that keeps cards readable
/// while giving every tab (home, history, reviewer, profile) some depth
/// instead of a flat fill.
class GlowBackground extends StatelessWidget {
  const GlowBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.alphaBlend(p.primary.withValues(alpha: 0.28), p.bg),
                Color.alphaBlend(p.primary.withValues(alpha: 0.08), p.bg),
                p.bg,
                Color.alphaBlend(p.success.withValues(alpha: 0.10), p.bg),
                Color.alphaBlend(p.success.withValues(alpha: 0.26), p.bg),
              ],
              stops: const [0, 0.3, 0.5, 0.7, 1],
            ),
          ),
        ),
        Positioned(top: -100, left: -80, child: _blob(300, p.glowTop, strength: 2.4)),
        Positioned(top: 240, right: -110, child: _blob(240, p.primary.withValues(alpha: 0.22))),
        Positioned(bottom: -120, right: -90, child: _blob(340, p.glowBottom, strength: 2.4)),
        child,
      ],
    );
  }

  Widget _blob(double size, Color color, {double strength = 1}) {
    final boosted = color.withValues(alpha: (color.a * strength).clamp(0, 1));
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [boosted, boosted.withValues(alpha: 0)]),
      ),
    );
  }
}

/// The same full-bleed road-photo backdrop used on the welcome screen,
/// reused on auth screens so the brand feel carries through. Content sits
/// on a dark gradient over the photo, so it should use white/light text.
class HeroPhotoBackground extends StatelessWidget {
  const HeroPhotoBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/landing/splash.jpg', fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.55),
                Colors.black.withValues(alpha: 0.45),
                Colors.black.withValues(alpha: 0.70),
              ],
              stops: const [0, 0.5, 1],
            ),
          ),
        ),
        child,
      ],
    );
  }
}

/// Small glass pill for picking the reviewer language from anywhere that
/// isn't the welcome screen's full-width dropdown — e.g. pinned to a
/// corner of the auth screens over the hero photo.
class CompactLanguagePicker extends StatelessWidget {
  const CompactLanguagePicker({super.key, required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: value,
      onSelected: onChanged,
      color: AppPalette.of(context).surfaceElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => AppLanguage.labels.entries
          .map(
            (entry) => PopupMenuItem<String>(
              value: entry.key,
              child: Text(entry.value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(SolarIconsOutline.globus, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              AppLanguage.labels[value] ?? value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(width: 2),
            const Icon(SolarIconsOutline.altArrowDown, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Small uppercase numbered section label ("1  EXAM CATEGORY").
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.number});
  final String text;
  final int? number;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          if (number != null) ...[
            Text('$number', style: TextStyle(color: p.textTertiary, fontWeight: FontWeight.w800, fontSize: 12)),
            const SizedBox(width: 6),
          ],
          Text(
            text.toUpperCase(),
            style: TextStyle(color: p.textTertiary, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.6),
          ),
        ],
      ),
    );
  }
}

/// Primary call-to-action: gradient fill, soft glow shadow, optional icon.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final enabled = onPressed != null && !isLoading;
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: enabled ? onPressed : null,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [p.primary, p.primaryDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(color: p.primary.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                      if (icon != null) ...[const SizedBox(width: 8), Icon(icon, color: Colors.white, size: 20)],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Secondary outline button (used for "Previous", "Keep answering", etc).
/// Pass [color] to recolor it for a destructive action (e.g. log out).
class OutlinePillButton extends StatelessWidget {
  const OutlinePillButton({super.key, required this.label, required this.onPressed, this.color, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: color?.withValues(alpha: 0.08) ?? p.surface,
          side: BorderSide(color: color ?? p.borderStrong, width: 1.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          foregroundColor: color ?? p.textPrimary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

/// A single pill choice, e.g. a language option.
class PillChip extends StatelessWidget {
  const PillChip({super.key, required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? p.primary : p.chipBg,
          border: Border.all(color: selected ? p.primary : p.chipBorder),
        ),
        child: Text(
          label,
          style: TextStyle(color: selected ? Colors.white : p.textSecondary, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// A selectable card with a leading icon box, title/subtitle, and a
/// trailing radio-style indicator. Used for exam category selection.
class SelectableCard extends StatelessWidget {
  const SelectableCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: selected ? p.primary.withValues(alpha: 0.12) : p.surface,
          border: Border.all(color: selected ? p.primary : p.border, width: selected ? 1.6 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: p.chipBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: selected ? p.primary : p.textSecondary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: p.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: p.textTertiary, fontSize: 13)),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? p.primary : Colors.transparent,
                border: Border.all(color: selected ? p.primary : p.borderStrong, width: 1.6),
              ),
              // Solar has no bare checkmark glyph; checkCircle would double up on this circle.
              child: selected ? const Icon(Icons.check, size: 15, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Small rounded stat badge, e.g. "Best 92%" or "4-day streak".
class StatPill extends StatelessWidget {
  const StatPill({super.key, required this.icon, required this.label, this.color});
  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final c = color ?? p.textPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: p.surfaceElevated,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: p.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: c)),
        ],
      ),
    );
  }
}

/// Gradient-filled initials avatar.
class AvatarBadge extends StatelessWidget {
  const AvatarBadge({super.key, required this.initials, this.size = 48});
  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.32),
        gradient: const LinearGradient(
          colors: [Color(0xFF4F7FFF), Color(0xFF2F5FE0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: size * 0.36),
      ),
    );
  }
}

String initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
}

/// Full-width language picker for the welcome screen, styled as frosted
/// glass over the hero photo: blurred backdrop, translucent white fill,
/// white text/icons so it reads clearly against the busy photo behind it.
class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key, required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 8)),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(SolarIconsOutline.altArrowDown, color: Colors.white, size: 26),
              ),
              dropdownColor: p.surfaceElevated,
              borderRadius: BorderRadius.circular(18),
              elevation: 6,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17),
              selectedItemBuilder: (context) => AppLanguage.labels.entries
                  .map(
                    (entry) => Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(SolarIconsOutline.globus, size: 19, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Text(entry.value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17)),
                      ],
                    ),
                  )
                  .toList(),
              items: AppLanguage.labels.entries
                  .map(
                    (entry) => DropdownMenuItem<String>(
                      value: entry.key,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          entry.value,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: p.textPrimary),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Frosted-glass text field for forms sitting on a hero photo (login,
/// register): blurred backdrop, translucent white fill, white text —
/// matches [LanguageDropdown] and the welcome screen's glass badge.
/// Password fields (obscureText: true) get a tappable eye icon to reveal
/// what was typed.
class GlassTextFormField extends StatefulWidget {
  const GlassTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  State<GlassTextFormField> createState() => _GlassTextFormFieldState();
}

class _GlassTextFormFieldState extends State<GlassTextFormField> {
  late bool _obscured = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: _obscured,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
              floatingLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              filled: false,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              errorStyle: const TextStyle(color: Color(0xFFFFC1C1), fontWeight: FontWeight.w600),
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _obscured ? SolarIconsOutline.eyeClosed : SolarIconsOutline.eye,
                        color: Colors.white70,
                      ),
                      onPressed: () => setState(() => _obscured = !_obscured),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

/// dotLottie (.lottie) files are a zip of a manifest.json plus the real
/// animation under animations/<id>.json. The package's default decoder
/// just grabs the first *.json it finds, which is the manifest — pick the
/// actual animation file instead.
Future<LottieComposition?> _decodeDotLottie(List<int> bytes) {
  return LottieComposition.decodeZip(
    bytes,
    filePicker: (files) => files.firstWhere(
      (f) => f.name.startsWith('animations/'),
      orElse: () => files.firstWhere((f) => f.name.endsWith('.json')),
    ),
  );
}

/// Lottie animation shown beside the home readiness card's headline, sized
/// by height with its native (landscape) aspect ratio preserved.
class ReadinessBadge extends StatelessWidget {
  const ReadinessBadge({super.key, this.size = 76, this.asset = 'assets/animations/car_driving_on_road.lottie'});
  final double size;
  final String asset;

  static const _aspectRatio = 500 / 320;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SizedBox(
      height: size,
      width: size * _aspectRatio,
      child: Lottie.asset(
        asset,
        fit: BoxFit.contain,
        repeat: true,
        decoder: _decodeDotLottie,
        errorBuilder: (context, error, stackTrace) => Icon(SolarIconsBold.wheel, color: p.primary),
      ),
    );
  }
}

/// Lottie animation shown on the results screen: confetti on a pass,
/// a softer "failed attempt" animation otherwise. Both source files are
/// square, so no aspect-ratio correction is needed like [ReadinessBadge].
class ExamResultBadge extends StatelessWidget {
  const ExamResultBadge({super.key, required this.passed, this.size = 140});
  final bool passed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SizedBox.square(
      dimension: size,
      child: Lottie.asset(
        passed ? 'assets/animations/confetti.lottie' : 'assets/animations/failed_attempt.lottie',
        fit: BoxFit.contain,
        repeat: true,
        decoder: _decodeDotLottie,
        errorBuilder: (context, error, stackTrace) =>
            Icon(passed ? SolarIconsBold.checkCircle : SolarIconsBold.dangerCircle, size: size * 0.5, color: passed ? p.success : p.danger),
      ),
    );
  }
}

/// A rounded card container matching the palette's surface style.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding, this.color, this.borderColor});
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color ?? p.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor ?? p.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: child,
    );
  }
}

/// Themed replacement for the plain Material [AlertDialog]: a rounded
/// card with an optional tinted icon badge, centered title/message, and
/// two full-width pill buttons (a solid confirm action over a plain-text
/// cancel), matching the rest of the app's rounded/pill visual language.
/// Returns true if the confirm button was tapped, false/null otherwise.
Future<bool?> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  IconData? icon,
  bool destructive = false,
}) {
  final p = AppPalette.of(context);
  final accent = destructive ? p.danger : p.primary;

  return showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(
            color: p.surfaceElevated,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 30, offset: const Offset(0, 14)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Icon(icon, color: accent, size: 26),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: p.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: p.textSecondary, fontSize: 14, height: 1.45),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Material(
                  color: accent,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.pop(context, true),
                    child: Center(
                      child: Text(confirmLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(foregroundColor: p.textSecondary),
                  child: Text(cancelLabel, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
