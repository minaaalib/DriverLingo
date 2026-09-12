import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../services/language_service.dart';
import 'constants.dart';

/// Short, frequently-seen UI text - nav labels, buttons, dialogs, section
/// headers - translated into English/Filipino/Hiligaynon and looked up by
/// the same [LanguagePreference] that already drives exam-question
/// translation, so one language pick controls the whole app.
///
/// Long-form pages (FAQs, Privacy Policy, Terms & Conditions, How the
/// System Works, Contact Us) are out of scope for this table and stay
/// English-only. As with the exam content itself, these translations are
/// a first pass and worth spot-checking against a native Hiligaynon
/// speaker before a real launch.
class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> _values = {
    // Bottom nav
    'nav_home': {AppLanguage.english: 'Home', AppLanguage.filipino: 'Home', AppLanguage.hiligaynon: 'Balay'},
    'nav_history': {AppLanguage.english: 'History', AppLanguage.filipino: 'Kasaysayan', AppLanguage.hiligaynon: 'Kasaysayan'},
    'nav_profile': {AppLanguage.english: 'Profile', AppLanguage.filipino: 'Profile', AppLanguage.hiligaynon: 'Profile'},
    'nav_settings': {AppLanguage.english: 'Settings', AppLanguage.filipino: 'Mga Setting', AppLanguage.hiligaynon: 'Mga Setting'},

    // Welcome screen
    'welcome_badge': {AppLanguage.english: 'LTO Reviewer', AppLanguage.filipino: 'LTO Reviewer', AppLanguage.hiligaynon: 'LTO Reviewer'},
    'welcome_choose_language': {
      AppLanguage.english: 'CHOOSE YOUR LANGUAGE',
      AppLanguage.filipino: 'PILIIN ANG WIKA',
      AppLanguage.hiligaynon: 'PILIA ANG LENGGWAHE',
    },
    'welcome_continue': {AppLanguage.english: 'Continue', AppLanguage.filipino: 'Magpatuloy', AppLanguage.hiligaynon: 'Padayon'},
    'welcome_quote_1': {
      AppLanguage.english: 'Every Mile Begins\nWith Confidence.',
      AppLanguage.filipino: 'Bawat Milya ay\nNagsisimula sa Tiwala.',
      AppLanguage.hiligaynon: 'Ang Kada Milya\nNagasugod sa Pagsalig.',
    },
    'welcome_quote_2': {
      AppLanguage.english: 'Master The Road.\nMaster The Exam.',
      AppLanguage.filipino: 'Bihasain ang Daan.\nBihasain ang Pagsusulit.',
      AppLanguage.hiligaynon: 'Batunon ang Dalan.\nBatunon ang Ekzam.',
    },
    'welcome_quote_3': {
      AppLanguage.english: 'Your License,\nYour Language.',
      AppLanguage.filipino: 'Iyong Lisensya,\nIyong Wika.',
      AppLanguage.hiligaynon: 'Imo Lisensya,\nImo Lenggwahe.',
    },
    'welcome_quote_4': {
      AppLanguage.english: 'Practice Today.\nDrive Tomorrow.',
      AppLanguage.filipino: 'Magsanay Ngayon.\nMagmaneho Bukas.',
      AppLanguage.hiligaynon: 'Pagpraktis Karon.\nPagmaneho Buas.',
    },

    // Login
    'login_continue_google': {
      AppLanguage.english: 'Continue with Google',
      AppLanguage.filipino: 'Magpatuloy gamit ang Google',
      AppLanguage.hiligaynon: 'Padayon gamit ang Google',
    },
    'login_continue_google_loading': {
      AppLanguage.english: 'Signing in...',
      AppLanguage.filipino: 'Naglo-log in...',
      AppLanguage.hiligaynon: 'Nagalog in...',
    },

