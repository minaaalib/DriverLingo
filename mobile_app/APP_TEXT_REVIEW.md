# DriverLingo — full app text review

Every piece of wording in the app, exactly as it appears in the code today — grouped by language: the complete English wording first (every screen, Welcome through the last page), then the complete Filipino (Tagalog) wording, then the complete Hiligaynon wording. Where a page has no Filipino or Hiligaynon version, that's called out explicitly under that language's section instead of being skipped, so the page-by-page structure stays the same in all three.

The same content also lives in machine-readable form in `app_text_content_by_language.json`, kept in sync with this file.

Mark this up however's easiest — inline comments, rewritten lines, strike-throughs — and send it back or just tell me what to change; I'll apply the edits into the actual code (`lib/core/app_strings.dart` for short UI strings, the relevant screen file for long-form pages) and keep the JSON export in sync.

---

## App identity (same in every language, not translated)

| Where | Text |
|---|---|
| App name / window title | DriverLingo |
| Brand wordmark (Welcome & Login screens) | DriverLingo |
| Profile → App version | DriverLingo v1.0.0 |

---

# ENGLISH

## 1. Welcome screen

| Element | Text |
|---|---|
| Badge | LTO Reviewer |
| Hero quote 1 | Every Mile Begins With Confidence. |
| Hero quote 2 | Master The Road. Master The Exam. |
| Hero quote 3 | Your License, Your Language. |
| Hero quote 4 | Practice Today. Drive Tomorrow. |
| Language section label | CHOOSE YOUR LANGUAGE |
| Button | Continue |

## 2. "Before you continue" consent dialog

| Element | Text |
|---|---|
| Title | Before you continue |
| Message | By continuing, you agree to DriverLingo's Terms & Conditions and Privacy Policy. |
| `[Privacy policy]` chip | Privacy policy |
| `[Terms & conditions]` chip | Terms & conditions |
| **[ I Agree ]** button | I Agree |
| Cancel button | Cancel |

## 3. Login screen

| Element | Text |
|---|---|
| Brand wordmark | DriverLingo |
| Button | Continue with Google |
| Loading state | Signing in... |

*(If Google sign-in fails, the screen also shows an inline error banner — its text comes straight from the API error response, so it isn't fixed copy and isn't listed here.)*

## 4. Onboarding walkthrough (first-time users only, mandatory)

Shown once, right after a new user's first login, before they can reach the rest of the app.

| Element | Text |
|---|---|
| Title | Welcome to DriverLingo! |
| Subtitle | Before your first practice exam, here's a quick look at how everything works. |
| Button | Start Practice Exam *(→ starts a 5-item, 5-minute mock exam)* |
| Button, loading state | Starting... |

**Six walkthrough steps** *(same copy as "How the system works" in Settings, see §11a)*
> 1. Create an account
> 2. Choose your language
> 3. Take a mock exam
> 4. Review your results
> 5. Track your progress
> 6. Study offline
> Behind the scenes

## 5. Bottom navigation

> Home · History · Profile · Settings

## 6. Home screen

| Element | Text |
|---|---|
| Greeting | "Kumusta, {name}!" *(hardcoded Filipino greeting word, not translated even in English mode — worth a look)* |
| Subtitle | Ready to practice? |
| Fallback name if none set | Driver |
| Readiness card, returning user | Keep up the momentum! |
| Readiness card, first-time | Take your first mock exam! |
| No attempts yet | No attempts yet |
| Best score label | Best |
| Streak | {n}-day streak |
| Section label | OVERALL READINESS |
| Category picker label | Exam category |
| Category subtitle | {count} items · LTO standard |
| Stat box | QUESTIONS |
| Stat box | TIMER |
| Primary button | Start Mock Exam |
| Loading state | Starting... |
| Bottom sheet title | Number of questions |
| Bottom sheet switch | Use a custom number |
| Value labels | Custom / Standard |
| Bottom sheet button | Done |

## 7. Exam screen

| Element | Text |
|---|---|
| Header | Question {a} of {b} |
| Translate menu tooltip | Translate |
| Nav buttons | Previous / Next |
| Submit button (toolbar) | Submit |
| Submit loading | Submitting... |
| Submit confirm dialog title | Submit exam? |
| Submit confirm body | You answered {a} of {b} questions. Unanswered questions will be marked incorrect. Submit anyway? |
| Confirm dialog buttons | Keep answering / Submit |
| Leave confirm dialog title | Leave exam? |
| Leave confirm dialog body | Your progress on this attempt will be lost. |
| Leave confirm dialog buttons | Stay / Leave |

## 8. Results screen

| Element | Text |
|---|---|
| Back button | Back to Home |
| Translate tooltip | Translate the review |
| Page title | Exam Results |
| Pass badge | PASSED |
| Fail badge | NEEDS MORE REVIEW |
| Section label | Review your answers |
| Retake button | Take Test Again |

## 9. History screen

| Element | Text |
|---|---|
| Page title | Exam History |
| Error state | Failed to load history. |
| Empty state | No mock exams taken yet. Go take one! |
| Score suffix | correct |

## 10. Profile screen

| Element | Text |
|---|---|
| Page title | Profile |
| Role badges | Admin / Examinee |
| Verified badge | Verified |
| Section label | About |
| Row label | Languages |
| Row value | English · Filipino · Hiligaynon |
| Row label | Content |
| Row value | {n} LTO reviewer questions |
| Row label | App |
| Row value | DriverLingo v1.0.0 |
| Button | Log out |
| Confirm dialog title | Log out? |
| Confirm dialog body | You can log back in any time. |
| Cancel button (shared) | Cancel |

## 11. Settings screen

| Element | Text |
|---|---|
| Page title | Settings |
| Section label | Appearance |
| Theme options | System default / Light / Dark |
| Section label | Reviewer language |
| Section label | Support & legal |
| Row | How the system works |
| Row | FAQs |
| Row | Privacy policy |
| Row | Terms & conditions |
| Row | Contact us |

### 11a. "How the system works" (full page)

