import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

import '../core/app_strings.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;
    final p = AppPalette.of(context);

    return GlowBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: PageEntrance(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(tr(context, 'profile_title'), style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w800, color: p.textPrimary)),
                const SizedBox(height: 20),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: p.primary.withValues(alpha: 0.35), blurRadius: 18, offset: const Offset(0, 8)),
                              ],
                            ),
                            child: AvatarBadge(initials: initialsOf(user?.name ?? '?'), size: 72),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name ?? tr(context, 'home_default_name'),
                                  style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w800, fontSize: 20, color: p.textPrimary),
                                ),
                                const SizedBox(height: 3),
                                Text(user?.email ?? '', style: TextStyle(color: p.textSecondary, fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          StatPill(
                            icon: user?.isAdmin == true ? SolarIconsBold.shield : SolarIconsBold.squareAcademicCap,
                            label: user?.isAdmin == true ? tr(context, 'profile_admin') : tr(context, 'profile_examinee'),
                            color: p.primary,
                          ),
                          const SizedBox(width: 8),
                          if (user?.isEmailVerified == true)
                            StatPill(icon: SolarIconsBold.verifiedCheck, label: tr(context, 'profile_verified'), color: p.success),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SectionLabel(tr(context, 'profile_about')),
                AppCard(
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: SolarIconsOutline.globus,
                        iconColor: p.primary,
                        label: tr(context, 'profile_languages'),
                        value: 'English Â· Filipino Â· Hiligaynon',
                      ),
                      Divider(height: 28, color: p.border),
                      _InfoRow(
                        icon: SolarIconsOutline.folderCheck,
                        iconColor: p.success,
                        label: tr(context, 'profile_content'),
                        value: '101 ${tr(context, 'profile_content_value')}',
                      ),
                      Divider(height: 28, color: p.border),
                      _InfoRow(
                        icon: SolarIconsOutline.infoCircle,
                        iconColor: p.textTertiary,
                        label: tr(context, 'profile_app'),
                        value: 'DriverLingo v1.0.0',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                OutlinePillButton(
                  label: tr(context, 'profile_logout'),
                  icon: SolarIconsOutline.logout,
                  color: p.danger,
                  onPressed: () => _confirmLogout(context, auth),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, AuthService auth) async {
    final confirmed = await showAppConfirmDialog(
      context,
      icon: SolarIconsBold.logout,
      destructive: true,
      title: trRead(context, 'profile_logout_confirm_title'),
      message: trRead(context, 'profile_logout_confirm_body'),
      confirmLabel: trRead(context, 'profile_logout'),
      cancelLabel: trRead(context, 'action_cancel'),
    );
    if (confirmed != true) return;
    await auth.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.iconColor, required this.label, required this.value});
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(label, style: TextStyle(color: p.textSecondary))),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(color: p.textPrimary, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
