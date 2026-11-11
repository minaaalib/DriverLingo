"""One-off data migration: copies the Django question bank (text + photos)
into a Supabase Postgres `questions` table + Storage bucket.

Prerequisites (do these in Supabase Studio first):
  1. Run supabase/migrations/0001_init.sql (SQL Editor) so the `questions`
     table exists.
  2. Storage -> New bucket -> name it "question-photos", toggle "Public
     bucket" on (matches Django's MEDIA_URL being served publicly today).

Run once, from backend/ with the venv active:

    SUPABASE_URL=https://xxxx.supabase.co \
    SUPABASE_SERVICE_ROLE_KEY=... \
    python scripts/migrate_to_supabase.py

The service role key bypasses RLS and Storage permissions - it's only
ever used here, interactively, by whoever runs this. Never commit it or
put it in the app.
"""

import mimetypes
import os
import sys

import django
import requests

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
django.setup()

from questions.models import Question  # noqa: E402

SUPABASE_URL = os.environ["SUPABASE_URL"].rstrip("/")
SERVICE_ROLE_KEY = os.environ["SUPABASE_SERVICE_ROLE_KEY"]
BUCKET = "question-photos"

HEADERS = {
    "apikey": SERVICE_ROLE_KEY,
    "Authorization": f"Bearer {SERVICE_ROLE_KEY}",
}

PHOTO_FIELDS = [
    ("question_photo", "question_photo_url"),
    ("option_a_photo", "option_a_photo_url"),
    ("option_b_photo", "option_b_photo_url"),
    ("option_c_photo", "option_c_photo_url"),
]


def upload_photo(field_file, dest_name):
    """Uploads an ImageField's file to the question-photos bucket and
    returns its public URL, or None if the field is empty."""
    if not field_file:
        return None
    content_type = mimetypes.guess_type(field_file.name)[0] or "application/octet-stream"
    with field_file.open("rb") as fh:
        data = fh.read()
    resp = requests.post(
        f"{SUPABASE_URL}/storage/v1/object/{BUCKET}/{dest_name}",
        headers={**HEADERS, "Content-Type": content_type},
        data=data,
    )
    resp.raise_for_status()
    return f"{SUPABASE_URL}/storage/v1/object/public/{BUCKET}/{dest_name}"


def migrate_question(q):
    row = {
        "question_en": q.question_en, "question_ph": q.question_ph, "question_hl": q.question_hl,
        "option_a_en": q.option_a_en, "option_a_ph": q.option_a_ph, "option_a_hl": q.option_a_hl,
        "option_b_en": q.option_b_en, "option_b_ph": q.option_b_ph, "option_b_hl": q.option_b_hl,
        "option_c_en": q.option_c_en, "option_c_ph": q.option_c_ph, "option_c_hl": q.option_c_hl,
        "correct_answer": q.correct_answer,
        "explanation_en": q.explanation_en, "explanation_ph": q.explanation_ph, "explanation_hl": q.explanation_hl,
        "category": q.category,
        "is_active": q.is_active,
        "needs_review": q.needs_review,
    }
    for field_name, url_key in PHOTO_FIELDS:
        field_file = getattr(q, field_name)
        if field_file:
            dest = f"{q.pk}/{url_key}-{os.path.basename(field_file.name)}"
            row[url_key] = upload_photo(field_file, dest)

    resp = requests.post(
        f"{SUPABASE_URL}/rest/v1/questions",
        headers={**HEADERS, "Content-Type": "application/json", "Prefer": "return=representation"},
        json=row,
    )
    resp.raise_for_status()
    new_id = resp.json()[0]["id"]
    print(f"question {q.pk} -> supabase id {new_id}")
    return q.pk, new_id


def main():
    id_map = {}
    for q in Question.objects.all().order_by("id"):
        old_id, new_id = migrate_question(q)
        id_map[old_id] = new_id

    print(f"\nMigrated {len(id_map)} questions.")
    print("Old Django id -> new Supabase id (keep this if you also need to port exam history):")
    print(id_map)


if __name__ == "__main__":
    main()