> DriverLingo helps aspiring drivers prepare for the LTO non-professional and professional driver's license exams in English, Filipino, or Hiligaynon.

> **1. Create an account** — Sign up with your name, email, and a password, or log in to an existing account. Your account keeps your exam history and progress saved across sessions.
>
> **2. Choose your language** — Pick English, Filipino, or Hiligaynon at any time. Every question, answer choice, and explanation is available in all three languages so you can review in whichever one you understand best.
>
> **3. Take a mock exam** — Answer timed practice questions drawn from the LTO reviewer question bank, covering road signs, traffic laws and regulations, and safe driving practices for non-professional and professional license categories.
>
> **4. Review your results** — After submitting, see your score, your pass/fail status, and a full breakdown of every question with the correct answer and an explanation – so mistakes turn into something learned.
>
> **5. Track your progress** — Every attempt is saved to your Exam History, so you can look back at previous scores and see how you're improving over time.
>
> **6. Study offline** — Once you've opened the reviewer questions while online, they're cached on your device so you can keep practicing even without an internet connection.
>
> **Behind the scenes** — Administrators maintain and update the question bank and manage user accounts to keep the reviewer accurate and up to date.

*(Note: this same copy is reused verbatim in the mandatory onboarding walkthrough, §4 — one edit here updates both.)*

### 11b. Terms & Conditions and Privacy Policy (full page)

Exact text currently live in the app (`lib/screens/settings_screen.dart` — `TermsScreen` and `PrivacyPolicyScreen`).

#### Terms & Conditions

**Intro**
> By using DriverLingo, you agree to the following terms.

**About this app**
> DriverLingo is an independent study aid developed as a BSIT capstone project by students of West Visayas State University – Pototan Campus. It is not affiliated with, endorsed by, or connected to the Land Transportation Office (LTO).

**Content accuracy**
> We strive to keep questions, answers, and explanations accurate, but some entries are still undergoing verification against official LTO references. DriverLingo is meant to complement, not replace, official LTO reviewer materials – always confirm critical information with an authoritative source before your actual exam.

**Your account**
> You are responsible for the accuracy of the information you provide and for keeping your login credentials secure. Do not share your account with others.

**Acceptable use**
> Use DriverLingo only for personal exam preparation. Do not attempt to copy, resell, or redistribute the reviewer content, and do not misuse the app in a way that disrupts the service for other users.

**Limitation of liability**
> DriverLingo is provided as a study tool, "as is," with no guarantee of exam results. The development team is not liable for outcomes of your actual LTO exam or for decisions made based solely on this app's content.

**Changes to these terms**
> These terms may be updated as the app is improved. Continued use of the app after changes are posted means you accept the updated terms.

#### Privacy Policy

**Intro**
> We know studying for your license already means sharing enough paperwork with the government. Here's exactly what DriverLingo collects and why.

**Information we collect**
> When you register, we collect your name, email address, and a securely hashed password. As you use the app, we also store your chosen reviewer language and your mock exam attempts (answers, scores, and timestamps).

**How we use it**
> Your account details let you log in and keep your progress across devices. Your exam history lets you review past attempts and track improvement. We do not use your data for advertising, and we do not sell or share it with third parties.

**Offline data**
> Reviewer questions downloaded for offline use are cached locally on your device only, and are not shared with anyone else.

**Data storage & security**
> Your information is stored on our servers with hashed passwords and access limited to the development team maintaining the app. This app was built as an academic capstone project, so please avoid submitting sensitive personal information beyond what registration requires.

**Your rights**
> In line with the Philippine Data Privacy Act of 2012 (RA 10173), you may request access to, correction of, or deletion of your personal data at any time by reaching out through Contact Us.

**Changes to this policy**
> This policy may be updated as the app evolves. Continued use of DriverLingo after changes are posted means you accept the updated policy.

## 12. FAQs (full page)

**Page title:** FAQs

> **What is DriverLingo?**
> DriverLingo (LTO Exam Reviewer Mobile App with Hiligaynon Translation) is a mock-exam reviewer that helps aspiring drivers prepare for the LTO written exam in English, Filipino, or Hiligaynon.

> **Is this an official LTO app?**
> No. DriverLingo is an independent study aid built as a BSIT capstone project by students of West Visayas State University – Pototan Campus. It is not affiliated with, endorsed by, or connected to the Land Transportation Office.

> **Why Hiligaynon?**
> Existing LTO reviewers are only available in English and Filipino, which leaves out Ilonggo/Hiligaynon speakers who are less comfortable in either language. DriverLingo translates every question, choice, and explanation into Hiligaynon so more drivers can prepare with confidence.

> **Does the app work offline?**
> Yes. Once you have opened the reviewer questions at least once while online, they are cached on your device so you can keep studying without an internet connection.

> **Is DriverLingo free?**
> Yes, DriverLingo is free to use.

> **How accurate are the questions and answers?**
> Content is sourced from LTO reviewer materials, but some entries are still being verified against official references. If you notice an answer that looks incorrect, please let us know through Contact Us so it can be corrected.

> **Can I retake a mock exam?**
> Yes, you can take as many mock exams as you like. Note that this is different from the real LTO exam, where failing three official attempts means a two-year wait before you can reapply.

> **Some Hiligaynon text still shows English or Filipino words – why?**
> A few technical and legal terms used in traffic law do not have a direct Hiligaynon equivalent, so they are kept in their original language for clarity.

> **What devices does DriverLingo support?**
> DriverLingo currently runs on Android phones and tablets.

> **How do I switch between light and dark mode?**
> Go to Settings > Appearance and choose System default, Light, or Dark.

## 13. Contact Us (full page)

**Page title:** Contact Us

> DriverLingo (LTO Exam Reviewer Mobile App with Hiligaynon Translation) is a mock-exam reviewer that helps aspiring drivers prepare for the LTO written exam in English, Filipino, or Hiligaynon. For questions, feedback, or to flag a question/answer that needs review, reach out to any of the developers below.

**Section label:** Development team

