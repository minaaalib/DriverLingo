# LTO Exam Reviewer - Flutter Sample App

A sample Flutter client for the LTO Exam Reviewer Mobile App with
Hiligaynon Translation backend. It demonstrates:

- JWT login/registration against the Django backend (`lib/services/auth_service.dart`)
- The home/setup screen: category, language, question-count, optional timer (`lib/screens/home_screen.dart`)
- The mock-exam runner: paginated question flow, answer selection, live countdown, submit (`lib/screens/exam_screen.dart`)
- The results/review screen: score, pass/fail, per-question breakdown with the correct answer and explanation (`lib/screens/results_screen.dart`)
- Exam history (`lib/screens/history_screen.dart`)
- An API service layer built on `dio`, with automatic JWT refresh (`lib/core/api_client.dart`)
- An offline SQLite cache for downloading the question bank for offline study (`lib/services/offline_cache.dart`)

This is a **sample/reference implementation** covering the screens asked
for in the spec, not a pixel-polished production app - styling, empty
states, and additional screens (e.g. a dedicated "download for offline"
settings screen, PDF viewer, admin-in-app tools) are straightforward to
add on top of the services already provided.

## Getting started

1. Install [Flutter](https://docs.flutter.dev/get-started/install) (3.24+ recommended) and run `flutter doctor` to confirm your setup.
2. From this directory:
   ```bash
   flutter pub get
   ```
3. Point the app at your backend. By default it targets
   `http://10.0.2.2:8000/api`, which is how the Android emulator reaches
   `localhost:8000` on your host machine (where
   `python manage.py runserver` listens). Override it at build/run time:
   ```bash
   flutter run --dart-define=API_BASE_URL=http://192.168.1.50:8000/api
   ```
   - Android emulator + backend on your host machine: keep the default (`10.0.2.2`).
   - iOS simulator + backend on your host machine: use `http://localhost:8000/api`.
   - Physical device: use your computer's LAN IP, and make sure
     `ALLOWED_HOSTS` / `CORS_ALLOWED_ORIGINS` on the backend allow it.
4. Run the app:
   ```bash
   flutter run
   ```

## Demo accounts

The backend's `seed_demo_data` management command creates:

- Admin: `admin@ltoreviewer.local` / `Admin@12345`
- Examinee: `examinee@ltoreviewer.local` / `Examinee@12345`

Or just register a new account from the app - registration is open.

## Project layout

```
lib/
  core/            API client (JWT + auto-refresh), token storage, constants
  models/          Plain Dart models mapping to the API's JSON shapes
  services/        AuthService, QuestionService, ExamService, OfflineCache
  screens/         Login, Register, Home (exam setup), Exam runner, Results, History
```

## Extending this sample

- **PDF reviewer download**: call `GET /api/reviewer/pdf?lang=..&category=..`
  (see `reviewer/pdf.py` in the backend) and save/open the response with
  a package like `open_filex` or `printing`.
- **Push/email notifications**: the backend already emails on
  registration and exam completion; add `firebase_messaging` if you also
  want push notifications.
- **Admin-in-app screens**: `QuestionService`/`ExamService` can be
  extended with the admin-only endpoints (`POST/PUT/DELETE /api/questions`,
  `GET/DELETE /api/users`) to build an in-app moderation UI, though the
  Django admin (customized in `questions/admin.py`) already covers this.
