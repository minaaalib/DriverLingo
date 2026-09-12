import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../theme/widgets.dart';

/// One heading + body block within an [InfoScreen].
class InfoSection {
  const InfoSection(this.heading, this.body);
  final String heading;
  final String body;
}

/// Generic scrollable "legal/info" page: a title, an optional intro
/// paragraph, and a list of heading+body sections. Used for How the
/// System Works, Privacy Policy, and Terms & Conditions so those pages
/// share one consistent, readable layout instead of three bespoke ones.
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key, required this.title, this.intro, required this.sections});

  final String title;
  final String? intro;
  final List<InfoSection> sections;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return GlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(title)),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              if (intro != null) ...[
                Text(intro!, style: TextStyle(color: p.textSecondary, fontSize: 15, height: 1.5)),
                const SizedBox(height: 20),
              ],
              for (final section in sections) ...[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.heading,
                        style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, fontSize: 17, color: p.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(section.body, style: TextStyle(color: p.textSecondary, fontSize: 14.5, height: 1.55)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