**Team list:**
> Dr. Rosie Jane P. Siosan — rosiejane.siosan@wvsu.edu.ph

**Copy-email toast:** Copied {email}

## 14. Reviewer screen (untimed "browse the question bank" mode)

*(Hardcoded — not run through the translation table, so this is the only version that ever shows)*

> Reviewer *(page heading)*
> Failed to load the reviewer. *(error state)*
> No questions available yet. *(empty state)*

---

# FILIPINO (TAGALOG)

## 1. Welcome screen

| Element | Text |
|---|---|
| Badge | LTO Reviewer |
| Hero quote 1 | Bawat Milya ay Nagsisimula sa Tiwala. |
| Hero quote 2 | Bihasain ang Daan. Bihasain ang Pagsusulit. |
| Hero quote 3 | Iyong Lisensya, Iyong Wika. |
| Hero quote 4 | Magsanay Ngayon. Magmaneho Bukas. |
| Language section label | PILIIN ANG WIKA |
| Button | Magpatuloy |

## 2. "Before you continue" consent dialog

| Element | Text |
|---|---|
| Title | Bago magpatuloy |
| Message | Sa pagpapatuloy, sumasang-ayon ka sa Mga Tuntunin at Kundisyon at Patakarang Pampribado ng DriverLingo. |
| `[Privacy policy]` chip | Patakarang Pampribado |
| `[Terms & conditions]` chip | Mga Tuntunin at Kundisyon |
| **[ I Agree ]** button | Sumasang-ayon Ako |
| Cancel button | Kanselahin |

## 3. Login screen

| Element | Text |
|---|---|
| Brand wordmark | DriverLingo *(not translated)* |
| Button | Magpatuloy gamit ang Google |
| Loading state | Naglo-log in... |

## 4. Onboarding walkthrough

| Element | Text |
|---|---|
| Title | Maligayang pagdating sa DriverLingo! |
| Subtitle | Bago ang iyong unang pang-ensayong pagsusulit, narito ang mabilisang gabay kung paano gumagana ang lahat. |
| Button | Simulan ang Pang-ensayong Pagsusulit |
| Button, loading state | Sinisimulan... |

**Six walkthrough steps** *(DRAFT — not yet in app; page currently always shows the English steps from §4)*
> 1. Gumawa ng account
> 2. Piliin ang iyong wika
> 3. Kumuha ng Pang-ensayong Pagsusulit
> 4. Suriin ang iyong mga resulta
> 5. Subaybayan ang iyong progreso
> 6. Mag-aral nang offline
> Sa likod ng eksena

## 5. Bottom navigation

> Home · Kasaysayan · Profile · Mga Setting

## 6. Home screen

| Element | Text |
|---|---|
| Greeting | "Kumusta, {name}!" *(hardcoded, same in every language)* |
| Subtitle | Handa nang magsanay? |
| Fallback name if none set | Drayber |
| Readiness card, returning user | Ipagpatuloy ang sigla! |
| Readiness card, first-time | Kunin ang iyong unang Pang-ensayong Pagsusulit! |
| No attempts yet | Wala pang tangka |
| Best score label | Pinakamataas |
| Streak | {n} sunod-sunod na araw |
| Section label | KABUUANG KAHANDAAN |
| Category picker label | Kategorya ng pagsusulit |
| Category subtitle | {count} items · pamantayan ng LTO |
| Stat box | MGA TANONG |
| Stat box | ORAS |
| Primary button | Simulan ang Pang-ensayong Pagsusulit |
| Loading state | Sinisimulan... |
| Bottom sheet title | Bilang ng mga tanong |
| Bottom sheet switch | Gumamit ng custom na bilang |
| Value labels | Custom / Standard |
| Bottom sheet button | Tapos na |

## 7. Exam screen

| Element | Text |
|---|---|
| Header | Tanong {a} ng {b} |
| Translate menu tooltip | Isalin |
| Nav buttons | Nakaraan / Susunod |
| Submit button (toolbar) | Ipasa |
| Submit loading | Pinapasa... |
| Submit confirm dialog title | Isumite ang pagsusulit? |
| Submit confirm body | Nasagot mo ang {a} sa {b} na tanong. Ang mga hindi nasagot na tanong ay ituturing na mali. Ipasa pa rin? |
| Confirm dialog buttons | Ipagpatuloy ang pagsagot / Ipasa |
| Leave confirm dialog title | Liliban sa pagsusulit? |
| Leave confirm dialog body | Mawawala ang iyong progreso sa pagsusulit na ito. |
| Leave confirm dialog buttons | Manatili / Umalis |