    // Home screen
    'home_ready_to_practice': {
      AppLanguage.english: 'Ready to practice?',
      AppLanguage.filipino: 'Handa nang magsanay?',
      AppLanguage.hiligaynon: 'Handa na mag-practice?',
    },
    'home_default_name': {AppLanguage.english: 'Driver', AppLanguage.filipino: 'Drayber', AppLanguage.hiligaynon: 'Drayber'},
    'home_momentum_title': {
      AppLanguage.english: 'Keep up the\nmomentum!',
      AppLanguage.filipino: 'Ipagpatuloy ang\nmomentum!',
      AppLanguage.hiligaynon: 'Ipadayon ang\nmomentum!',
    },
    'home_first_exam_title': {
      AppLanguage.english: 'Take your\nfirst mock exam!',
      AppLanguage.filipino: 'Kunin ang iyong\nunang mock exam!',
      AppLanguage.hiligaynon: 'Kuhaa ang imo\nuna nga mock exam!',
    },
    'home_no_attempts': {
      AppLanguage.english: 'No attempts yet',
      AppLanguage.filipino: 'Wala pang tangka',
      AppLanguage.hiligaynon: 'Wala pa sing tangka',
    },
    'home_best': {AppLanguage.english: 'Best', AppLanguage.filipino: 'Pinakamataas', AppLanguage.hiligaynon: 'Pinakamataas'},
    'home_day_streak': {
      AppLanguage.english: '{n}-day streak',
      AppLanguage.filipino: '{n} araw nang sunod-sunod',
      AppLanguage.hiligaynon: '{n} ka adlaw nga sunod-sunod',
    },
    'home_overall_readiness': {
      AppLanguage.english: 'OVERALL READINESS',
      AppLanguage.filipino: 'KABUUANG KAHANDAAN',
      AppLanguage.hiligaynon: 'KABUOAN NGA PAGKAHANDA',
    },
    'home_exam_category': {
      AppLanguage.english: 'Exam category',
      AppLanguage.filipino: 'Kategorya ng pagsusulit',
      AppLanguage.hiligaynon: 'Kategorya sang ekzam',
    },
    'home_items_standard': {
      AppLanguage.english: 'items · LTO standard',
      AppLanguage.filipino: 'items · pamantayan ng LTO',
      AppLanguage.hiligaynon: 'items · sukaranan sang LTO',
    },
    'home_questions_label': {AppLanguage.english: 'QUESTIONS', AppLanguage.filipino: 'MGA TANONG', AppLanguage.hiligaynon: 'MGA PAMANGKOT'},
    'home_timer_label': {AppLanguage.english: 'TIMER', AppLanguage.filipino: 'ORAS', AppLanguage.hiligaynon: 'ORAS'},
    'home_start_exam': {
      AppLanguage.english: 'Start Mock Exam',
      AppLanguage.filipino: 'Simulan ang Mock Exam',
      AppLanguage.hiligaynon: 'Sugdan ang Mock Exam',
    },
    'home_starting': {AppLanguage.english: 'Starting...', AppLanguage.filipino: 'Sinisimulan...', AppLanguage.hiligaynon: 'Ginasugdan...'},
    'home_sheet_title': {
      AppLanguage.english: 'Number of questions',
      AppLanguage.filipino: 'Bilang ng mga tanong',
      AppLanguage.hiligaynon: 'Kadamu sang mga pamangkot',
    },
    'home_custom_switch': {
      AppLanguage.english: 'Use a custom number',
      AppLanguage.filipino: 'Gumamit ng custom na bilang',
      AppLanguage.hiligaynon: 'Gamiton ang custom nga kadamu',
    },
    'home_custom_value': {AppLanguage.english: 'Custom', AppLanguage.filipino: 'Custom', AppLanguage.hiligaynon: 'Custom'},
    'home_standard_value': {AppLanguage.english: 'Standard', AppLanguage.filipino: 'Standard', AppLanguage.hiligaynon: 'Standard'},
    'home_done': {AppLanguage.english: 'Done', AppLanguage.filipino: 'Tapos na', AppLanguage.hiligaynon: 'Tapos na'},

