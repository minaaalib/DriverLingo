import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solar_icons/solar_icons.dart';

import '../theme/app_theme.dart';
import '../theme/widgets.dart';

class _Developer {
  const _Developer(this.name, this.email);
  final String name;
  final String email;
}

const _developers = [
  _Developer('Trixie Paches', 'trixie.paches@wvsu.edu.ph'),
  _Developer('Jorlen Diaz', 'jorlen.diaz@wvsu.edu.ph'),
  _Developer('Danilyn PeÃ±aranda', 'danilyn.peÃ±aranda@wvsu.edu.ph'),
  _Developer('Dennis Palermo', 'dennis.palermo@wvsu.edu.ph'),
];

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return GlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Contact Us')),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                'DriverLingo (LTO Exam Reviewer Mobile App with Hiligaynon Translation) is a capstone '
                'project by BSIT students of West Visayas State University - Pototan Campus. For '
                'questions, feedback, or to flag a question/answer that needs review, reach out to any '
                'of the developers below.',
                style: TextStyle(color: p.textSecondary, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 20),
              const SectionLabel('Development team'),
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
      SnackBar(content: Text('Copied ${developer.email}'), duration: const Duration(seconds: 2)),
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
          AvatarBadge(initials: initialsOf(developer.name), size: 44),
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
