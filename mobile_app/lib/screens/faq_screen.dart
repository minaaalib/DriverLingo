import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

import '../core/app_strings.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';

class _Faq {
  const _Faq(this.id, this.question, this.answer);
  final int id;
  final String question;
  final String answer;
}

const _faqCount = 10;

List<_Faq> _faqs(BuildContext context) => [
  for (var i = 1; i <= _faqCount; i++) _Faq(i, tr(context, 'faq_${i}_q'), tr(context, 'faq_${i}_a')),
];

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = _faqs(context);
    return GlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(tr(context, 'settings_faqs'))),
        body: SafeArea(
          top: false,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            itemCount: faqs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _FaqTile(faq: faqs[index]),
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
          key: PageStorageKey('faq_${widget.faq.id}'),
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
