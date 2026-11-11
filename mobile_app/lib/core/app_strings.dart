import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../services/language_service.dart';
import 'constants.dart';

/// Short, frequently-seen UI text - nav labels, buttons, dialogs, section
/// headers - translated into English/Filipino/Hiligaynon and looked up by
/// the same [LanguagePreference] that already drives exam-question
/// translation, so one language pick controls the whole app.
///
/// Long-form pages (How the System Works, Privacy Policy, Terms &
/// Conditions, FAQs, Contact Us) are translated here too. As with the exam content itself, these translations are
/// a first pass and worth spot-checking against a native Hiligaynon
/// speaker before a real launch.
class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> _values = {
    // Bottom nav
    'nav_home': {
      AppLanguage.english: 'Home',
      AppLanguage.filipino: 'Home',
      AppLanguage.hiligaynon: 'Balay'
    },
    'nav_history': {
      AppLanguage.english: 'History',
      AppLanguage.filipino: 'Kasaysayan',
      AppLanguage.hiligaynon: 'Kasaysayan'
    },
    'nav_profile': {
      AppLanguage.english: 'Profile',
      AppLanguage.filipino: 'Profile',
      AppLanguage.hiligaynon: 'Profile'
    },
    'nav_settings': {
      AppLanguage.english: 'Settings',
      AppLanguage.filipino: 'Mga Setting',
      AppLanguage.hiligaynon: 'Mga Setting'
    },