    // Exam screen
    'exam_question_of': {
      AppLanguage.english: 'Question {a} of {b}',
      AppLanguage.filipino: 'Tanong {a} ng {b}',
      AppLanguage.hiligaynon: 'Pamangkot {a} sang {b}',
    },
    'action_translate': {AppLanguage.english: 'Translate', AppLanguage.filipino: 'Isalin', AppLanguage.hiligaynon: 'Baylo Lenggwahe'},
    'exam_previous': {AppLanguage.english: 'Previous', AppLanguage.filipino: 'Nakaraan', AppLanguage.hiligaynon: 'Nagligad'},
    'exam_next': {AppLanguage.english: 'Next', AppLanguage.filipino: 'Susunod', AppLanguage.hiligaynon: 'Sunod'},
    'exam_submit_progress': {AppLanguage.english: 'Submit', AppLanguage.filipino: 'I-submit', AppLanguage.hiligaynon: 'I-submit'},
    'exam_submitting': {AppLanguage.english: 'Submitting...', AppLanguage.filipino: 'Sina-submit...', AppLanguage.hiligaynon: 'Ginasubmit...'},
    'exam_submit_dialog_title': {
      AppLanguage.english: 'Submit exam?',
      AppLanguage.filipino: 'Isumite ang pagsusulit?',
      AppLanguage.hiligaynon: 'I-submit ang ekzam?',
    },
    'exam_answered_count': {
      AppLanguage.english: 'You answered {a} of {b} questions.',
      AppLanguage.filipino: 'Nasagot mo ang {a} sa {b} na tanong.',
      AppLanguage.hiligaynon: 'Ginsabat mo ang {a} sa {b} ka pamangkot.',
    },
    'exam_unanswered_note': {
      AppLanguage.english: 'Unanswered questions will be marked incorrect. Submit anyway?',
      AppLanguage.filipino: 'Ang mga hindi nasagot na tanong ay ituturing na mali. Isumite pa rin?',
      AppLanguage.hiligaynon: 'Ang mga wala matsabat nga pamangkot markahan nga sayop. I-submit gihapon?',
    },
    'exam_keep_answering': {
      AppLanguage.english: 'Keep answering',
      AppLanguage.filipino: 'Ipagpatuloy ang pagsagot',
      AppLanguage.hiligaynon: 'Padayon sa pagsabat',
    },
    'exam_submit_button': {AppLanguage.english: 'Submit', AppLanguage.filipino: 'Isumite', AppLanguage.hiligaynon: 'I-submit'},
    'exam_leave_dialog_title': {
      AppLanguage.english: 'Leave exam?',
      AppLanguage.filipino: 'Umalis sa pagsusulit?',
      AppLanguage.hiligaynon: 'Bayaan ang ekzam?',
    },
    'exam_leave_dialog_body': {
      AppLanguage.english: 'Your progress on this attempt will be lost.',
      AppLanguage.filipino: 'Mawawala ang iyong progreso sa pagsusulit na ito.',
      AppLanguage.hiligaynon: 'Madula ang imo progreso sa sini nga tangka.',
    },
    'exam_stay': {AppLanguage.english: 'Stay', AppLanguage.filipino: 'Manatili', AppLanguage.hiligaynon: 'Magpabilin'},
    'exam_leave': {AppLanguage.english: 'Leave', AppLanguage.filipino: 'Umalis', AppLanguage.hiligaynon: 'Halin'},

    // Results screen
    'results_back_home': {AppLanguage.english: 'Back to Home', AppLanguage.filipino: 'Bumalik sa Home', AppLanguage.hiligaynon: 'Balik sa Home'},
    'results_translate_tooltip': {
      AppLanguage.english: 'Translate the review',
      AppLanguage.filipino: 'Isalin ang review',
      AppLanguage.hiligaynon: 'Baylo lenggwahe sang review',
    },
    'results_title': {
      AppLanguage.english: 'Exam Results',
      AppLanguage.filipino: 'Resulta ng Pagsusulit',
      AppLanguage.hiligaynon: 'Resulta sang Ekzam',
    },
    'results_passed': {AppLanguage.english: 'PASSED', AppLanguage.filipino: 'PUMASA', AppLanguage.hiligaynon: 'NAKAPASAR'},
    'results_needs_review': {
      AppLanguage.english: 'NEEDS MORE REVIEW',
      AppLanguage.filipino: 'KAILANGAN PA NG REBYU',
      AppLanguage.hiligaynon: 'KINAHANGLAN PA SING REBYU',
    },
    'results_review_answers': {
      AppLanguage.english: 'Review your answers',
      AppLanguage.filipino: 'Suriin ang iyong mga sagot',
      AppLanguage.hiligaynon: 'Usisaon ang imo mga sabat',
    },
    'results_retake': {
      AppLanguage.english: 'Take Test Again',
      AppLanguage.filipino: 'Ulitin ang Pagsusulit',
      AppLanguage.hiligaynon: 'Sulayan Liwat ang Ekzam',
    },

