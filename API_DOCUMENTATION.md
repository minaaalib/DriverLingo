# LTO Exam Reviewer API Documentation

Base URL (local dev): `http://localhost:8000/api`

Interactive docs are also served by the backend itself once it's running:

- Swagger UI: `/api/docs`
- Raw OpenAPI schema: `/api/schema`

All endpoints accept and return `application/json` unless noted (image
uploads use `multipart/form-data`). Authenticated endpoints expect:

```
Authorization: Bearer <access_token>
```

## Roles

- **user** (examinee, the default role on registration) - can read the
  question bank, take mock exams, view their own results/history, submit
  feedback, and download the PDF reviewer.
- **admin** - everything a user can do, plus question bank CRUD/bulk
  upload, and user management. Create one with
  `python manage.py createsuperuser` or `python manage.py seed_demo_data`.

---

## Authentication - `/api/auth/`

| Method | Path | Auth | Description |
|---|---|---|---|
| POST | `/auth/register` | none | Create an account. Sends a verification email. |
| POST | `/auth/login` | none | Email + password → `{access, refresh, user}`. |
| POST | `/auth/logout` | user | Blacklists the given refresh token. Body: `{"refresh": "..."}`. |
| POST | `/auth/refresh-token` | none | Body: `{"refresh": "..."}` → new `{access, refresh}` pair (rotation enabled). |
| GET | `/auth/verify-email/{token}` | none | Marks the account's email verified. |
| POST | `/auth/resend-verification` | none | Body: `{"email": "..."}`. |
| POST | `/auth/password-reset/request` | none | Body: `{"email": "..."}`. Emails a reset token. |
| POST | `/auth/password-reset/confirm` | none | Body: `{"token": "...", "new_password": "..."}`. |
| POST | `/auth/change-password` | user | Body: `{"old_password": "...", "new_password": "..."}`. |
| GET | `/auth/me` | user | Current user's profile. |
| PATCH | `/auth/me` | user | Update own `name`. |

**Register**

```http
POST /api/auth/register
{
  "name": "Juan Dela Cruz",
  "email": "juan@example.com",
  "password": "SecurePass123",
  "password_confirmation": "SecurePass123"
}
```

**Login**

```http
POST /api/auth/login
{ "email": "juan@example.com", "password": "SecurePass123" }
```

```json
{
  "access": "<jwt>",
  "refresh": "<jwt>",
  "user": { "id": 1, "name": "Juan Dela Cruz", "email": "juan@example.com", "role": "user", "email_verified_at": null, ... }
}
```

Access tokens expire after 60 minutes by default (`ACCESS_TOKEN_LIFETIME_MIN`);
refresh tokens after 14 days (`REFRESH_TOKEN_LIFETIME_DAYS`), both
configurable via environment variables. Refresh tokens rotate on use and
old ones are blacklisted.

---

## Question bank - `/api/questions/`

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/questions/` | user | List questions. See query params below. |
| GET | `/questions/{id}` | user | Retrieve one question. |
| POST | `/questions/` | admin | Create a question (JSON or multipart with images). |
| PUT/PATCH | `/questions/{id}` | admin | Update a question. |
| DELETE | `/questions/{id}` | admin | Delete a question. |
| POST | `/questions/bulk-upload` | admin | Create many questions at once, optionally with images. |

**Query parameters for `GET /questions/`**

- `lang` = `en` \| `ph` \| `hl` (Hiligaynon) - when present, the response
  is "localized" to a single language (fields collapse to `question`,
  `option_a/b/c`, `explanation`). **Omit `lang`** to get the full
  admin-shape record with every language and photo field at once (this
  is also what you get from every write/response on the admin CRUD
  endpoints).
- `category` = `student` \| `non_professional` \| `professional` \| `all`
- `search` - free-text search across the English/Filipino/Hiligaynon question text
- `needs_review` = `true`/`false` - filter to questions whose correct
  answer has not yet been confirmed by a human reviewer (see
  **Answer-key disclaimer** below)
- Standard DRF pagination: `page`, `page_size`

Example (Hiligaynon, student-relevant questions only):

```
GET /api/questions/?lang=hl&category=student
```

```json
{
  "count": 101,
  "next": "http://localhost:8000/api/questions/?lang=hl&page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "question": "Kun ginagamit ang basic speed law...",
      "question_photo": null,
      "option_a": "kadasigon sang drayber",
      "option_a_photo": null,
      "option_b": "gasolina sang ginamaneho nga salakyan",
      "option_b_photo": null,
      "option_c": "trapiko kag kondisyon sang dalan",
      "option_c_photo": null,
      "correct_answer": "c",
      "explanation": "Ang mga speed limit ginabase sa dalagan sang trapiko...",
      "category": "all",
      "needs_review": true
    }
  ]
}
```

**Create (admin, JSON)**

```http
POST /api/questions/
{
  "question_en": "What color is a stop sign?",
  "question_ph": "Anong kulay ang stop sign?",
  "question_hl": "Ano nga kolor ang stop sign?",
  "option_a_en": "Red", "option_a_ph": "Pula", "option_a_hl": "Pula",
  "option_b_en": "Yellow", "option_b_ph": "Dilaw", "option_b_hl": "Dilaw",
  "option_c_en": "Green", "option_c_ph": "Berde", "option_c_hl": "Berde",
  "correct_answer": "a",
  "explanation_en": "...", "explanation_ph": "...", "explanation_hl": "...",
  "category": "all"
}
```

**Create with images (admin, multipart/form-data)**

Send the same fields as normal form fields, plus files under
`question_photo`, `option_a_photo`, `option_b_photo`, `option_c_photo`.

**Bulk upload (admin)**

Text-only, plain JSON array body:

```http
POST /api/questions/bulk-upload
Content-Type: application/json

