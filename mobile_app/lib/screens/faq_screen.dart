import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

import '../theme/app_theme.dart';
import '../theme/widgets.dart';

class _Faq {
  const _Faq(this.question, this.answer);
  final String question;
  final String answer;
}

const _faqs = [
  _Faq(
    'What is DriverLingo?',
    'DriverLingo (LTO Exam Reviewer Mobile App with Hiligaynon Translation) is a mock-exam reviewer that helps aspiring drivers prepare for the LTO written exam in English, Filipino, or Hiligaynon.',
  ),
  _Faq(
    'Is this an official LTO app?',
    'No. DriverLingo is an independent study aid built as a BSIT capstone project by students of West Visayas State University - Pototan Campus. It is not affiliated with, endorsed by, or connected to the Land Transportation Office.',
  ),
  _Faq(
    'Why Hiligaynon?',
    'Existing LTO reviewers are only available in English and Filipino, which leaves out Ilonggo/Hiligaynon speakers who are less comfortable in either language. DriverLingo translates every question, choice, and explanation into Hiligaynon so more drivers can prepare with confidence.',
  ),
  _Faq(
    'Does the app work offline?',
    'Yes. Once you have opened the reviewer questions at least once while online, they are cached on your device so you can keep studying without an internet connection.',
  ),
  _Faq(
    'Is DriverLingo free?',
    'Yes, DriverLingo is free to use.',
  ),
  _Faq(
    'How accurate are the questions and answers?',
    'Content is sourced from LTO reviewer materials, but some entries are still being verified against official references. If you notice an answer that looks incorrect, please let us know through Contact Us so it can be corrected.',
  ),
  _Faq(
    'Can I retake a mock exam?',
    'Yes, you can take as many mock exams as you like. Note that this is different from the real LTO exam, where failing three official attempts means a two-year wait before you can reapply.',
  ),
  _Faq(
    'Some Hiligaynon text still shows English or Filipino words - why?',
    'A few technical and legal terms used in traffic law do not have a direct Hiligaynon equivalent, so they are kept in their original language for clarity.',
  ),
  _Faq(
    'What devices does DriverLingo support?',
    'DriverLingo currently runs on Android phones and tablets.',
  ),
  _Faq(
    'How do I switch between light and dark mode?',
    'Go to Settings > Appearance and choose System default, Light, or Dark.',
  ),
];

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('FAQs')),
        body: SafeArea(
          top: false,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            itemCount: _faqs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _FaqTile(faq: _faqs[index]),
          ),
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.faq});
  final _Faq faq;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey(widget.faq.question),
          onExpansionChanged: (value) => setState(() => _expanded = value),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: p.primary,
          collapsedIconColor: p.textTertiary,
          leading: Icon(
            _expanded ? SolarIconsBold.checkCircle : SolarIconsOutline.questionCircle,
            color: _expanded ? p.primary : p.textTertiary,
            size: 20,
          ),
          title: Text(
            widget.faq.question,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: p.textPrimary),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.faq.answer, style: TextStyle(color: p.textSecondary, fontSize: 14, height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }
}