    // History screen
    'history_title': {
      AppLanguage.english: 'Exam History',
      AppLanguage.filipino: 'Kasaysayan ng Pagsusulit',
      AppLanguage.hiligaynon: 'Kasaysayan sang Ekzam',
    },
    'history_failed_load': {
      AppLanguage.english: 'Failed to load history.',
      AppLanguage.filipino: 'Hindi na-load ang kasaysayan.',
      AppLanguage.hiligaynon: 'Wala na-load ang kasaysayan.',
    },
    'history_empty': {
      AppLanguage.english: 'No mock exams taken yet. Go take one!',
      AppLanguage.filipino: 'Wala ka pang nakuhang mock exam. Kumuha na!',
      AppLanguage.hiligaynon: 'Wala ka pa sing na-agyan nga mock exam. Kuha na!',
    },
    'history_correct': {AppLanguage.english: 'correct', AppLanguage.filipino: 'tama', AppLanguage.hiligaynon: 'husto'},

    // Profile screen
    'profile_title': {AppLanguage.english: 'Profile', AppLanguage.filipino: 'Profile', AppLanguage.hiligaynon: 'Profile'},
    'profile_admin': {AppLanguage.english: 'Admin', AppLanguage.filipino: 'Admin', AppLanguage.hiligaynon: 'Admin'},
    'profile_examinee': {AppLanguage.english: 'Examinee', AppLanguage.filipino: 'Eksaminado', AppLanguage.hiligaynon: 'Eksaminado'},
    'profile_verified': {AppLanguage.english: 'Verified', AppLanguage.filipino: 'Beripikado', AppLanguage.hiligaynon: 'Beripikado'},
    'profile_about': {AppLanguage.english: 'About', AppLanguage.filipino: 'Tungkol', AppLanguage.hiligaynon: 'Parte'},
    'profile_languages': {AppLanguage.english: 'Languages', AppLanguage.filipino: 'Mga Wika', AppLanguage.hiligaynon: 'Mga Lenggwahe'},
    'profile_content': {AppLanguage.english: 'Content', AppLanguage.filipino: 'Nilalaman', AppLanguage.hiligaynon: 'Kasuludan'},
    'profile_content_value': {
      AppLanguage.english: 'LTO reviewer questions',
      AppLanguage.filipino: 'tanong sa LTO reviewer',
      AppLanguage.hiligaynon: 'ka pamangkot sa LTO reviewer',
    },
    'profile_app': {AppLanguage.english: 'App', AppLanguage.filipino: 'App', AppLanguage.hiligaynon: 'App'},
    'profile_logout': {AppLanguage.english: 'Log out', AppLanguage.filipino: 'Mag-log out', AppLanguage.hiligaynon: 'Mag-log out'},
    'profile_logout_confirm_title': {
      AppLanguage.english: 'Log out?',
      AppLanguage.filipino: 'Mag-log out?',
      AppLanguage.hiligaynon: 'Mag-log out?',
    },
    'profile_logout_confirm_body': {
      AppLanguage.english: 'You can log back in any time.',
      AppLanguage.filipino: 'Puwede kang mag-log in ulit anumang oras.',
      AppLanguage.hiligaynon: 'Pwede ka gid magbalik log in bisan san-o.',
    },
    'action_cancel': {AppLanguage.english: 'Cancel', AppLanguage.filipino: 'Kanselahin', AppLanguage.hiligaynon: 'Kanselahon'},