*(Worth a look: the toolbar Submit button reads "I-submit" while the confirm dialog's Submit button reads "Isumite" — same English word, different Filipino translation in two places.)*

## 8. Results screen

| Element | Text |
|---|---|
| Back button | Bumalik sa Home |
| Translate tooltip | Isalin ang rebyu |
| Page title | Resulta ng Pagsusulit |
| Pass badge | PUMASA |
| Fail badge | KAILANGAN PA NG REBYU |
| Section label | Suriin ang iyong mga sagot |
| Retake button | Ulitin ang Pagsusulit |

## 9. History screen

| Element | Text |
|---|---|
| Page title | Kasaysayan ng Pagsusulit |
| Error state | Hindi na-load ang kasaysayan. |
| Empty state | Wala ka pang nakuhang pang-ensayong pagsusulit. Kumuha na! |
| Score suffix | tama |

## 10. Profile screen

| Element | Text |
|---|---|
| Page title | Profile |
| Role badges | Admin / Tagakuha ng Pagsusulit |
| Verified badge | Beripikado |
| Section label | Tungkol |
| Row label | Mga Wika |
| Row value | English · Filipino · Hiligaynon *(not translated)* |
| Row label | Nilalaman |
| Row value | {n} tanong sa LTO reviewer |
| Row label | App |
| Row value | DriverLingo v1.0.0 *(not translated)* |
| Button | Mag-log out |
| Confirm dialog title | Mag-log out? |
| Confirm dialog body | Puwede kang mag-log in ulit anumang oras. |
| Cancel button (shared) | Kanselahin |

## 11. Settings screen

| Element | Text |
|---|---|
| Page title | Mga Setting |
| Section label | Hitsura |
| Theme options | Default ng sistema / Maliwanag / Madilim |
| Section label | Wika ng Reviewer |
| Section label | Suporta at Legal |
| Row | Paano gumagana ang sistema |
| Row | FAQs |
| Row | Patakarang Pampribado |
| Row | Mga Tuntunin at Kundisyon |
| Row | Kontakin kami |

### 11a. "How the system works" *(DRAFT translation — not yet in app; page currently shows the English text from §11a)*

> Tinutulungan ng DriverLingo ang mga naghahangad na drayber na maghanda para sa LTO non-professional at professional na pagsusulit sa lisensya sa pagmamaneho, sa English, Filipino, o Hiligaynon.

> **1. Gumawa ng account** — Mag-sign up gamit ang iyong pangalan, email, at password, o mag-log in sa umiiral nang account. Ang iyong account ang nag-iingat sa iyong kasaysayan ng pagsusulit at progreso sa bawat pagbisita.
>
> **2. Piliin ang iyong wika** — Pumili ng English, Filipino, o Hiligaynon anumang oras. Available ang bawat tanong, pagpipilian sa sagot, at paliwanag sa lahat ng tatlong wika para makapag-rebyu ka sa wikang pinakanauunawaan mo.
>
> **3. Kumuha ng Pang-ensayong Pagsusulit** — Sagutin ang mga nakaoras na pang-ensayong tanong mula sa LTO reviewer question bank, na sumasaklaw sa mga road sign, batas at regulasyon sa trapiko, at mga ligtas na gawi sa pagmamaneho para sa non-professional at professional na kategorya ng lisensya.
>
> **4. Suriin ang iyong mga resulta** — Pagkatapos mong mag-submit, makikita mo ang iyong iskor, ang status na pasa o bagsak, at ang detalyadong breakdown ng bawat tanong kasama ang tamang sagot at paliwanag – para ang bawat mali ay maging aral.
>
> **5. Subaybayan ang iyong progreso** — Nase-save ang bawat pagsusulit sa iyong Exam History, para mabalikan mo ang mga naunang iskor at makita kung paano ka umuunlad sa paglipas ng panahon.
>
> **6. Mag-aral nang offline** — Kapag nabuksan mo na ang mga tanong ng reviewer habang online, ma-cache ang mga ito sa iyong device para makapagpatuloy kang magsanay kahit walang internet connection.
>
> **Sa likod ng eksena** — Pinapanatili at ina-update ng mga administrator ang question bank at pinamamahalaan ang mga user account para manatiling tumpak at updated ang reviewer.

### 11b. Terms & Conditions and Privacy Policy *(DRAFT translation — not yet in app; page currently shows the English text from §11b)*

#### Mga Tuntunin at Kundisyon

**Panimula**
> Sa paggamit ng DriverLingo, sumasang-ayon ka sa mga sumusunod na tuntunin.

**Tungkol sa app na ito**
> Ang DriverLingo ay isang gabay sa sariling pag-aaral na binuo bilang BSIT capstone project ng mga mag-aaral ng West Visayas State University – Pototan Campus. Hindi ito kaanib, inendorso, o konektado sa Land Transportation Office (LTO).

**Katumpakan ng Nilalaman**
> Pinagsisikapan naming panatilihing tumpak ang mga tanong, sagot, at paliwanag, ngunit may ilang entry na sinusuri pa laban sa opisyal na sanggunian ng LTO. Ang DriverLingo ay para umpisahan lamang, hindi palitan, ang opisyal na LTO reviewer materials – laging kumpirmahin ang mahahalagang impormasyon sa awtoridad na pinagmulan bago ang iyong aktwal na pagsusulit.

**Ang iyong account**
> Ikaw ang responsable sa katumpakan ng impormasyong ibinibigay mo at sa pag-iingat ng seguridad ng iyong login credentials. Huwag ibahagi ang iyong account sa iba.

**Tamang Paggamit**
> Gamitin ang DriverLingo para lamang sa personal na paghahanda sa pagsusulit. Huwag subukang kopyahin, ibenta muli, o ipamahagi ang content ng reviewer, at huwag abusuhin ang app sa paraang makakasagabal sa serbisyo para sa ibang gagamit.

**Limitasyon ng pananagutan**
> Ibinibigay ang DriverLingo bilang kagamitang pampag-aaral, "as is," nang walang garantiya sa resulta ng pagsusulit. Hindi mananagot ang development team para sa kinalabasan ng iyong aktwal na LTO exam o sa mga desisyong ginawa batay lamang sa nilalaman ng app na ito.

**Mga pagbabago sa mga tuntuning ito**
> Maaaring mabago ang mga tuntuning ito habang pinapahusay ang app. Ang patuloy na paggamit ng app pagkatapos mailathala ang mga pagbabago ay nangangahulugan na tinatanggap mo ang nabagong mga tuntunin.

#### Patakaran sa Privacy

**Panimula**
> Alam naming ang paghahanda para sa iyong lisensya ay nangangailangan na ng sapat na papeles sa gobyerno. Narito ang eksaktong kinokolekta ng DriverLingo at kung bakit.

**Impormasyong kinokolekta namin**
> Kapag nagrehistro ka, kinokolekta namin ang iyong pangalan, email address, at isang secure na naka-hash na password. Habang ginagamit mo ang app, iniimbak rin namin ang piniling mga wika mo sa reviewer at ang iyong mga pang-ensayong pagsusulit (mga sagot, iskor, at timestamp).

**Paano namin ito ginagamit**
> Ang detalye ng iyong account ang nagpapahintulot sa iyong mag-log in at mapanatili ang iyong progreso sa iba't ibang device. Ang iyong kasaysayan ng eksaminasyon ang nagpapahintulot sa iyong balikan ang mga nakaraang pagsusulit at subaybayan ang pag-unlad. Hindi namin ginagamit ang iyong datos para sa advertising, at hindi namin ito ibinebenta o ibinabahagi sa pangatlong partido.

**Offline na Datos**
> Ang mga tanong ng reviewer na na-download para sa offline na paggamit ay naka-cache lamang sa iyong device, at hindi ibinabahagi sa kahit kanino.

**Pag-iimbak ng Datos at Seguridad**
> Ang iyong impormasyon ay iniimbak sa aming mga server na may naka-hash na password at limitadong access para lamang sa development team na nangangasiwa sa app. Ang app na ito ay binuo bilang akademikong capstone project, kaya mangyaring iwasang magsumite ng sensitibong personal na impormasyon lampas sa hinihingi ng pagpaparehistro.

**Ang iyong mga karapatan**
> Alinsunod sa Philippine Data Privacy Act of 2012 (RA 10173), maaari kang humiling ng access, pagwawasto, o pagbura ng iyong personal na datos anumang oras sa pamamagitan ng Contact Us.

**Mga pagbabago sa patakarang ito**
> Maaaring mabago ang patakarang ito habang umuunlad ang app. Ang patuloy na paggamit ng DriverLingo pagkatapos mailathala ang mga pagbabago ay nangangahulugan na tinatanggap mo ang nabagong patakaran.

### 12. FAQs *(DRAFT translation — not yet in app; page currently shows the English text from §12)*

> **Ano ang DriverLingo?**
> Ang DriverLingo (LTO Exam Reviewer Mobile App with Hiligaynon Translation) ay isang pang-ensayong pagsusulit na reviewer na tumutulong sa mga naghahangad na drayber na maghanda para sa nakasulat na pagsusulit ng LTO sa English, Filipino, o Hiligaynon.

> **Opisyal ba itong app ng LTO?**
> Hindi. Ang DriverLingo ay isang gabay sa sariling pag-aaral na binuo bilang BSIT capstone project ng mga estudyante ng West Visayas State University – Pototan Campus. Hindi ito kaanib, inendorso, o konektado sa Land Transportation Office.

> **Bakit Hiligaynon?**
> Ang mga umiiral na LTO reviewer ay nasa lamang sa English at Filipino, na hindi kasama ang mga Ilonggo/Hiligaynon speaker na hindi gaanong komportable sa alinman sa dalawang wika. Isinasalin ng DriverLingo ang bawat tanong, pagpipilian, at paliwanag sa Hiligaynon para mas maraming drayber ang makapaghanda nang may kumpiyansa.

> **Gumagana ba ang app offline?**
> Oo. Kapag nabuksan mo na ang mga tanong ng reviewer nang hindi bababa sa isang beses habang online, na-cache ang mga ito sa iyong device para makapagpatuloy kang mag-aral kahit walang internet connection.

> **Libre ba ang DriverLingo?**
> Oo, libre gamitin ang DriverLingo.

> **Gaano katumpak ang mga tanong at sagot?**
> Ang nilalaman ay galing sa LTO reviewer materials, ngunit may ilang entry na sinusuri pa laban sa opisyal na sanggunian. Kung may napansin kang sagot na mukhang mali, ipaalam sa amin sa pamamagitan ng Contact Us para maitama ito.

> **Maaari ba akong ulitin ang isang pang-ensayong pagsusulit?**
> Oo, maaari kang kumuha ng kahit ilang pang-ensayong pagsusulit na gusto mo. Tandaan na iba ito sa aktwal na LTO exam, kung saan ang pagbagsak sa tatlong opisyal na pagsusulit ay nangangahulugan ng dalawang taong paghihintay bago ka muling mag-apply.

> **May mga Hiligaynon na text na nagpapakita pa rin ng English o Filipino na salita – bakit?**
> May ilang teknikal at legal na termino sa batas trapiko na walang direktang katumbas sa Hiligaynon, kaya pinapanatili ang mga ito sa orihinal nilang wika para malinaw.

> **Anong mga device ang suportado ng DriverLingo?**
> Kasalukuyang gumagana ang DriverLingo sa mga Android phone at tablet.

> **Paano lumipat sa pagitan ng light at dark mode?**
> Pumunta sa Settings > Appearance at piliin ang System default, Light, o Dark.

### 13. Contact Us *(DRAFT translation — not yet in app; page currently shows the English text from §13)*

> Ang DriverLingo (LTO Exam Reviewer Mobile App with Hiligaynon Translation) ay isang mock-exam reviewer na tumutulong sa mga naghahangad na drayber na maghanda para sa nakasulat na pagsusulit ng LTO sa English, Filipino, o Hiligaynon. Para sa mga tanong, feedback, o para i-flag ang isang tanong/sagot na kailangang suriin, makipag-ugnayan sa alinman sa mga developer sa ibaba.

**Section label:** Koponan ng Developer

**Copy-email toast:** Nakopya ang {email}

### 14. Reviewer screen *(DRAFT translation — not yet in app; hardcoded English-only today, see §14)*

> Reviewer *(page heading — kept as-is, "Reviewer" is used as a proper term elsewhere in the app too)*
> Hindi na-load ang reviewer. *(error state)*
> Wala pang available na mga tanong. *(empty state)*

---

# HILIGAYNON

## 1. Welcome screen

| Element | Text |
|---|---|
| Badge | LTO Reviewer |
| Hero quote 1 | Ang Kada Milya Nagasugod sa Pagsalig. |
| Hero quote 2 | Batunon ang Dalan. Batunon ang Ekzaminasyon. |
| Hero quote 3 | Imo Lisensya, Imo Lenggwahe. |
| Hero quote 4 | Pagpraktis Karon. Pagmaneho Buas. |
| Language section label | PILIA ANG LENGGWAHE |
| Button | Padayon |

## 2. "Before you continue" consent dialog

| Element | Text |
|---|---|
| Title | Antes magpadayon |
| Message | Paagi sa pagpadayon, nagakasugot ka sa Mga Kasugtanan kag Kundisyon kag Palisiya Pampribado sang DriverLingo. |
| `[Privacy policy]` chip | Palisiya Pampribado |
| `[Terms & conditions]` chip | Mga Kasugtanan kag Kundisyon |
| **[ I Agree ]** button | Nagakasugot Ako |
| Cancel button | Kanselahon |

## 3. Login screen

| Element | Text |
|---|---|
| Brand wordmark | DriverLingo *(not translated)* |
| Button | Padayon gamit ang Google |
| Loading state | Nagalog in... |

## 4. Onboarding walkthrough

| Element | Text |
|---|---|
| Title | Maayong pag-abot sa DriverLingo! |
| Subtitle | Antes sang imo una nga pang-ensayo nga ekzaminasyon, ari ang madasig nga pagtan-aw kon paano nagaobra ang tanan. |
| Button | Sugdan ang Pang-ensayo nga Ekzaminasyon |
| Button, loading state | Ginasugdan... |

**Six walkthrough steps** *(DRAFT — not yet in app; page currently always shows the English steps from §4)*
> 1. Himuon ang account
> 2. Pilia ang imo lenggwahe
> 3. Magkuha sang Pang-ensayo nga Ekzaminasyon
> 4. Usisaon ang imo mga resulta
> 5. Bantayi ang imo progreso
> 6. Pagtuon nga offline
> Sa likod sang eksena

## 5. Bottom navigation

> Balay · Kasaysayan · Profile · Mga Setting

## 6. Home screen

| Element | Text |
|---|---|
| Greeting | "Kumusta, {name}!" *(hardcoded, same in every language)* |
| Subtitle | Handa na maghanas? |
| Fallback name if none set | Drayber |
| Readiness card, returning user | Ipadayon ang kusog kag gana! |
| Readiness card, first-time | Kuhaa ang imo una nga Pang-ensayo nga Ekzaminasyon! |
| No attempts yet | Wala pa gid nagtilaw |
| Best score label | Pinakamataas |
| Streak | {n} ka sunod-sunod nga adlaw |
| Section label | KABUOAN NGA PAGKAHANDA |
| Category picker label | Kategorya sang Ekzaminasyon |
| Category subtitle | {count} items · pagsulundan sang LTO |
| Stat box | MGA PAMANGKOT |
| Stat box | ORAS |
| Primary button | Sugdan ang Pang-ensayo nga Ekzaminasyon |
| Loading state | Ginasugdan... |
| Bottom sheet title | Kadamu sang mga pamangkot |
| Bottom sheet switch | Gamiton ang custom nga numero |
| Value labels | Custom / Standard |
| Bottom sheet button | Tapos na |

## 7. Exam screen

| Element | Text |
|---|---|
| Header | Pamangkot {a} sang {b} |
| Translate menu tooltip | Baylo Lenggwahe |
| Nav buttons | Nagligad / Sunod |
| Submit button (toolbar) | Ipasa |
| Submit loading | Ginapasa... |
| Submit confirm dialog title | Ipasa ang ekzaminasyon? |
| Submit confirm body | Ginsabat mo ang {a} sa {b} ka pamangkot. Ang mga wala matsabat nga pamangkot markahan nga sala. Ipasa gihapon? |
| Confirm dialog buttons | Padayon sa pagsabat / Ipasa |
| Leave confirm dialog title | Bayaan ang ekzaminasyon? |
| Leave confirm dialog body | Madula ang imo progreso sa sini nga ekzaminasyon. |
| Leave confirm dialog buttons | Magpabilin / Halin |

## 8. Results screen

| Element | Text |
|---|---|
| Back button | Balik sa Home |
| Translate tooltip | Baylo lenggwahe sang rebyu |
| Page title | Resulta sang Ekzaminasyon |
| Pass badge | NAKAPASAR |
| Fail badge | KINAHANGLAN PA SING REBYU |
| Section label | Usisaon ang imo mga sabat |
| Retake button | Magliwat sang Ekzaminasyon |

## 9. History screen

| Element | Text |
|---|---|
| Page title | Kasaysayan sang Ekzaminasyon |
| Error state | Wala na-load ang kasaysayan. |
| Empty state | Wala ka pa sing na-agyan nga pang-ensayo nga ekzaminasyon. Kuha na! |
| Score suffix | husto |

## 10. Profile screen

| Element | Text |
|---|---|
| Page title | Profile |
| Role badges | Admin / Tagkuha sang Ekzaminasyon |
| Verified badge | Beripikado |
| Section label | Parte |
| Row label | Mga Lenggwahe |
| Row value | English · Filipino · Hiligaynon *(not translated)* |
| Row label | Kasuludan |
| Row value | {n} mga pamangkot sa LTO reviewer |
| Row label | App |
| Row value | DriverLingo v1.0.0 *(not translated)* |
| Button | Mag-log out |
| Confirm dialog title | Mag-log out? |
| Confirm dialog body | Pwede ka gid magbalik log in bisan san-o. |
| Cancel button (shared) | Kanselahon |

## 11. Settings screen

| Element | Text |
|---|---|
| Page title | Mga Setting |
| Section label | Hitsura |
| Theme options | Default sang sistema / Masanag / Madulom |
| Section label | Lenggwahe sang Reviewer |
| Section label | Suporta kag Legal |
| Row | Paano nagagamit ang sistema |
| Row | FAQs |
| Row | Palisiya Pampribado |
| Row | Mga Kasugtanan kag Kundisyon |
| Row | Kontaka kami |

### 11a. "How the system works" *(DRAFT translation — not yet in app; page currently shows the English text from §11a)*

> Ang DriverLingo nagabulig sa mga gusto mangin drayber sa pagpreparar para sa LTO non-professional kag professional nga ekzam sa lisensya sa pagmaneho, sa English, Filipino, ukon Hiligaynon.

> **1. Himuon ang account** — Mag-sign up gamit ang imo ngalan, email, kag password, ukon mag-log in sa imo na nga account. Ang imo account amo ang nagatipig sang imo kasaysayan sang ekzam kag progreso sa kada sesyon.
>
> **2. Pilia ang imo lenggwahe** — Pilia ang English, Filipino, ukon Hiligaynon bisan san-o. Available ang kada pamangkot, mga pilihan nga sabat, kag paathag sa tanan nga tatlo ka lenggwahe agud makarebyu ka sa lenggwahe nga imo maintindihan.
>
> **3. Magkuha sang Pang-ensayo nga Ekzaminasyon** — Sabta ang mga pamangkot nga pang-ensayo nga may takdo nga oras halin sa LTO reviewer question bank, nga nagatabon sang road sign, kasugtanan kag regulasyon sa trapiko, kag ligtas nga pamatasan sa pagmaneho para sa non-professional kag professional nga kategorya sang lisensya.
>
> **4. Usisaon ang imo mga resulta** — Pagkatapos mag-submit, makita mo ang imo iskor, ang status nga nakapasar ukon wala, kag ang detalyado nga breakdown sang kada pamangkot lakip ang husto nga sabat kag paathag – agud ang kada sayop mangin leksyon.
>
> **5. Bantayi ang imo progreso** — Ang kada tangka gina-save sa imo Exam History, agud mabalikan mo ang nagligad nga mga iskor kag makita kon paano ka nagauswag sa paglabay sang tion.
>
> **6. Pagtuon nga offline** — Kon naabrihan mo na ang mga pamangkot sang reviewer samtang online, ma-cache ini sa imo device agud makapadayon ka sa pagpraktis bisan wala sing internet connection.
>
> **Sa likod sang eksena** — Ginabantayan kag gina-update sang mga administrator ang question bank kag gina-manage ang mga user account agud magpabilin nga sibu kag updated ang reviewer.

### 11b. Terms & Conditions and Privacy Policy *(DRAFT translation — not yet in app; page currently shows the English text from §11b)*

#### Mga Kasugtanan kag Kundisyon

**Pasiuna**
> Sa paggamit sang DriverLingo, nagakasugot ka sa masunod nga mga kasugtanan.

**Parte sini nga app**
> Ang DriverLingo isa ka giya sa kaugalingon nga pagtuon nga ginhimo bilang BSIT capstone project sang mga estudyante sang West Visayas State University – Pototan Campus. Wala ini kahilabtanan, gin-endorso, ukon konektado sa Land Transportation Office (LTO).

**Pagkahusto sang Impormasyon**
> Ginatinguhaan namon nga mapabilin nga sibu ang mga pamangkot, sabat, kag paathag, pero may mga entry pa nga ginakonsulta batok sa opisyal nga rekord sang LTO. Ang DriverLingo tuyo lang nga magbulig, indi magbaylo, sa opisyal nga LTO reviewer materials – pirme kumpirmaha ang importante nga impormasyon sa may awtoridad nga ginhalinan antes sang imo tunay nga ekzaminasyon.

**Ang imo account**
> Ikaw ang responsable sa pagkainsakto sang impormasyon nga imo gina-provide kag sa pag-amlig sang seguridad sang imo login credentials. Indi pag-ibahin ang imo account sa iban.

**Insakto nga Paggamit**
> Gamiton lang ang DriverLingo para sa personal nga preparasyon sa ekzaminasyon. Indi pagsulayan nga kopyahon, ibaligya liwat, ukon ipanagtag ang kasuludan sang reviewer, kag indi pag-abusuhon ang app sa paagi nga makasablag sa serbisyo para sa iban nga magamit.

**Limitasyon sang pananagutan**
> Ang DriverLingo gina-provide bilang gamit sa pagtuon, "as is," wala sing garantiya sa resulta sang ekzaminasyon. Ang development team wala sing katungdanan para sa resulta sang imo tunay nga LTO exam ukon sa mga desisyon nga ginhimo base lang sa impormasyon sini nga app.

**Mga pagbag-o sini nga mga kasugtanan**
> Ini nga mga kasugtanan mahimo mabag-o samtang ginapauswag ang app. Ang padayon nga paggamit sang app pagkatapos mabalhag ang mga pagbag-o nagakahulugan nga ginabaton mo ang nabag-o nga mga kasugtanan.

#### Palisiya sa Privacy

**Pasiuna**
> Nahibaluan namon nga ang pagpreparar para sa imo lisensya nagakinahanglan na sing bastante nga papeles sa gobyerno. Ari ang eksakto nga ginakolekta sang DriverLingo kag ngaa.

**Impormasyon nga ginakolekta namon**
> Kon magrehistro ka, ginakolekta namon ang imo ngalan, email address, kag isa ka secure nga naka-hash nga password. Samtang ginagamit mo ang app, gina-store man namon ang imo napili nga lenggwahe sa reviewer kag ang imo mga pang-ensayo nga eksaminasyon (mga sabat, iskor, kag timestamp).

**Paano namon ini ginagamit**
> Ang detalye sang imo account amo ang nagatugot sa imo mag-log in kag magpabilin ang imo progreso sa lain-lain nga device. Ang imo kasaysayan sang eksaminasyon nagatugot sa imo nga balikan ang nagligad nga mga tangka kag bantayan ang pag-uswag. Wala namon ginagamit ang imo datos para sa advertising, kag wala namon ini ginabaligya ukon ginapanagtag sa pangatlong partido.

**Offline nga Datos**
> Ang mga pamangkot sang reviewer nga gin-download para sa offline nga paggamit ma-cache lang sa imo device, kag wala ginapanagtag sa bisan sin-o.

**Pag-store sang Datos kag Seguridad**
> Ang imo impormasyon gina-store sa amon mga server nga may naka-hash nga password kag limitado nga access para lang sa development team nga nagabantay sa app. Ini nga app ginhimo bilang akademiko nga capstone project, gani likawi ang pagsumiter sang sensitibo nga personal nga impormasyon luwas sa ginakinahanglan sang pagparehistro.

**Ang imo mga kinamatarung**
> Suno sa Philippine Data Privacy Act of 2012 (RA 10173), pwede ka mangayo sang access, pagtadlong, ukon pagpanas sang imo personal nga datos bisan san-o paagi sa Contact Us.

**Mga pagbag-o sini nga palisiya**
> Ini nga palisiya mahimo mabag-o samtang nagauswag ang app. Ang padayon nga paggamit sang DriverLingo pagkatapos mabalhag ang mga pagbag-o nagakahulugan nga ginabaton mo ang nabag-o nga palisiya.

### 12. FAQs *(DRAFT translation — not yet in app; page currently shows the English text from §12)*

> **Ano ang DriverLingo?**
> Ang DriverLingo (LTO Exam Reviewer Mobile App with Hiligaynon Translation) isa ka pang-ensayo nga eksaminasyon nga reviewer nga nagabulig sa mga gusto mangin drayber sa pagpreparar para sa nakasulat nga ekzaminasyon sang LTO sa English, Filipino, ukon Hiligaynon.

> **Opisyal bala ini nga app sang LTO?**
> Indi. Ang DriverLingo isa ka giya sa kaugalingon nga pagtuon nga ginhimo bilang BSIT capstone project sang mga estudyante sang West Visayas State University – Pototan Campus. Wala ini kahilabtanan, gin-endorso, ukon konektado sa Land Transportation Office.

> **Ngaa Hiligaynon?**
> Ang mga na-una nga LTO reviewer nasulat lang sa English kag Filipino, nga wala nagalakip sa mga Ilonggo/Hiligaynon speaker nga indi gid komportable sa bisan diin sa duha ka lenggwahe. Ginabaylo sang DriverLingo ang kada pamangkot, pilihan, kag paathag sa Hiligaynon agud mas madamo nga drayber ang makapreparar nga may kumpiyansa.

> **Nagagana bala ang app nga offline?**
> Huo. Kon naabrihan mo na ang mga pamangkot sang reviewer maski isa ka beses samtang online, ma-cache ini sa imo device agud makapadayon ka sa pagtuon bisan wala sing internet connection.

> **Libre bala ang DriverLingo?**
> Huo, libre gamiton ang DriverLingo.

> **Daw ano ka-sibu ang mga pamangkot kag sabat?**
> Ang impormasyon halin sa LTO reviewer materials, pero may mga entry pa nga ginakonsulta batok sa opisyal nga rekord. Kon may natalupangdan ka nga sabat nga daw sala, ipahibalo sa amon paagi sa Contact Us agud matadlong ini.

> **Pwede bala ko liwaton ang pang-ensayo nga eksaminasyon?**
> Huo, pwede ka mangkuha sang kadamu nga pang-ensayo nga eksaminasyon nga gusto mo. Tandai nga lain ini sa tunay nga LTO exam, diin ang pagkapaslaw sa tatlo ka opisyal nga tangka nagakahulugan sang duha ka tuig nga paghulat antes ka makaaplay liwat.

> **May mga Hiligaynon nga text nga nagapakita gihapon sang English ukon Filipino nga tinaga – ngaa?**
> May pila ka teknikal kag legal nga termino sa layi sa trapiko nga wala sing direkta nga katumbas sa Hiligaynon, gani ginabilin ini sa ila orihinal nga lenggwahe para maintindihan.

> **Ano nga mga device ang suportado sang DriverLingo?**
> Sa karon, nagaobra ang DriverLingo sa mga Android phone kag tablet.

> **Paano ako magbaylo sa light kag dark mode?**
> Kadto sa Settings > Appearance kag pilia ang System default, Light, ukon Dark.

### 13. Contact Us *(DRAFT translation — not yet in app; page currently shows the English text from §13)*

> Ang DriverLingo (LTO Exam Reviewer Mobile App with Hiligaynon Translation) isa ka mock-exam reviewer nga nagabulig sa mga gusto mangin drayber sa pagpreparar para sa nakasulat nga ekzam sang LTO sa English, Filipino, ukon Hiligaynon. Para sa mga pamangkot, feedback, ukon sa pag-flag sang pamangkot/sabat nga kinahanglan usisaon, kontaka ang bisan sin-o sa mga developer sa idalom.

**Section label:** Koponan sang Developer

**Copy-email toast:** Na-copy ang {email}

### 14. Reviewer screen *(DRAFT translation — not yet in app; hardcoded English-only today, see §14)*

> Reviewer *(page heading — kept as-is, "Reviewer" is used as a proper term elsewhere in the app too)*
> Wala na-load ang reviewer. *(error state)*
> Wala pa sing available nga mga pamangkot. *(empty state)*

*These Hiligaynon drafts cover the technical/legal vocabulary flagged by the FAQ item "Some Hiligaynon text still shows English or Filipino words – why?" as best as possible — a few terms (ekzam, account, review, etc.) are intentionally kept close to English/Filipino since no clean everyday Hiligaynon equivalent exists.*

---

## Things worth a second look while critiquing

- **Home screen greeting** uses the Filipino word "Kumusta" even when the reviewer language is set to English or Hiligaynon — likely intentional flavor, but flag if you want it to actually localize per language.
- **Exam screen Submit button** has inconsistent Filipino wording between the toolbar ("I-submit") and the confirm dialog ("Isumite") — see the note under the Filipino §7.
- **"How the system works"** copy is shared verbatim between Settings and the mandatory onboarding screen — editing it once updates both places automatically.
- The long-form pages (Terms & Conditions, Privacy Policy, FAQs, Contact Us, "How the system works," the Reviewer screen, and the six onboarding steps) currently have **no Filipino or Hiligaynon version in the app at all** — every one of them always renders in English regardless of the language picker. The Filipino and Hiligaynon versions under §11a/11b/12/13/14 in each language section are **draft translations I wrote for this review only** — they are not in the codebase yet. Please have your client/an actual Filipino and Hiligaynon speaker check them before I code them in, especially the Hiligaynon legal text (Terms & Conditions / Privacy Policy) — legal wording is the highest-stakes place to get a translation subtly wrong, and Hiligaynon is the language I'm least confident in.
