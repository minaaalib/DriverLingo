import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solar_icons/solar_icons.dart';

import '../core/app_strings.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';

class _Developer {
  const _Developer(this.name, this.email);
  final String name;
  final String email;
}

const _developers = [
  _Developer('Dr. Rosie Jane P. Siosan', 'rosiejane.siosan@wvsu.edu.ph'),
];

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return GlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(tr(context, 'settings_contact'))),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                tr(context, 'contact_intro'),
                style: TextStyle(color: p.textSecondary, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 20),
              SectionLabel(tr(context, 'contact_team')),
              AppCard(
                child: Column(
                  children: [
                    for (final (index, dev) in _developers.indexed) ...[
                      _DeveloperRow(developer: dev),
                      if (index != _developers.length - 1) Divider(height: 24, color: p.border),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeveloperRow extends StatelessWidget {
  const _DeveloperRow({required this.developer});
  final _Developer developer;

  Future<void> _copyEmail(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: developer.email));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(trfRead(context, 'contact_copied', {'email': developer.email})), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return InkWell(
      onTap: () => _copyEmail(context),
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          const AvatarBadge(size: 44),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(developer.name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: p.textPrimary)),
                const SizedBox(height: 2),
                Text(developer.email, style: TextStyle(color: p.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          Icon(SolarIconsOutline.copy, size: 18, color: p.textTertiary),
        ],
      ),
    );
  }
}