    // Settings screen
    'settings_title': {AppLanguage.english: 'Settings', AppLanguage.filipino: 'Mga Setting', AppLanguage.hiligaynon: 'Mga Setting'},
    'settings_appearance': {AppLanguage.english: 'Appearance', AppLanguage.filipino: 'Hitsura', AppLanguage.hiligaynon: 'Hitsura'},
    'settings_system_default': {
      AppLanguage.english: 'System default',
      AppLanguage.filipino: 'Default ng sistema',
      AppLanguage.hiligaynon: 'Default sang sistema',
    },
    'settings_light': {AppLanguage.english: 'Light', AppLanguage.filipino: 'Maliwanag', AppLanguage.hiligaynon: 'Masanag'},
    'settings_dark': {AppLanguage.english: 'Dark', AppLanguage.filipino: 'Madilim', AppLanguage.hiligaynon: 'Madulom'},
    'settings_reviewer_language': {
      AppLanguage.english: 'Reviewer language',
      AppLanguage.filipino: 'Wika ng Reviewer',
      AppLanguage.hiligaynon: 'Lenggwahe sang Reviewer',
    },
    'settings_support_legal': {
      AppLanguage.english: 'Support & legal',
      AppLanguage.filipino: 'Suporta at Legal',
      AppLanguage.hiligaynon: 'Suporta kag Legal',
    },
    'settings_how_it_works': {
      AppLanguage.english: 'How the system works',
      AppLanguage.filipino: 'Paano gumagana ang sistema',
      AppLanguage.hiligaynon: 'Paano nagagamit ang sistema',
    },
    'settings_faqs': {AppLanguage.english: 'FAQs', AppLanguage.filipino: 'FAQs', AppLanguage.hiligaynon: 'FAQs'},
    'settings_privacy': {
      AppLanguage.english: 'Privacy policy',
      AppLanguage.filipino: 'Patakaran sa Privacy',
      AppLanguage.hiligaynon: 'Palisiya sa Privacy',
    },
    'settings_terms': {
      AppLanguage.english: 'Terms & conditions',
      AppLanguage.filipino: 'Mga Tuntunin at Kundisyon',
      AppLanguage.hiligaynon: 'Mga Kasugtanan kag Kundisyon',
    },
    'settings_contact': {AppLanguage.english: 'Contact us', AppLanguage.filipino: 'Kontakin kami', AppLanguage.hiligaynon: 'Kontaka kami'},
  };

  static String of(String key, String language) {
    final entry = _values[key];
    if (entry == null) return key;
    return entry[language] ?? entry[AppLanguage.english] ?? key;
  }
}

/// Shorthand for `AppStrings.of(key, currentLanguage)`. Watches
/// [LanguagePreference] so the caller rebuilds when the language changes.
/// Only call this from a widget's `build()` method (or a builder callback
/// that runs during a build phase, like `showModalBottomSheet`'s
/// `builder`) - Provider's `watch` asserts if used elsewhere. For a
/// one-off lookup from a button handler, dialog helper, or other
/// non-build callback, use [trRead] instead.
String tr(BuildContext context, String key) {
  final language = context.watch<LanguagePreference>().language;
  return AppStrings.of(key, language);
}

/// Like [tr], but substitutes `{placeholder}` tokens from [params], e.g.
/// `trf(context, 'exam_question_of', {'a': '3', 'b': '40'})`.
String trf(BuildContext context, String key, Map<String, String> params) {
  var result = tr(context, key);
  for (final entry in params.entries) {
    result = result.replaceAll('{${entry.key}}', entry.value);
  }
  return result;
}

/// Read-only counterpart to [tr]: fetches the current language via
/// `context.read` instead of `context.watch`, so it's safe to call from
/// button handlers, dialog/snackbar helpers, or anywhere else outside an
/// active build phase. Doesn't subscribe to language changes - fine for
/// one-shot imperative UI like a dialog that's built once when shown.
String trRead(BuildContext context, String key) {
  final language = context.read<LanguagePreference>().language;
  return AppStrings.of(key, language);
}

/// Read-only counterpart to [trf]. See [trRead].
String trfRead(BuildContext context, String key, Map<String, String> params) {
  var result = trRead(context, key);
  for (final entry in params.entries) {
    result = result.replaceAll('{${entry.key}}', entry.value);
  }
  return result;
}
