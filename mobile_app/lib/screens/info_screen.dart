import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_strings.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';

/// One heading + body block within an [InfoScreen].
class InfoSection {
  const InfoSection(this.heading, this.body);
  final String heading;
  final String body;
}

/// "How the system works" copy, shared by the Settings > Support & legal
/// page and the mandatory first-login [OnboardingScreen] walkthrough, so
/// the two stay in sync instead of drifting apart. Looked up from
/// [AppStrings] (keys `how_it_works_*`) so it follows the current
/// [LanguagePreference] like the rest of the app's short-form UI text.
String howItWorksIntro(BuildContext context) => tr(context, 'how_it_works_intro');

List<InfoSection> howItWorksSections(BuildContext context) => [
  for (var i = 1; i <= 7; i++) InfoSection(tr(context, 'how_it_works_${i}_heading'), tr(context, 'how_it_works_${i}_body')),
];

/// Privacy Policy copy, looked up from [AppStrings] (keys `privacy_*`).
/// Pass `listen: false` when calling from a tap handler instead of build().
List<InfoSection> privacyPolicySections(BuildContext context, {bool listen = true}) {
  final t = listen ? tr : trRead;
  return [
    for (var i = 1; i <= 6; i++) InfoSection(t(context, 'privacy_${i}_heading'), t(context, 'privacy_${i}_body')),
  ];
}

/// Terms & Conditions copy, looked up from [AppStrings] (keys `terms_*`).
/// Pass `listen: false` when calling from a tap handler instead of build().
List<InfoSection> termsSections(BuildContext context, {bool listen = true}) {
  final t = listen ? tr : trRead;
  return [
    for (var i = 1; i <= 6; i++) InfoSection(t(context, 'terms_${i}_heading'), t(context, 'terms_${i}_body')),
  ];
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
    return GlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(title)),
        body: SafeArea(
          top: false,
          child: _InfoList(
            intro: intro,
            sections: sections,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          ),
        ),
      ),
    );
  }
}

/// Same content as [InfoScreen], shown as a pop-up bottom sheet instead of
/// a full page. Used before login (the welcome consent dialog) so the user
/// can read the policy without leaving the dialog.
Future<void> showInfoSheet(
  BuildContext context, {
  required String title,
  String? intro,
  required List<InfoSection> sections,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final p = AppPalette.of(sheetContext);
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: p.bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: p.clayRim),
            boxShadow: Clay.shadows(p, depth: 1.2),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: p.borderStrong, borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 8, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 20, color: p.textPrimary),
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        width: 38,
                        height: 38,
                        decoration: Clay.box(p, color: p.surfaceElevated, radius: 14, depth: 0.45),
                        alignment: Alignment.center,
                        child: Icon(Icons.close_rounded, size: 20, color: p.textPrimary),
                      ),
                      onPressed: () => Navigator.of(sheetContext).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _InfoList(
                  intro: intro,
                  sections: sections,
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Intro + section cards shared by [InfoScreen] and [showInfoSheet].
class _InfoList extends StatelessWidget {
  const _InfoList({this.intro, required this.sections, required this.padding, this.controller});

  final String? intro;
  final List<InfoSection> sections;
  final EdgeInsets padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return ListView(
      controller: controller,
      padding: padding,
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
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 17, color: p.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(section.body, style: TextStyle(color: p.textSecondary, fontSize: 14.5, height: 1.55)),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}