[
  { "question_en": "...", "option_a_en": "...", "option_b_en": "...", "option_c_en": "...", "correct_answer": "a" },
  { "question_en": "...", "option_a_en": "...", "option_b_en": "...", "option_c_en": "...", "correct_answer": "b" }
]
```

With images, `multipart/form-data`:

- `questions`: a JSON array string, where any row wanting an image adds
  e.g. `"question_photo_key": "img1"`
- one file field per referenced key, e.g. a file field named `img1`

Response:

```json
{ "created_count": 2, "created_ids": [102, 103], "error_count": 0, "errors": [] }
```

---

## Mock exams - `/api/exams/`

| Method | Path | Auth | Description |
|---|---|---|---|
| POST | `/exams/start` | user | Start a new mock exam session. |
| POST | `/exams/submit` | user | Submit answers and get graded. |
| GET | `/exams/results/{exam_id}` | user (owner) / admin | Full breakdown with the answer key. |
| GET | `/exams/history` | user | The current user's own past exams. |

**Start an exam**

```http
POST /api/exams/start
{
  "category": "student",              // student | non_professional | professional
  "language": "hl",                   // en | ph | hl
  "num_questions": 40,                 // optional; defaults to the LTO-standard count per category
  "time_limit_minutes": 30             // optional; omit for an untimed exam
}
```

```json
{
  "exam": { "id": 12, "category": "student", "language_used": "hl", "total_questions": 40, "time_limit_minutes": 30, "status": "in_progress", "score": 0, "percentage": 0.0, "started_at": "...", "submitted_at": null, "date_taken": "..." },
  "questions": [
    { "question_id": 7, "order": 1, "question": "...", "option_a": "...", "option_b": "...", "option_c": "...", "selected_answer": null }
  ]
}
```

Note the answer key and explanations are **withheld** from this response
- the mobile app should not be able to read them off the wire while the
exam is in progress.

**Submit**

```http
POST /api/exams/submit
{
  "exam_id": 12,
  "answers": [
    { "question_id": 7, "selected_answer": "b" },
    { "question_id": 9, "selected_answer": null }
  ],
  "time_taken_seconds": 900
}
```

Returns the same shape as `GET /exams/results/{exam_id}` - the score,
plus every question with `selected_answer`, `correct_answer`,
`is_correct`, and `explanation` filled in. Also triggers an "exam
completed" email to the user.

**History**

```json
{
  "count": 3,
  "results": [
    { "id": 12, "category": "student", "language_used": "hl", "total_questions": 40, "status": "completed", "score": 34, "percentage": 85.0, "started_at": "...", "submitted_at": "...", "date_taken": "..." }
  ]
}
```

---

## User management (admin only) - `/api/users/`

| Method | Path | Description |
|---|---|---|
| GET | `/users/` | List all users (filter by `?role=`, `?is_active=`; search by `?search=`). |
| GET | `/users/{id}` | User detail, including `exam_count`. |
| DELETE | `/users/{id}` | Delete a user (cannot delete your own account this way). |

---

## Reviewer PDF export - `/api/reviewer/pdf`

```
GET /api/reviewer/pdf?lang=hl&category=professional
```

Streams a generated PDF (`Content-Type: application/pdf`) of the active
question bank in the requested language, with the answer key marked and
explanations included - suitable for printing or offline reading outside
the app.

---

## Feedback - `/api/feedback`

```http
POST /api/feedback
{
  "category": "content",         // bug | content | suggestion | other
  "message": "Question #14's Hiligaynon translation has a typo.",
  "related_question": 14          // optional
}
```

Anonymous submissions are allowed (no `Authorization` header required),
but if you're logged in the feedback is attributed to your account.

---

## Error format

Validation errors follow DRF's default shape:

```json
{ "email": ["An account with this email already exists."] }
```

Non-field errors from custom views:

```json
{ "detail": "This verification link is invalid or has expired." }
```

## Rate limiting

Auth endpoints (register/login/password-reset/etc.) are throttled to 20
requests/minute per client by default (`auth` throttle scope in
`REST_FRAMEWORK.DEFAULT_THROTTLE_RATES`).

---

## ⚠️ Answer-key disclaimer (read before using this in production)

The seeded question bank (101 questions, `questions/fixtures/questions_seed.json`)
was parsed from `LTO-Reviewer.docx`, which contains each question's text,
options, and a written explanation in three languages - but **no explicit
"the correct answer is X" marker**. The correct answer for every seeded
question was inferred programmatically by matching the explanation
paragraph against the wording of each option.

75 of the 101 seeded questions were **flagged `needs_review: true`**
because that matching was ambiguous (multiple options overlapped the
explanation similarly, or none did strongly). Even the other 26 should be
treated as provisional, not authoritative - the heuristic got at least
one "high confidence" case (question #1) wrong in testing.

**Before relying on this app to actually prepare someone for the LTO
exam, a person should review every question against an official LTO
reviewer/reference.** A prioritized worklist is included at
`answer_key_review_NEEDS_VERIFICATION.csv` (the 75 flagged questions,
lowest-confidence first, with the English question/options/explanation
and a blank column to fill in the verified answer). The Django admin
(`/admin/`) is the fastest place to make corrections: filter Questions by
"Needs review", fix `correct_answer`, and use the "Mark selected
questions as reviewed" action to clear the flag.