    // Welcome screen
    'welcome_badge': {
      AppLanguage.english: 'LTO Reviewer',
      AppLanguage.filipino: 'LTO Reviewer',
      AppLanguage.hiligaynon: 'LTO Reviewer'
    },
    'welcome_choose_language': {
      AppLanguage.english: 'CHOOSE YOUR LANGUAGE',
      AppLanguage.filipino: 'PILIIN ANG WIKA',
      AppLanguage.hiligaynon: 'PILIA ANG LENGGWAHE',
    },
    'welcome_continue': {
      AppLanguage.english: 'Continue',
      AppLanguage.filipino: 'Magpatuloy',
      AppLanguage.hiligaynon: 'Padayon'
    },
    'welcome_quote_1': {
      AppLanguage.english: 'Every Mile Begins\nWith Confidence.',
      AppLanguage.filipino: 'Bawat Milya ay\nNagsisimula sa Tiwala.',
      AppLanguage.hiligaynon: 'Ang Kada Milya\nNagasugod sa Pagsalig.',
    },
    'welcome_quote_2': {
      AppLanguage.english: 'Master The Road.\nMaster The Exam.',
      AppLanguage.filipino: 'Bihasain ang Daan.\nBihasain ang Pagsusulit.',
      AppLanguage.hiligaynon: 'Batunon ang Dalan.\nBatunon ang Ekzaminasyon.',
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

    // Onboarding (mandatory walkthrough + practice exam, shown once after a
    // new user's first login - see OnboardingScreen)
    'onboarding_title': {
      AppLanguage.english: 'Welcome to DriverLingo!',
      AppLanguage.filipino: 'Maligayang pagdating sa DriverLingo!',
      AppLanguage.hiligaynon: 'Maayong pag-abot sa DriverLingo!',
    },
    'onboarding_subtitle': {
      AppLanguage.english:
          'Before your first practice exam, here\'s a quick look at how everything works.',
      AppLanguage.filipino:
          'Bago ang iyong unang pang-ensayong pagsusulit, narito ang mabilisang gabay kung paano gumagana ang lahat.',
      AppLanguage.hiligaynon:
          'Antes sang imo una nga pang-ensayo nga ekzaminasyon, ari ang madasig nga pagtan-aw kon paano nagaobra ang tanan.',
    },
    'onboarding_cta': {
      AppLanguage.english: 'Start Practice Exam',
      AppLanguage.filipino: 'Simulan ang Pang-ensayong Pagsusulit',
      AppLanguage.hiligaynon: 'Sugdan ang Pang-ensayo nga Ekzaminasyon',
    },
    'onboarding_confirm_title': {
      AppLanguage.english: 'Ready to begin?',
      AppLanguage.filipino: 'Handa ka na ba?',
      AppLanguage.hiligaynon: 'Handa ka na bala?',
    },
    'onboarding_confirm_message': {
      AppLanguage.english:
          'You can take a short practice exam now, or skip it and explore the app first.',
      AppLanguage.filipino:
          'Maaari kang kumuha ng maikling practice exam ngayon, o laktawan ito at tingnan muna ang app.',
      AppLanguage.hiligaynon:
          'Mahimo ka magkuha sang malip-ot nga practice exam subong, ukon laktawan ini kag tan-awon anay ang app.',
    },
    'onboarding_confirm_start': {
      AppLanguage.english: 'Start Practice Exam',
      AppLanguage.filipino: 'Simulan ang Practice Exam',
      AppLanguage.hiligaynon: 'Sugdan ang Practice Exam',
    },
    'onboarding_confirm_skip': {
      AppLanguage.english: 'Skip for now',
      AppLanguage.filipino: 'Laktawan muna',
      AppLanguage.hiligaynon: 'Laktawan anay',
    },

    // "How it Works" copy - shared by the Settings > Support & legal page
    // and the OnboardingScreen walkthrough (see howItWorksSections).
    'how_it_works_intro': {
      AppLanguage.english:
          'DriverLingo helps aspiring drivers prepare for the LTO non-professional and '
              'professional driver\'s license exams in English, Filipino, or Hiligaynon.',
      AppLanguage.filipino:
          'Tinutulungan ng DriverLingo ang mga naghahangad na drayber na maghanda para sa '
              'LTO non-professional at professional na pagsusulit sa lisensya sa pagmaneho, sa Ingles, Filipino, '
              'o Hiligaynon.',
      AppLanguage.hiligaynon:
          'Ang DriverLingo nagabulig sa mga nagahandom nga drayber nga maghanda para sa '
              'LTO non-professional kag professional nga ekzaminasyon sa lisensya sa pagmaneho, sa Ingles, '
              'Filipino, ukon Hiligaynon.',
    },
    'how_it_works_1_heading': {
      AppLanguage.english: '1. Create an account',
      AppLanguage.filipino: '1. Gumawa ng account',
      AppLanguage.hiligaynon: '1. Humimo sang account',
    },
    'how_it_works_1_body': {
      AppLanguage.english:
          'Sign up with your name, email, and a password, or log in to an existing '
              'account. Your account keeps your exam history and progress saved across sessions.',
      AppLanguage.filipino:
          'Magparehistro gamit ang iyong pangalan, email, at password, o mag-log in sa '
              'umiiral na account. Iniingatan ng iyong account ang kasaysayan ng iyong pagsusulit at progreso '
              'sa bawat pagbisita.',
      AppLanguage.hiligaynon:
          'Magparehistro gamit ang imo ngalan, email, kag password, ukon mag-log in sa '
              'imo na-una nga account. Ginatipigan sang imo account ang kasaysayan sang imo ekzaminasyon kag '
              'pag-uswag sa kada pagsulod.',
    },
    'how_it_works_2_heading': {
      AppLanguage.english: '2. Choose your language',
      AppLanguage.filipino: '2. Piliin ang iyong wika',
      AppLanguage.hiligaynon: '2. Pilia ang imo lenggwahe',
    },
    'how_it_works_2_body': {
      AppLanguage.english:
          'Pick English, Filipino, or Hiligaynon at any time. Every question, answer '
              'choice, and explanation is available in all three languages so you can review in whichever '
              'one you understand best.',
      AppLanguage.filipino:
          'Pumili ng Ingles, Filipino, o Hiligaynon anumang oras. Available sa tatlong '
              'wika ang bawat tanong, pagpipilian ng sagot, at paliwanag para makapag-rebyu ka sa wikang '
              'pinaka-naiintindihan mo.',
      AppLanguage.hiligaynon:
          'Pilia ang Ingles, Filipino, ukon Hiligaynon bisan san-o. Ang kada pamangkot, '
              'mga kapilian sang sabat, kag paathag ara sa tatlo ka lenggwahe agod mahimo ka makarebyu sa '
              'lenggwahe nga imo labing nahangpan.',
    },
    'how_it_works_3_heading': {
      AppLanguage.english: '3. Take a mock exam',
      AppLanguage.filipino: '3. Kumuha ng Pang-ensayong Pagsusulit',
      AppLanguage.hiligaynon: '3. Magkuha sang Pang-ensayo nga Ekzaminasyon',
    },
    'how_it_works_3_body': {
      AppLanguage.english:
          'Answer timed practice questions drawn from the LTO reviewer question bank, '
              'covering road signs, traffic laws and regulations, and safe driving practices for '
              'non-professional and professional license categories.',
      AppLanguage.filipino:
          'Sagutin ang mga pang-ensayong tanong na may takdang oras, hango sa LTO reviewer '
              'question bank, sakop ang mga road sign, batas at regulasyon sa trapiko, at ligtas na pagmaneho '
              'para sa non-professional at professional na kategorya ng lisensya.',
      AppLanguage.hiligaynon:
          'Sabaton ang mga pamangkot nga pang-ensayo nga may takdo nga oras, halin sa LTO '
              'reviewer question bank, nagatakop sa mga road sign, layi kag regulasyon sa trapiko, kag maluwas '
              'nga pagmaneho para sa non-professional kag professional nga kategoriya sang lisensya.',
    },
    'how_it_works_4_heading': {
      AppLanguage.english: '4. Review your results',
      AppLanguage.filipino: '4. Suriin ang iyong resulta',
      AppLanguage.hiligaynon: '4. Usisaa ang imo resulta',
    },
    'how_it_works_4_body': {
      AppLanguage.english:
          'After submitting, see your score, your pass/fail status, and a full '
              'breakdown of every question with the correct answer and an explanation - so mistakes turn '
              'into something learned.',
      AppLanguage.filipino:
          'Pagkatapos isumite, makikita mo ang iyong score, pass/fail status, at buong '
              'breakdown ng bawat tanong kasama ang tamang sagot at paliwanag - para ang pagkakamali ay '
              'maging aral.',
      AppLanguage.hiligaynon:
          'Pagkatapos magsumite, makita mo ang imo score, pass/fail status, kag '
              'bug-os nga breakdown sang kada pamangkot lakip ang husto nga sabat kag paathag - agod ang sala '
              'mabaylo sa natun-an.',
    },
    'how_it_works_5_heading': {
      AppLanguage.english: '5. Track your progress',
      AppLanguage.filipino: '5. Subaybayan ang iyong progreso',
      AppLanguage.hiligaynon: '5. Bantayi ang imo pag-uswag',
    },
    'how_it_works_5_body': {
      AppLanguage.english:
          'Every attempt is saved to your Exam History, so you can look back at '
              'previous scores and see how you\'re improving over time.',
      AppLanguage.filipino:
          'Nai-save ang bawat pagsubok sa iyong Exam History, para makabalik-tanaw ka '
              'sa mga nakaraang score at makita kung paano ka umuunlad sa paglipas ng panahon.',
      AppLanguage.hiligaynon:
          'Natipigan ang kada pagsulay sa imo Exam History, agod makabalikid ka sa '
              'nagligad nga mga score kag makita kon paano ka nagaayo sa paglabay sang tion.',
    },
    'how_it_works_6_heading': {
      AppLanguage.english: '6. Study offline',
      AppLanguage.filipino: '6. Mag-aral offline',
      AppLanguage.hiligaynon: '6. Magtuon offline',
    },
    'how_it_works_6_body': {
      AppLanguage.english:
          'Once you\'ve opened the reviewer questions while online, they\'re cached on '
              'your device so you can keep practicing even without an internet connection.',
      AppLanguage.filipino:
          'Kapag nabuksan mo na ang mga tanong sa reviewer habang online, naka-cache na '
              'ito sa iyong device para makapagpatuloy kang mag-practice kahit walang internet connection.',
      AppLanguage.hiligaynon:
          'Kon nabuksan na nimo ang mga pamangkot sa reviewer samtang online, '
              'naka-cache na ini sa imo device agod makapadayon ka sa pagpraktis bisan wala sang internet '
              'connection.',
    },
    'how_it_works_7_heading': {
      AppLanguage.english: 'Behind the scenes',
      AppLanguage.filipino: 'Sa likod ng tabing',
      AppLanguage.hiligaynon: 'Sa likod sang tabing',
    },
    'how_it_works_7_body': {
      AppLanguage.english:
          'Administrators maintain and update the question bank and manage user '
              'accounts to keep the reviewer accurate and up to date.',
      AppLanguage.filipino:
          'Pinapanatili at ina-update ng mga administrator ang question bank at '
              'pinamamahalaan ang mga user account para mapanatiling tumpak at updated ang reviewer.',
      AppLanguage.hiligaynon:
          'Ginabantayan kag gina-update sang mga administrator ang question bank kag '
              'ginadumala ang mga user account agod mapadayon nga husto kag updated ang reviewer.',
    },

    // Consent dialog (welcome screen, shown before entering login)
    'consent_dialog_title': {
      AppLanguage.english: 'Before you continue',
      AppLanguage.filipino: 'Bago magpatuloy',
      AppLanguage.hiligaynon: 'Antes magpadayon',
    },
    'consent_dialog_message': {
      AppLanguage.english:
          'By continuing, you agree to DriverLingo\'s Terms & Conditions and Privacy Policy.',
      AppLanguage.filipino:
          'Sa pagpapatuloy, sumasang-ayon ka sa Mga Tuntunin at Kundisyon at Patakarang Pampribado ng DriverLingo.',
      AppLanguage.hiligaynon:
          'Paagi sa pagpadayon, nagakasugot ka sa Mga Kasugtanan kag Kundisyon kag Palisiya Pampribado sang DriverLingo.',
    },
    'consent_agree': {
      AppLanguage.english: 'I Agree',
      AppLanguage.filipino: 'Sumasang-ayon Ako',
      AppLanguage.hiligaynon: 'Nagakasugot Ako'
    },
    'consent_decline': {
      AppLanguage.english: 'Cancel',
      AppLanguage.filipino: 'Kanselahin',
      AppLanguage.hiligaynon: 'Kanselahon'
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
    'home_greeting': {
      AppLanguage.english: 'Hi, {name}!',
      AppLanguage.filipino: 'Kumusta, {name}!',
      AppLanguage.hiligaynon: 'Maayong adlaw, {name}!',
    },
    'home_ready_to_practice': {
      AppLanguage.english: 'Ready to practice?',
      AppLanguage.filipino: 'Handa nang magsanay?',
      AppLanguage.hiligaynon: 'Handa na maghanas?',
    },
    'home_default_name': {
      AppLanguage.english: 'Driver',
      AppLanguage.filipino: 'Drayber',
      AppLanguage.hiligaynon: 'Drayber'
    },
    'home_momentum_title': {
      AppLanguage.english: 'Keep up the\nmomentum!',
      AppLanguage.filipino: 'Ipagpatuloy ang\nsigla!',
      AppLanguage.hiligaynon: 'Ipadayon ang\nkusog kag gana!',
    },
    'home_first_exam_title': {
      AppLanguage.english: 'Take your\nfirst mock exam!',
      AppLanguage.filipino: 'Kunin ang iyong\nunang Pang-ensayong Pagsusulit!',
      AppLanguage.hiligaynon: 'Kuhaa ang imo\nuna nga Pang-ensayo nga Ekzaminasyon!',
    },
    'home_no_attempts': {
      AppLanguage.english: 'No attempts yet',
      AppLanguage.filipino: 'Wala pang tangka',
      AppLanguage.hiligaynon: 'Wala pa gid nagtilaw',
    },
    'home_best': {
      AppLanguage.english: 'Best',
      AppLanguage.filipino: 'Pinakamataas',
      AppLanguage.hiligaynon: 'Pinakamataas'
    },
    'home_day_streak': {
      AppLanguage.english: '{n}-day streak',
      AppLanguage.filipino: '{n} sunod-sunod na araw',
      AppLanguage.hiligaynon: '{n} ka sunod-sunod nga adlaw',
    },
    'home_overall_readiness': {
      AppLanguage.english: 'OVERALL READINESS',
      AppLanguage.filipino: 'KABUUANG KAHANDAAN',
      AppLanguage.hiligaynon: 'KABUOAN NGA PAGKAHANDA',
    },
    'home_exam_category': {
      AppLanguage.english: 'Exam category',
      AppLanguage.filipino: 'Kategorya ng pagsusulit',
      AppLanguage.hiligaynon: 'Kategorya sang Ekzaminasyon',
    },
    'home_items_standard': {
      AppLanguage.english: 'items · LTO standard',
      AppLanguage.filipino: 'items · pamantayan ng LTO',
      AppLanguage.hiligaynon: 'items · pagsulundan sang LTO',
    },
    'home_questions_label': {
      AppLanguage.english: 'QUESTIONS',
      AppLanguage.filipino: 'MGA TANONG',
      AppLanguage.hiligaynon: 'MGA PAMANGKOT'
    },
    'home_timer_label': {
      AppLanguage.english: 'TIMER',
      AppLanguage.filipino: 'ORAS',
      AppLanguage.hiligaynon: 'ORAS'
    },
    'home_start_exam': {
      AppLanguage.english: 'Start Mock Exam',
      AppLanguage.filipino: 'Simulan ang Pang-ensayong Pagsusulit',
      AppLanguage.hiligaynon: 'Sugdan ang Pang-ensayo nga Ekzaminasyon',
    },
    'home_starting': {
      AppLanguage.english: 'Starting...',
      AppLanguage.filipino: 'Sinisimulan...',
      AppLanguage.hiligaynon: 'Ginasugdan...'
    },
    'home_sheet_title': {
      AppLanguage.english: 'Number of questions',
      AppLanguage.filipino: 'Bilang ng mga tanong',
      AppLanguage.hiligaynon: 'Kadamu sang mga pamangkot',
    },
    'home_custom_switch': {
      AppLanguage.english: 'Use a custom number',
      AppLanguage.filipino: 'Gumamit ng custom na bilang',
      AppLanguage.hiligaynon: 'Gamiton ang custom nga numero',
    },
    'home_custom_value': {
      AppLanguage.english: 'Custom',
      AppLanguage.filipino: 'Custom',
      AppLanguage.hiligaynon: 'Custom'
    },
    'home_standard_value': {
      AppLanguage.english: 'Standard',
      AppLanguage.filipino: 'Standard',
      AppLanguage.hiligaynon: 'Standard'
    },
    'home_done': {
      AppLanguage.english: 'Done',
      AppLanguage.filipino: 'Tapos na',
      AppLanguage.hiligaynon: 'Tapos na'
    },

    // Exam screen
    'exam_question_of': {
      AppLanguage.english: 'Question {a} of {b}',
      AppLanguage.filipino: 'Tanong {a} ng {b}',
      AppLanguage.hiligaynon: 'Pamangkot {a} sang {b}',
    },
    'action_translate': {
      AppLanguage.english: 'Translate',
      AppLanguage.filipino: 'Isalin',
      AppLanguage.hiligaynon: 'Baylo Lenggwahe'
    },
    'exam_previous': {
      AppLanguage.english: 'Previous',
      AppLanguage.filipino: 'Nakaraan',
      AppLanguage.hiligaynon: 'Nagligad'
    },
    'exam_next': {
      AppLanguage.english: 'Next',
      AppLanguage.filipino: 'Susunod',
      AppLanguage.hiligaynon: 'Sunod'
    },
    'exam_submit_progress': {
      AppLanguage.english: 'Submit',
      AppLanguage.filipino: 'Ipasa',
      AppLanguage.hiligaynon: 'Ipasa'
    },
    'exam_submitting': {
      AppLanguage.english: 'Submitting...',
      AppLanguage.filipino: 'Pinapasa...',
      AppLanguage.hiligaynon: 'Ginapasa...'
    },
    'exam_submit_dialog_title': {
      AppLanguage.english: 'Submit exam?',
      AppLanguage.filipino: 'Isumite ang pagsusulit?',
      AppLanguage.hiligaynon: 'Ipasa ang ekzaminasyon?',
    },
    'exam_answered_count': {
      AppLanguage.english: 'You answered {a} of {b} questions.',
      AppLanguage.filipino: 'Nasagot mo ang {a} sa {b} na tanong.',
      AppLanguage.hiligaynon: 'Ginsabat mo ang {a} sa {b} ka pamangkot.',
    },
    'exam_unanswered_note': {
      AppLanguage.english:
          'Unanswered questions will be marked incorrect. Submit anyway?',
      AppLanguage.filipino:
          'Ang mga hindi nasagot na tanong ay ituturing na mali. Ipasa pa rin?',
      AppLanguage.hiligaynon:
          'Ang mga wala matsabat nga pamangkot markahan nga sala. Ipasa gihapon?',
    },
    'exam_keep_answering': {
      AppLanguage.english: 'Keep answering',
      AppLanguage.filipino: 'Ipagpatuloy ang pagsagot',
      AppLanguage.hiligaynon: 'Padayon sa pagsabat',
    },
    'exam_submit_button': {
      AppLanguage.english: 'Submit',
      AppLanguage.filipino: 'Ipasa',
      AppLanguage.hiligaynon: 'Ipasa'
    },
    'exam_leave_dialog_title': {
      AppLanguage.english: 'Leave exam?',
      AppLanguage.filipino: 'Liliban sa pagsusulit?',
      AppLanguage.hiligaynon: 'Bayaan ang ekzaminasyon?',
    },
    'exam_leave_dialog_body': {
      AppLanguage.english: 'Your progress on this attempt will be lost.',
      AppLanguage.filipino: 'Mawawala ang iyong progreso sa pagsusulit na ito.',
      AppLanguage.hiligaynon: 'Madula ang imo progreso sa sini nga ekzaminasyon.',
    },
    'exam_stay': {
      AppLanguage.english: 'Stay',
      AppLanguage.filipino: 'Manatili',
      AppLanguage.hiligaynon: 'Magpabilin'
    },
    'exam_leave': {
      AppLanguage.english: 'Leave',
      AppLanguage.filipino: 'Umalis',
      AppLanguage.hiligaynon: 'Halin'
    },

    // Results screen
    'results_back_home': {
      AppLanguage.english: 'Back to Home',
      AppLanguage.filipino: 'Bumalik sa Home',
      AppLanguage.hiligaynon: 'Balik sa Home'
    },
    'results_translate_tooltip': {
      AppLanguage.english: 'Translate the review',
      AppLanguage.filipino: 'Isalin ang rebyu',
      AppLanguage.hiligaynon: 'Baylo lenggwahe sang rebyu',
    },
    'results_title': {
      AppLanguage.english: 'Exam Results',
      AppLanguage.filipino: 'Resulta ng Pagsusulit',
      AppLanguage.hiligaynon: 'Resulta sang Ekzaminasyon',
    },
    'results_passed': {
      AppLanguage.english: 'PASSED',
      AppLanguage.filipino: 'PUMASA',
      AppLanguage.hiligaynon: 'NAKAPASAR'
    },
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
    'results_practice_more': {
      AppLanguage.english: 'Go to Home & Practice More',
      AppLanguage.filipino: 'Pumunta sa Home at Magsanay Pa',
      AppLanguage.hiligaynon: 'Kadto sa Home kag Magpraktis Pa',
    },
    'results_retake': {
      AppLanguage.english: 'Take Test Again',
      AppLanguage.filipino: 'Ulitin ang Pagsusulit',
      AppLanguage.hiligaynon: 'Magliwat sang Ekzaminasyon',
    },

    // History screen
    'history_title': {
      AppLanguage.english: 'Exam History',
      AppLanguage.filipino: 'Kasaysayan ng Pagsusulit',
      AppLanguage.hiligaynon: 'Kasaysayan sang Ekzaminasyon',
    },
    'history_failed_load': {
      AppLanguage.english: 'Failed to load history.',
      AppLanguage.filipino: 'Hindi na-load ang kasaysayan.',
      AppLanguage.hiligaynon: 'Wala na-load ang kasaysayan.',
    },
    'history_empty': {
      AppLanguage.english: 'No mock exams taken yet. Go take one!',
      AppLanguage.filipino: 'Wala ka pang nakuhang pang-ensayong pagsusulit. Kumuha na!',
      AppLanguage.hiligaynon:
          'Wala ka pa sing na-agyan nga pang-ensayo nga ekzaminasyon. Kuha na!',
    },
    'history_correct': {
      AppLanguage.english: 'correct',
      AppLanguage.filipino: 'tama',
      AppLanguage.hiligaynon: 'husto'
    },
    'history_resume_dialog_title': {
      AppLanguage.english: 'Continue this exam?',
      AppLanguage.filipino: 'Ituloy ang pagsusulit na ito?',
      AppLanguage.hiligaynon: 'Padayunon ini nga ekzam?',
    },
    'history_resume_dialog_message': {
      AppLanguage.english:
          'You have an unfinished attempt. Pick up right where you left off, or cancel and come back later.',
      AppLanguage.filipino:
          'May hindi mo pang natapos na pagsusulit. Ituloy mula sa huling tigil, o kanselahin at bumalik mamaya.',
      AppLanguage.hiligaynon:
          'May wala ka pa matapos nga ekzam. Padayunon halin sa imo gin-untatan, ukon kanselahon kag magbalik sa ulihi.',
    },
    'history_resume_confirm': {
      AppLanguage.english: 'Continue exam',
      AppLanguage.filipino: 'Ituloy ang pagsusulit',
      AppLanguage.hiligaynon: 'Padayunon ang ekzam',
    },
    'history_resume_cancel': {
      AppLanguage.english: 'Not now',
      AppLanguage.filipino: 'Huwag na muna',
      AppLanguage.hiligaynon: 'Indi na anay',
    },

    // Profile screen
    'profile_title': {
      AppLanguage.english: 'Profile',
      AppLanguage.filipino: 'Profile',
      AppLanguage.hiligaynon: 'Profile'
    },
    'profile_admin': {
      AppLanguage.english: 'Admin',
      AppLanguage.filipino: 'Admin',
      AppLanguage.hiligaynon: 'Admin'
    },
    'profile_examinee': {
      AppLanguage.english: 'Examinee',
      AppLanguage.filipino: 'Tagakuha ng Pagsusulit',
      AppLanguage.hiligaynon: 'Tagkuha sang Ekzaminasyon'
    },
    'profile_verified': {
      AppLanguage.english: 'Verified',
      AppLanguage.filipino: 'Beripikado',
      AppLanguage.hiligaynon: 'Beripikado'
    },
    'profile_about': {
      AppLanguage.english: 'About',
      AppLanguage.filipino: 'Tungkol',
      AppLanguage.hiligaynon: 'Parte'
    },
    'profile_languages': {
      AppLanguage.english: 'Languages',
      AppLanguage.filipino: 'Mga Wika',
      AppLanguage.hiligaynon: 'Mga Lenggwahe'
    },
    'profile_content': {
      AppLanguage.english: 'Content',
      AppLanguage.filipino: 'Nilalaman',
      AppLanguage.hiligaynon: 'Kasuludan'
    },
    'profile_content_value': {
      AppLanguage.english: 'LTO reviewer questions',
      AppLanguage.filipino: 'tanong sa LTO reviewer',
      AppLanguage.hiligaynon: 'mga pamangkot sa LTO reviewer',
    },
    'profile_app': {
      AppLanguage.english: 'App',
      AppLanguage.filipino: 'App',
      AppLanguage.hiligaynon: 'App'
    },
    'profile_logout': {
      AppLanguage.english: 'Log out',
      AppLanguage.filipino: 'Mag-log out',
      AppLanguage.hiligaynon: 'Mag-log out'
    },
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
    'action_cancel': {
      AppLanguage.english: 'Cancel',
      AppLanguage.filipino: 'Kanselahin',
      AppLanguage.hiligaynon: 'Kanselahon'
    },

    // Settings screen
    'settings_title': {
      AppLanguage.english: 'Settings',
      AppLanguage.filipino: 'Mga Setting',
      AppLanguage.hiligaynon: 'Mga Setting'
    },
    'settings_appearance': {
      AppLanguage.english: 'Appearance',
      AppLanguage.filipino: 'Hitsura',
      AppLanguage.hiligaynon: 'Hitsura'
    },
    'settings_system_default': {
      AppLanguage.english: 'System default',
      AppLanguage.filipino: 'Default ng sistema',
      AppLanguage.hiligaynon: 'Default sang sistema',
    },
    'settings_light': {
      AppLanguage.english: 'Light',
      AppLanguage.filipino: 'Maliwanag',
      AppLanguage.hiligaynon: 'Masanag'
    },
    'settings_dark': {
      AppLanguage.english: 'Dark',
      AppLanguage.filipino: 'Madilim',
      AppLanguage.hiligaynon: 'Madulom'
    },
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
    'settings_faqs': {
      AppLanguage.english: 'FAQs',
      AppLanguage.filipino: 'FAQs',
      AppLanguage.hiligaynon: 'FAQs'
    },
    'settings_privacy': {
      AppLanguage.english: 'Privacy policy',
      AppLanguage.filipino: 'Patakarang Pampribado',
      AppLanguage.hiligaynon: 'Palisiya Pampribado',
    },
    'settings_terms': {
      AppLanguage.english: 'Terms & conditions',
      AppLanguage.filipino: 'Mga Tuntunin at Kundisyon',
      AppLanguage.hiligaynon: 'Mga Kasugtanan kag Kundisyon',
    },

    // Privacy Policy page body (see privacyPolicySections in info_screen.dart).
    'privacy_intro': {
      AppLanguage.english:
          'We know studying for your license already means sharing enough paperwork with the '
              'government. Here\'s exactly what DriverLingo collects and why.',
      AppLanguage.filipino:
          'Alam naming sapat na ang mga papeles na ibinibigay mo sa gobyerno para sa iyong lisensya. '
              'Narito kung ano mismo ang kinokolekta ng DriverLingo at kung bakit.',
      AppLanguage.hiligaynon:
          'Nahibaluan namon nga madamo na ang mga papeles nga ginahatag mo sa gobyerno para sa imo '
              'lisensya. Ari kon ano gid ang ginakolekta sang DriverLingo kag kon ngaa.',
    },
    'privacy_1_heading': {
      AppLanguage.english: 'Information we collect',
      AppLanguage.filipino: 'Impormasyong kinokolekta namin',
      AppLanguage.hiligaynon: 'Impormasyon nga amon ginakolekta',
    },
    'privacy_1_body': {
      AppLanguage.english:
          'When you register, we collect your name, email address, and a securely hashed password. '
              'As you use the app, we also store your chosen reviewer language and your mock exam '
              'attempts (answers, scores, and timestamps).',
      AppLanguage.filipino:
          'Kapag nagparehistro ka, kinokolekta namin ang iyong pangalan, email address, at ligtas na '
              'naka-hash na password. Habang ginagamit mo ang app, iniimbak din namin ang napili mong wika '
              'sa pagrerebyu at ang iyong mga mock exam (mga sagot, iskor, at oras ng pagkuha).',
      AppLanguage.hiligaynon:
          'Kon magparehistro ka, ginakolekta namon ang imo ngalan, email address, kag luwas nga '
              'naka-hash nga password. Samtang ginagamit mo ang app, ginatipigan man namon ang imo napili '
              'nga lenggwahe sa pagrebyu kag ang imo mga mock exam (mga sabat, iskor, kag oras sang pagkuha).',
    },
    'privacy_2_heading': {
      AppLanguage.english: 'How we use it',
      AppLanguage.filipino: 'Paano namin ito ginagamit',
      AppLanguage.hiligaynon: 'Paano namon ini ginagamit',
    },
    'privacy_2_body': {
      AppLanguage.english:
          'Your account details let you log in and keep your progress across devices. Your exam '
              'history lets you review past attempts and track improvement. We do not use your data '
              'for advertising, and we do not sell or share it with third parties.',
      AppLanguage.filipino:
          'Ginagamit ang detalye ng iyong account para makapag-log in ka at maitabi ang iyong progreso '
              'sa iba\'t ibang device. Ang kasaysayan ng iyong pagsusulit ay para mabalikan mo ang mga '
              'nakaraang pagsubok at makita ang iyong pag-unlad. Hindi namin ginagamit ang iyong datos para '
              'sa advertising, at hindi namin ito ibinebenta o ibinabahagi sa ibang partido.',
      AppLanguage.hiligaynon:
          'Ginagamit ang detalye sang imo account agod makalog-in ka kag matipigan ang imo pag-uswag '
              'sa lain-lain nga device. Ang kasaysayan sang imo ekzaminasyon para mabalikan mo ang imo mga '
              'nagligad nga pagtilaw kag makita ang imo pag-uswag. Wala namon ginagamit ang imo datos para '
              'sa advertising, kag wala namon ini ginabaligya ukon ginapaambit sa iban nga partido.',
    },
    'privacy_3_heading': {
      AppLanguage.english: 'Offline data',
      AppLanguage.filipino: 'Offline na datos',
      AppLanguage.hiligaynon: 'Offline nga datos',
    },
    'privacy_3_body': {
      AppLanguage.english:
          'Reviewer questions downloaded for offline use are cached locally on your device only, and '
              'are not shared with anyone else.',
      AppLanguage.filipino:
          'Ang mga tanong na na-download para sa offline na paggamit ay nakaimbak lamang sa iyong '
              'device, at hindi ibinabahagi kaninuman.',
      AppLanguage.hiligaynon:
          'Ang mga pamangkot nga na-download para sa offline nga paggamit natipig lamang sa imo '
              'device, kag wala ginapaambit kay bisan sin-o.',
    },
    'privacy_4_heading': {
      AppLanguage.english: 'Data storage & security',
      AppLanguage.filipino: 'Pag-iimbak at seguridad ng datos',
      AppLanguage.hiligaynon: 'Pagtipig kag seguridad sang datos',
    },
    'privacy_4_body': {
      AppLanguage.english:
          'Your information is stored on our servers with hashed passwords and access limited to the '
              'development team maintaining the app. This app was built as an academic capstone '
              'project, so please avoid submitting sensitive personal information beyond what '
              'registration requires.',
      AppLanguage.filipino:
          'Nakaimbak ang iyong impormasyon sa aming mga server na may naka-hash na password, at ang '
              'development team lamang na nangangalaga sa app ang may access dito. Ginawa ang app na ito '
              'bilang isang akademikong capstone project, kaya iwasang magbigay ng sensitibong personal na '
              'impormasyon na lampas sa kailangan sa pagpaparehistro.',
      AppLanguage.hiligaynon:
          'Natipig ang imo impormasyon sa amon mga server nga may naka-hash nga password, kag ang '
              'development team lamang nga nagaatipan sang app ang may access sini. Ginhimo ini nga app '
              'subong isa ka akademiko nga capstone project, gani likawi ang paghatag sang sensitibo nga '
              'personal nga impormasyon nga labaw sa kinahanglan sa pagparehistro.',
    },
    'privacy_5_heading': {
      AppLanguage.english: 'Your rights',
      AppLanguage.filipino: 'Ang iyong mga karapatan',
      AppLanguage.hiligaynon: 'Ang imo mga kinamatarong',
    },
    'privacy_5_body': {
      AppLanguage.english:
          'In line with the Philippine Data Privacy Act of 2012 (RA 10173), you may request access '
              'to, correction of, or deletion of your personal data at any time by reaching out '
              'through Contact Us.',
      AppLanguage.filipino:
          'Alinsunod sa Data Privacy Act of 2012 ng Pilipinas (RA 10173), maaari kang humiling na '
              'makita, maitama, o mabura ang iyong personal na datos anumang oras sa pamamagitan ng '
              'Contact Us.',
      AppLanguage.hiligaynon:
          'Suno sa Data Privacy Act of 2012 sang Pilipinas (RA 10173), mahimo ka mangayo nga makita, '
              'matadlong, ukon mapanas ang imo personal nga datos bisan san-o paagi sa Contact Us.',
    },
    'privacy_6_heading': {
      AppLanguage.english: 'Changes to this policy',
      AppLanguage.filipino: 'Mga pagbabago sa patakarang ito',
      AppLanguage.hiligaynon: 'Mga pagbag-o sa sini nga palisiya',
    },
    'privacy_6_body': {
      AppLanguage.english:
          'This policy may be updated as the app evolves. Continued use of DriverLingo after changes '
              'are posted means you accept the updated policy.',
      AppLanguage.filipino:
          'Maaaring baguhin ang patakarang ito habang umuunlad ang app. Ang patuloy na paggamit ng '
              'DriverLingo matapos maipaskil ang mga pagbabago ay nangangahulugang tinatanggap mo ang '
              'binagong patakaran.',
      AppLanguage.hiligaynon:
          'Mahimo nga baguhon ini nga palisiya samtang nagauswag ang app. Ang padayon nga paggamit '
              'sang DriverLingo pagkatapos mapaskil ang mga pagbag-o nagakahulugan nga ginabaton mo ang '
              'ginbag-o nga palisiya.',
    },

    // Terms & Conditions page body (see termsSections in info_screen.dart).
    'terms_intro': {
      AppLanguage.english: 'By using DriverLingo, you agree to the following terms.',
      AppLanguage.filipino: 'Sa paggamit ng DriverLingo, sumasang-ayon ka sa mga sumusunod na tuntunin.',
      AppLanguage.hiligaynon: 'Sa paggamit sang DriverLingo, nagauyon ka sa mga masunod nga kasugtanan.',
    },
    'terms_1_heading': {
      AppLanguage.english: 'About this app',
      AppLanguage.filipino: 'Tungkol sa app na ito',
      AppLanguage.hiligaynon: 'Parte sa sini nga app',
    },
    'terms_1_body': {
      AppLanguage.english:
          'DriverLingo is an independent '
              'study aid developed as a BSIT capstone project by students of West Visayas State '
              'University - Pototan Campus. It is not affiliated with, endorsed by, or connected to '
              'the Land Transportation Office (LTO).',
      AppLanguage.filipino:
          'Ang DriverLingo ay isang malayang pantulong sa pag-aaral na binuo bilang BSIT capstone '
              'project ng mga estudyante ng West Visayas State University - Pototan Campus. Hindi ito '
              'kaanib, ineendorso, o konektado sa Land Transportation Office (LTO).',
      AppLanguage.hiligaynon:
          'Ang DriverLingo isa ka independyente nga bulig sa pagtuon nga ginhimo subong BSIT capstone '
              'project sang mga estudyante sang West Visayas State University - Pototan Campus. Indi ini '
              'kaupod, ginaendorso, ukon konektado sa Land Transportation Office (LTO).',
    },
    'terms_2_heading': {
      AppLanguage.english: 'Content accuracy',
      AppLanguage.filipino: 'Katumpakan ng nilalaman',
      AppLanguage.hiligaynon: 'Kasigurohan sang sulod',
    },
    'terms_2_body': {
      AppLanguage.english:
          'We strive to keep questions, answers, and explanations accurate, but some entries are '
              'still undergoing verification against official LTO references. DriverLingo is meant to '
              'complement, not replace, official LTO reviewer materials - always confirm critical '
              'information with an authoritative source before your actual exam.',
      AppLanguage.filipino:
          'Sinisikap naming panatilihing tama ang mga tanong, sagot, at paliwanag, ngunit ang ilan ay '
              'sinusuri pa laban sa opisyal na sanggunian ng LTO. Ang DriverLingo ay pandagdag lamang at '
              'hindi kapalit ng opisyal na reviewer ng LTO - laging kumpirmahin ang mahahalagang impormasyon '
              'sa mapagkakatiwalaang sanggunian bago ang iyong aktwal na pagsusulit.',
      AppLanguage.hiligaynon:
          'Ginatinguhaan namon nga husto ang mga pamangkot, sabat, kag paathag, pero ang iban ginausisa '
              'pa batok sa opisyal nga reperensya sang LTO. Ang DriverLingo dugang lamang kag indi '
              'bulig-ilis sa opisyal nga reviewer sang LTO - pirme kumpirmaha ang importante nga impormasyon '
              'sa masaligan nga reperensya antes sang imo aktwal nga ekzaminasyon.',
    },
    'terms_3_heading': {
      AppLanguage.english: 'Your account',
      AppLanguage.filipino: 'Ang iyong account',
      AppLanguage.hiligaynon: 'Ang imo account',
    },
    'terms_3_body': {
      AppLanguage.english:
          'You are responsible for the accuracy of the information you provide and for keeping your '
              'login credentials secure. Do not share your account with others.',
      AppLanguage.filipino:
          'Responsibilidad mo ang katumpakan ng impormasyong ibinibigay mo at ang pag-iingat sa iyong '
              'login credentials. Huwag ibahagi ang iyong account sa iba.',
      AppLanguage.hiligaynon:
          'Responsibilidad mo ang kasigurohan sang impormasyon nga imo ginahatag kag ang pag-amlig sang '
              'imo login credentials. Indi pag-ipaambit ang imo account sa iban.',
    },
    'terms_4_heading': {
      AppLanguage.english: 'Acceptable use',
      AppLanguage.filipino: 'Wastong paggamit',
      AppLanguage.hiligaynon: 'Husto nga paggamit',
    },
    'terms_4_body': {
      AppLanguage.english:
          'Use DriverLingo only for personal exam preparation. Do not attempt to copy, resell, or '
              'redistribute the reviewer content, and do not misuse the app in a way that disrupts '
              'the service for other users.',
      AppLanguage.filipino:
          'Gamitin lamang ang DriverLingo para sa personal na paghahanda sa pagsusulit. Huwag kopyahin, '
              'ibenta muli, o ipamahagi ang nilalaman ng reviewer, at huwag gamitin nang mali ang app sa '
              'paraang nakakaabala sa serbisyo para sa ibang gumagamit.',
      AppLanguage.hiligaynon:
          'Gamita lamang ang DriverLingo para sa personal nga paghanda sa ekzaminasyon. Indi pagkopyaha, '
              'pagbaligya liwat, ukon pagpanagtag ang sulod sang reviewer, kag indi paggamita sing sala ang '
              'app sa paagi nga nagaganggang sa serbisyo para sa iban nga nagagamit.',
    },
    'terms_5_heading': {
      AppLanguage.english: 'Limitation of liability',
      AppLanguage.filipino: 'Limitasyon ng pananagutan',
      AppLanguage.hiligaynon: 'Limitasyon sang responsibilidad',
    },
    'terms_5_body': {
      AppLanguage.english:
          'DriverLingo is provided as a study tool, "as is," with no guarantee of exam results. The '
              'development team is not liable for outcomes of your actual LTO exam or for decisions '
              'made based solely on this app\'s content.',
      AppLanguage.filipino:
          'Ibinibigay ang DriverLingo bilang kasangkapan sa pag-aaral, "as is," nang walang garantiya sa '
              'resulta ng pagsusulit. Walang pananagutan ang development team sa resulta ng iyong aktwal na '
              'LTO exam o sa mga desisyong batay lamang sa nilalaman ng app na ito.',
      AppLanguage.hiligaynon:
          'Ginahatag ang DriverLingo subong gamit sa pagtuon, "as is," nga wala sing garantiya sa resulta '
              'sang ekzaminasyon. Wala sing responsibilidad ang development team sa resulta sang imo aktwal '
              'nga LTO exam ukon sa mga desisyon nga nakabase lamang sa sulod sang sini nga app.',
    },
    'terms_6_heading': {
      AppLanguage.english: 'Changes to these terms',
      AppLanguage.filipino: 'Mga pagbabago sa mga tuntuning ito',
      AppLanguage.hiligaynon: 'Mga pagbag-o sa sini nga mga kasugtanan',
    },
    'terms_6_body': {
      AppLanguage.english:
          'These terms may be updated as the app is improved. Continued use of the app after changes '
              'are posted means you accept the updated terms.',
      AppLanguage.filipino:
          'Maaaring baguhin ang mga tuntuning ito habang pinapabuti ang app. Ang patuloy na paggamit ng '
              'app matapos maipaskil ang mga pagbabago ay nangangahulugang tinatanggap mo ang binagong '
              'mga tuntunin.',
      AppLanguage.hiligaynon:
          'Mahimo nga baguhon ini nga mga kasugtanan samtang ginapauswag ang app. Ang padayon nga '
              'paggamit sang app pagkatapos mapaskil ang mga pagbag-o nagakahulugan nga ginabaton mo ang '
              'ginbag-o nga mga kasugtanan.',
    },

    // FAQs page (see faq_screen.dart). Keys faq_<n>_q / faq_<n>_a.
    'faq_1_q': {
      AppLanguage.english: 'What is DriverLingo?',
      AppLanguage.filipino: 'Ano ang DriverLingo?',
      AppLanguage.hiligaynon: 'Ano ang DriverLingo?',
    },
    'faq_1_a': {
      AppLanguage.english:
          'DriverLingo (LTO Exam Reviewer Mobile App with Hiligaynon Translation) is a mock-exam reviewer '
              'that helps aspiring drivers prepare for the LTO written exam in English, Filipino, or Hiligaynon.',
      AppLanguage.filipino:
          'Ang DriverLingo (LTO Exam Reviewer Mobile App with Hiligaynon Translation) ay isang mock-exam '
              'reviewer na tumutulong sa mga naghahangad na drayber na maghanda para sa nakasulat na '
              'pagsusulit ng LTO sa Ingles, Filipino, o Hiligaynon.',
      AppLanguage.hiligaynon:
          'Ang DriverLingo (LTO Exam Reviewer Mobile App with Hiligaynon Translation) isa ka mock-exam '
              'reviewer nga nagabulig sa mga nagahandom nga drayber nga maghanda para sa sinulatan nga '
              'ekzaminasyon sang LTO sa Ingles, Filipino, ukon Hiligaynon.',
    },
    'faq_2_q': {
      AppLanguage.english: 'Is this an official LTO app?',
      AppLanguage.filipino: 'Opisyal na app ba ito ng LTO?',
      AppLanguage.hiligaynon: 'Opisyal bala ini nga app sang LTO?',
    },
    'faq_2_a': {
      AppLanguage.english:
          'No. DriverLingo is an independent study aid built as a BSIT capstone project by students of '
              'West Visayas State University - Pototan Campus. It is not affiliated with, endorsed by, or '
              'connected to the Land Transportation Office.',
      AppLanguage.filipino:
          'Hindi. Ang DriverLingo ay isang malayang pantulong sa pag-aaral na binuo bilang BSIT capstone '
              'project ng mga estudyante ng West Visayas State University - Pototan Campus. Hindi ito '
              'kaanib, ineendorso, o konektado sa Land Transportation Office.',
      AppLanguage.hiligaynon:
          'Indi. Ang DriverLingo isa ka independyente nga bulig sa pagtuon nga ginhimo subong BSIT '
              'capstone project sang mga estudyante sang West Visayas State University - Pototan Campus. '
              'Indi ini kaupod, ginaendorso, ukon konektado sa Land Transportation Office.',
    },
    'faq_3_q': {
      AppLanguage.english: 'Why Hiligaynon?',
      AppLanguage.filipino: 'Bakit Hiligaynon?',
      AppLanguage.hiligaynon: 'Ngaa Hiligaynon?',
    },
    'faq_3_a': {
      AppLanguage.english:
          'Existing LTO reviewers are only available in English and Filipino, which leaves out '
              'Ilonggo/Hiligaynon speakers who are less comfortable in either language. DriverLingo '
              'translates every question, choice, and explanation into Hiligaynon so more drivers can '
              'prepare with confidence.',
      AppLanguage.filipino:
          'Ang mga kasalukuyang LTO reviewer ay nasa Ingles at Filipino lamang, kaya naiiwan ang mga '
              'nagsasalita ng Ilonggo/Hiligaynon na hindi gaanong komportable sa dalawang wikang ito. '
              'Isinasalin ng DriverLingo ang bawat tanong, pagpipilian, at paliwanag sa Hiligaynon para '
              'mas maraming drayber ang makapaghanda nang may kumpiyansa.',
      AppLanguage.hiligaynon:
          'Ang mga reviewer sang LTO subong ara lamang sa Ingles kag Filipino, gani nabilin ang mga '
              'Ilonggo/Hiligaynon nga indi tanto komportable sa duha ka lenggwahe nga ini. Ginabadbad '
              'sang DriverLingo ang kada pamangkot, kapilian, kag paathag sa Hiligaynon agod mas madamo '
              'nga drayber ang makahanda nga may kompiyansa.',
    },
    'faq_4_q': {
      AppLanguage.english: 'Does the app work offline?',
      AppLanguage.filipino: 'Gumagana ba ang app kahit offline?',
      AppLanguage.hiligaynon: 'Nagagana bala ang app bisan offline?',
    },
    'faq_4_a': {
      AppLanguage.english:
          'Yes. Once you have opened the reviewer questions at least once while online, they are cached '
              'on your device so you can keep studying without an internet connection.',
      AppLanguage.filipino:
          'Oo. Kapag nabuksan mo na ang mga tanong kahit isang beses habang online, maiimbak ang mga ito '
              'sa iyong device para makapag-aral ka kahit walang internet.',
      AppLanguage.hiligaynon:
          'Huo. Kon nabuksan mo na ang mga pamangkot bisan isa ka beses samtang online, matipig ini sa '
              'imo device agod makatuon ka bisan wala sing internet.',
    },
    'faq_5_q': {
      AppLanguage.english: 'Is DriverLingo free?',
      AppLanguage.filipino: 'Libre ba ang DriverLingo?',
      AppLanguage.hiligaynon: 'Libre bala ang DriverLingo?',
    },
    'faq_5_a': {
      AppLanguage.english: 'Yes, DriverLingo is free to use.',
      AppLanguage.filipino: 'Oo, libre ang paggamit ng DriverLingo.',
      AppLanguage.hiligaynon: 'Huo, libre ang paggamit sang DriverLingo.',
    },
    'faq_6_q': {
      AppLanguage.english: 'How accurate are the questions and answers?',
      AppLanguage.filipino: 'Gaano katama ang mga tanong at sagot?',
      AppLanguage.hiligaynon: 'Daw ano ka husto ang mga pamangkot kag sabat?',
    },
    'faq_6_a': {
      AppLanguage.english:
          'Content is sourced from LTO reviewer materials, but some entries are still being verified '
              'against official references. If you notice an answer that looks incorrect, please let us '
              'know through Contact Us so it can be corrected.',
      AppLanguage.filipino:
          'Kinuha ang nilalaman mula sa mga reviewer ng LTO, ngunit ang ilan ay sinusuri pa laban sa '
              'opisyal na sanggunian. Kung may mapansin kang sagot na mukhang mali, ipaalam sa amin sa '
              'Contact Us para maitama ito.',
      AppLanguage.hiligaynon:
          'Ang sulod ginkuha halin sa mga reviewer sang LTO, pero ang iban ginausisa pa batok sa opisyal '
              'nga reperensya. Kon may makita ka nga sabat nga daw sala, ipahibalo sa amon paagi sa '
              'Contact Us agod matadlong ini.',
    },
    'faq_7_q': {
      AppLanguage.english: 'Can I retake a mock exam?',
      AppLanguage.filipino: 'Puwede ko bang ulitin ang mock exam?',
      AppLanguage.hiligaynon: 'Puwede ko bala liwaton ang mock exam?',
    },
    'faq_7_a': {
      AppLanguage.english:
          'Yes, you can take as many mock exams as you like. Note that this is different from the real '
              'LTO exam, where failing three official attempts means a two-year wait before you can reapply.',
      AppLanguage.filipino:
          'Oo, maaari kang kumuha ng mock exam nang ilang beses mo man gusto. Tandaan na iba ito sa '
              'totoong LTO exam, kung saan ang pagbagsak sa tatlong opisyal na pagsubok ay nangangahulugang '
              'maghihintay ka ng dalawang taon bago muling makapag-apply.',
      AppLanguage.hiligaynon:
          'Huo, mahimo ka magkuha sang mock exam bisan pila ka beses mo gusto. Tandaan nga lain ini sa '
              'matuod nga LTO exam, diin ang pagbagsak sa tatlo ka opisyal nga pagtilaw nagakahulugan nga '
              'magahulat ka sang duha ka tuig antes ka makaaplay liwat.',
    },
    'faq_8_q': {
      AppLanguage.english: 'Some Hiligaynon text still shows English or Filipino words - why?',
      AppLanguage.filipino: 'Bakit may mga salitang Ingles o Filipino pa rin sa Hiligaynon na teksto?',
      AppLanguage.hiligaynon: 'Ngaa may mga tinaga nga Ingles ukon Filipino pa sa Hiligaynon nga teksto?',
    },
    'faq_8_a': {
      AppLanguage.english:
          'A few technical and legal terms used in traffic law do not have a direct Hiligaynon equivalent, '
              'so they are kept in their original language for clarity.',
      AppLanguage.filipino:
          'May ilang teknikal at legal na termino sa batas trapiko na walang direktang katumbas sa '
              'Hiligaynon, kaya pinanatili ang mga ito sa orihinal na wika para malinaw.',
      AppLanguage.hiligaynon:
          'May pila ka teknikal kag legal nga termino sa layi sang trapiko nga wala sing direkta nga '
              'katumbas sa Hiligaynon, gani ginpabilin ini sa orihinal nga lenggwahe agod maathag.',
    },
    'faq_9_q': {
      AppLanguage.english: 'What devices does DriverLingo support?',
      AppLanguage.filipino: 'Anong mga device ang suportado ng DriverLingo?',
      AppLanguage.hiligaynon: 'Ano nga mga device ang ginasuportahan sang DriverLingo?',
    },
    'faq_9_a': {
      AppLanguage.english: 'DriverLingo currently runs on Android phones and tablets.',
      AppLanguage.filipino: 'Sa ngayon, gumagana ang DriverLingo sa mga Android phone at tablet.',
      AppLanguage.hiligaynon: 'Subong, nagagana ang DriverLingo sa mga Android phone kag tablet.',
    },
    'faq_10_q': {
      AppLanguage.english: 'How do I switch between light and dark mode?',
      AppLanguage.filipino: 'Paano lumipat sa light at dark mode?',
      AppLanguage.hiligaynon: 'Paano magbalhin sa light kag dark mode?',
    },
    'faq_10_a': {
      AppLanguage.english: 'Go to Settings > Appearance and choose System default, Light, or Dark.',
      AppLanguage.filipino: 'Pumunta sa Mga Setting > Appearance at piliin ang System default, Light, o Dark.',
      AppLanguage.hiligaynon: 'Kadto sa Mga Setting > Appearance kag pilia ang System default, Light, ukon Dark.',
    },

    // Contact Us page (see contact_screen.dart).
    'contact_intro': {
      AppLanguage.english:
          'DriverLingo (LTO Exam Reviewer Mobile App with Hiligaynon Translation) is a mock-exam '
              'reviewer that helps aspiring drivers prepare for the LTO written exam in English, '
              'Filipino, or Hiligaynon. For questions, feedback, or to flag a question/answer that '
              'needs review, reach out to any of the developers below.',
      AppLanguage.filipino:
          'Ang DriverLingo (LTO Exam Reviewer Mobile App with Hiligaynon Translation) ay isang mock-exam '
              'reviewer na tumutulong sa mga naghahangad na drayber na maghanda para sa nakasulat na '
              'pagsusulit ng LTO sa Ingles, Filipino, o Hiligaynon. Para sa mga tanong, puna, o para '
              'iulat ang tanong/sagot na kailangang suriin, makipag-ugnayan sa alinman sa mga developer sa ibaba.',
      AppLanguage.hiligaynon:
          'Ang DriverLingo (LTO Exam Reviewer Mobile App with Hiligaynon Translation) isa ka mock-exam '
              'reviewer nga nagabulig sa mga nagahandom nga drayber nga maghanda para sa sinulatan nga '
              'ekzaminasyon sang LTO sa Ingles, Filipino, ukon Hiligaynon. Para sa mga pamangkot, '
              'komento, ukon para ireport ang pamangkot/sabat nga kinahanglan usisaon, kontaka ang bisan '
              'sin-o sa mga developer sa idalom.',
    },
    'contact_team': {
      AppLanguage.english: 'Development team',
      AppLanguage.filipino: 'Development team',
      AppLanguage.hiligaynon: 'Development team',
    },
    'contact_copied': {
      AppLanguage.english: 'Copied {email}',
      AppLanguage.filipino: 'Nakopya ang {email}',
      AppLanguage.hiligaynon: 'Nakopya ang {email}',
    },
    'settings_contact': {
      AppLanguage.english: 'Contact us',
      AppLanguage.filipino: 'Kontakin kami',
      AppLanguage.hiligaynon: 'Kontaka kami'
    },
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
