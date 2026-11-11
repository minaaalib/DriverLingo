-- DriverLingo: Postgres schema + RLS + exam RPCs, replacing the Django
-- backend's accounts/questions/exams apps. Apply via the Supabase SQL
-- editor or `supabase db push` once the CLI is linked to the project.
--
-- The JSON shapes returned by start_exam/submit_exam below are written
-- to match mobile_app/lib/models/exam.dart and question.dart exactly
-- (field names like `question_photo`, `order`, the flat ExamResult shape,
-- and the per-language `translations` block the exam screen's
-- translate-toggle reads) so the Flutter rewiring in phase 4 is a
-- same-shape swap of the HTTP call for an rpc()/from() call, not a model
-- rewrite.
--
-- Safe to re-run from scratch: drops everything this file creates first
-- (in dependency order), then recreates it. Only run this against a
-- project where it's fine to wipe profiles/questions/exams/exam_responses
-- - i.e. during initial setup, not against a database already holding
-- real data you want to keep.

drop view if exists public.exam_results_view;
drop function if exists public.submit_exam(bigint, jsonb, int);
drop function if exists public.start_exam(text, text, int, int);
drop function if exists public.list_questions(text, text);
-- Omits the arg list on purpose: it references the public.questions row
-- type, which DROP FUNCTION would need to resolve even under IF EXISTS -
-- failing on a project where the table doesn't exist yet. The name alone
-- is unambiguous (only one overload), so this works either way.
drop function if exists public.question_translations;
drop function if exists public.localize(text, text, text, text);
drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user();
drop function if exists public.is_admin();
drop table if exists public.exam_responses cascade;
drop table if exists public.exams cascade;
drop table if exists public.questions cascade;
drop table if exists public.profiles cascade;

-- ---------------------------------------------------------------------
-- profiles: one row per auth.users row, carries the app role. Supabase
-- Auth has no concept of app-level roles, so this mirrors Django's
-- accounts.User.role column.
-- ---------------------------------------------------------------------

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  name text not null default '',
  role text not null default 'user' check (role in ('user', 'admin')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create function public.is_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin');
$$;

create function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'name', new.raw_user_meta_data ->> 'full_name', split_part(new.email, '@', 1))
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

alter table public.profiles enable row level security;

create policy "profiles_select_own_or_admin" on public.profiles
  for select to authenticated
  using (auth.uid() = id or public.is_admin());

create policy "profiles_update_own" on public.profiles
  for update to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- ---------------------------------------------------------------------
-- questions: mirrors questions.models.Question. Intentionally readable
-- in full (including correct_answer) by any authenticated user - this
-- app is a *reviewer*, so the answer key is meant to be visible outside
-- an active exam (see the exam-flow comment below for the one place that
-- genuinely hides it).
-- ---------------------------------------------------------------------

create table public.questions (
  id bigint generated always as identity primary key,

  question_en text not null,
  question_ph text not null default '',
  question_hl text not null default '',
  question_photo_url text,

  option_a_en text not null,
  option_a_ph text not null default '',
  option_a_hl text not null default '',
  option_a_photo_url text,

  option_b_en text not null,
  option_b_ph text not null default '',
  option_b_hl text not null default '',
  option_b_photo_url text,

  option_c_en text not null,
  option_c_ph text not null default '',
  option_c_hl text not null default '',
  option_c_photo_url text,

  correct_answer text not null check (correct_answer in ('a', 'b', 'c')),

  explanation_en text not null default '',
  explanation_ph text not null default '',
  explanation_hl text not null default '',

  category text not null default 'all'
    check (category in ('all', 'student', 'non_professional', 'professional')),

  is_active boolean not null default true,
  needs_review boolean not null default false,

  created_by uuid references auth.users (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index questions_category_active_idx on public.questions (category, is_active);

alter table public.questions enable row level security;

create policy "questions_select_active_or_admin" on public.questions
  for select to authenticated
  using (is_active = true or public.is_admin());

-- No insert/update/delete policies: content management happens via
-- Supabase Studio's Table Editor using the service_role key, which
-- bypasses RLS entirely. Regular authenticated users get read-only access.

-- Picks a language column, falling back to English if the translation is
-- blank. Mirrors questions.serializers.LocalizedQuestionSerializer.
create function public.localize(en text, ph text, hl text, lang text) returns text
language sql immutable as $$
  select case lang
    when 'ph' then coalesce(nullif(ph, ''), en)
    when 'hl' then coalesce(nullif(hl, ''), en)
    else en
  end;
$$;

-- All three languages for one question, shaped to match the `translations`
-- map mobile_app/lib/models/question.dart reads for its in-exam translate
-- toggle (Django's ExamQuestionSerializer/ExamResultResponseSerializer
-- built the same map - explanations only included once an exam result is
-- being shown, never while it's still in progress).
create function public.question_translations(q public.questions, with_explanation boolean default false)
returns jsonb
language sql immutable as $$
  select jsonb_build_object(
    'en', jsonb_build_object('question', q.question_en, 'option_a', q.option_a_en, 'option_b', q.option_b_en, 'option_c', q.option_c_en)
      || case when with_explanation then jsonb_build_object('explanation', q.explanation_en) else '{}'::jsonb end,
    'ph', jsonb_build_object('question', q.question_ph, 'option_a', q.option_a_ph, 'option_b', q.option_b_ph, 'option_c', q.option_c_ph)
      || case when with_explanation then jsonb_build_object('explanation', q.explanation_ph) else '{}'::jsonb end,
    'hl', jsonb_build_object('question', q.question_hl, 'option_a', q.option_a_hl, 'option_b', q.option_b_hl, 'option_c', q.option_c_hl)
      || case when with_explanation then jsonb_build_object('explanation', q.explanation_hl) else '{}'::jsonb end
  );
$$;

-- Replaces the paginated GET /api/questions?lang=..&category=.. endpoint
-- (mobile_app's QuestionService.getReviewerQuestions) with one call -
-- returns an already-localized array matching ReviewerQuestion.fromJson
-- exactly. No security definer needed: the `questions_select_active_or_admin`
-- policy above already lets any authenticated user read active questions,
-- so this just runs with the caller's own (sufficient) privileges.
create function public.list_questions(p_lang text default 'en', p_category text default null)
returns jsonb
language sql stable set search_path = public as $$
  select coalesce(jsonb_agg(jsonb_build_object(
    'id', id,
    'question', public.localize(question_en, question_ph, question_hl, p_lang),
    'option_a', public.localize(option_a_en, option_a_ph, option_a_hl, p_lang),
    'option_b', public.localize(option_b_en, option_b_ph, option_b_hl, p_lang),
    'option_c', public.localize(option_c_en, option_c_ph, option_c_hl, p_lang),
    'correct_answer', correct_answer,
    'explanation', public.localize(explanation_en, explanation_ph, explanation_hl, p_lang),
    'category', category,
    'needs_review', needs_review
  ) order by id), '[]'::jsonb)
  from public.questions
  where is_active = true
    and (p_category is null or p_category = 'all' or category = p_category or category = 'all');
$$;

grant execute on function public.list_questions(text, text) to authenticated;

-- ---------------------------------------------------------------------
-- exams / exam_responses: mirrors exams.models.Exam / ExamResponse.
-- ---------------------------------------------------------------------

create table public.exams (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users (id) on delete cascade,

  category text not null check (category in ('student', 'non_professional', 'professional')),
  language_used text not null default 'en' check (language_used in ('en', 'ph', 'hl')),

  total_questions int not null,
  time_limit_minutes int,

  status text not null default 'in_progress'
    check (status in ('in_progress', 'completed', 'abandoned')),
  score int not null default 0,
  percentage numeric generated always as (round(100.0 * score / greatest(total_questions, 1), 1)) stored,

  started_at timestamptz not null default now(),
  submitted_at timestamptz
);

create table public.exam_responses (
  id bigint generated always as identity primary key,
  exam_id bigint not null references public.exams (id) on delete cascade,
  question_id bigint not null references public.questions (id) on delete restrict,
  order_num int not null,

  selected_answer text check (selected_answer in ('a', 'b', 'c')),
  is_correct boolean,
  answered_at timestamptz,

  unique (exam_id, question_id)
);

create index exams_user_idx on public.exams (user_id);
create index exam_responses_exam_idx on public.exam_responses (exam_id);

alter table public.exams enable row level security;
alter table public.exam_responses enable row level security;

create policy "exams_select_own_or_admin" on public.exams
  for select to authenticated
  using (auth.uid() = user_id or public.is_admin());

-- Deliberately no policies on exam_responses for the `authenticated`
-- role: direct reads are denied entirely. The only ways to see response
-- data are (a) the start_exam/submit_exam RPCs below, which return a
-- deliberately-shaped payload, or (b) the exam_results_view below, which
-- only exposes completed exams. This enforces "no correct answer until
-- submitted" at the database layer instead of relying on application code.

-- security_invoker=off (the default) is required here on purpose: it lets
-- the view read exam_responses despite the deny-all RLS above, while the
-- view's own WHERE clause (auth.uid() = e.user_id) does the actual scoping.
-- Column names match mobile_app's ExamSummary/ExamQuestion.fromJson
-- exactly (id, status, time_limit_minutes, question_photo, etc.).
create view public.exam_results_view with (security_invoker = false) as
  select
    e.id as id,
    e.user_id,
    e.category,
    e.language_used,
    e.total_questions,
    e.time_limit_minutes,
    e.status,
    e.score,
    e.percentage,
    e.started_at,
    e.submitted_at,
    r.id as response_id,
    r.order_num as "order",
    r.question_id,
    r.selected_answer,
    r.is_correct,
    public.localize(q.question_en, q.question_ph, q.question_hl, e.language_used) as question,
    q.question_photo_url as question_photo,
    public.localize(q.option_a_en, q.option_a_ph, q.option_a_hl, e.language_used) as option_a,
    q.option_a_photo_url as option_a_photo,
    public.localize(q.option_b_en, q.option_b_ph, q.option_b_hl, e.language_used) as option_b,
    q.option_b_photo_url as option_b_photo,
    public.localize(q.option_c_en, q.option_c_ph, q.option_c_hl, e.language_used) as option_c,
    q.option_c_photo_url as option_c_photo,
    q.correct_answer,
    public.localize(q.explanation_en, q.explanation_ph, q.explanation_hl, e.language_used) as explanation,
    public.question_translations(q, true) as translations
  from public.exams e
  join public.exam_responses r on r.exam_id = e.id
  join public.questions q on q.id = r.question_id
  where e.status = 'completed'
    and (e.user_id = auth.uid() or public.is_admin())
  order by e.id, r.order_num;

grant select on public.exam_results_view to authenticated;

-- ---------------------------------------------------------------------
-- start_exam: mirrors exams.views.StartExamView + Exam.build_question_set.
-- Returns { "exam": {...ExamSummary}, "questions": [...ExamQuestion] }
-- WITHOUT correct_answer/explanation, matching ExamSession.fromJson.
-- ---------------------------------------------------------------------

create function public.start_exam(
  p_category text,
  p_language text default 'en',
  p_num_questions int default null,
  p_time_limit_minutes int default null
) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  v_user uuid := auth.uid();
  v_exam_id bigint;
  v_question_ids bigint[];
  v_count int;
  v_default_counts jsonb := '{"student": 40, "non_professional": 40, "professional": 60}'::jsonb;
begin
  if v_user is null then
    raise exception 'Not authenticated' using errcode = '28000';
  end if;

  if p_num_questions is null then
    p_num_questions := (v_default_counts ->> p_category)::int;
  end if;

  select array_agg(id) into v_question_ids
  from (
    select id from public.questions
    where is_active = true and (category = p_category or category = 'all')
    order by random()
    limit p_num_questions
  ) pool;

  v_count := coalesce(array_length(v_question_ids, 1), 0);
  if v_count = 0 then
    raise exception 'No questions are available for this category yet.' using errcode = 'P0001';
  end if;

  insert into public.exams (user_id, category, language_used, total_questions, time_limit_minutes)
  values (v_user, p_category, p_language, v_count, p_time_limit_minutes)
  returning id into v_exam_id;

  insert into public.exam_responses (exam_id, question_id, order_num)
  select v_exam_id, qid, row_number() over ()
  from unnest(v_question_ids) as qid;

  return jsonb_build_object(
    'exam', (
      select jsonb_build_object(
        'id', id, 'category', category, 'language_used', language_used,
        'total_questions', total_questions, 'time_limit_minutes', time_limit_minutes,
        'status', status, 'score', score, 'percentage', percentage,
        'started_at', started_at, 'submitted_at', submitted_at
      )
      from public.exams where id = v_exam_id
    ),
    'questions', (
      select jsonb_agg(jsonb_build_object(
        'response_id', r.id,
        'order', r.order_num,
        'question_id', q.id,
        'question', public.localize(q.question_en, q.question_ph, q.question_hl, p_language),
        'question_photo', q.question_photo_url,
        'option_a', public.localize(q.option_a_en, q.option_a_ph, q.option_a_hl, p_language),
        'option_a_photo', q.option_a_photo_url,
        'option_b', public.localize(q.option_b_en, q.option_b_ph, q.option_b_hl, p_language),
        'option_b_photo', q.option_b_photo_url,
        'option_c', public.localize(q.option_c_en, q.option_c_ph, q.option_c_hl, p_language),
        'option_c_photo', q.option_c_photo_url,
        'translations', public.question_translations(q, false)
      ) order by r.order_num)
      from public.exam_responses r
      join public.questions q on q.id = r.question_id
      where r.exam_id = v_exam_id
    )
  );
end;
$$;

grant execute on function public.start_exam(text, text, int, int) to authenticated;

-- ---------------------------------------------------------------------
-- submit_exam: mirrors exams.views.SubmitExamView. Grades every response
-- in one set-based UPDATE (not a per-row loop), marks the exam completed,
-- and returns a FLAT result WITH correct_answer/explanation, matching
-- ExamResult.fromJson (which reads ExamSummary fields straight off the
-- top-level object, plus a `responses` array).
-- ---------------------------------------------------------------------

create function public.submit_exam(
  p_exam_id bigint,
  p_answers jsonb, -- [{"question_id": 5, "selected_answer": "b"}, ...]
  p_time_taken_seconds int default null
) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  v_user uuid := auth.uid();
  v_exam public.exams;
  v_now timestamptz := now();
  v_score int;
begin
  if v_user is null then
    raise exception 'Not authenticated' using errcode = '28000';
  end if;

  select * into v_exam from public.exams where id = p_exam_id for update;
  if v_exam is null then
    raise exception 'Exam not found' using errcode = 'P0002';
  end if;
  if v_exam.user_id <> v_user and not public.is_admin() then
    raise exception 'Not your exam.' using errcode = '42501';
  end if;
  if v_exam.status = 'completed' then
    raise exception 'This exam has already been submitted.' using errcode = 'P0001';
  end if;

  update public.exam_responses er
  set selected_answer = a.selected_answer,
      answered_at = v_now,
      is_correct = (a.selected_answer = q.correct_answer)
  from jsonb_to_recordset(p_answers) as a(question_id bigint, selected_answer text),
       public.questions q
  where er.exam_id = p_exam_id
    and er.question_id = a.question_id
    and q.id = a.question_id;

  select count(*) into v_score
  from public.exam_responses
  where exam_id = p_exam_id and is_correct = true;

  update public.exams
  set score = v_score, status = 'completed', submitted_at = v_now
  where id = p_exam_id;

  -- Triggers the exam-completed email via the Database Webhook set up in
  -- phase 3 (fires on this same UPDATE, status -> 'completed').

  return (
    select jsonb_build_object(
      'id', v.id, 'category', v.category, 'language_used', v.language_used,
      'total_questions', v.total_questions, 'time_limit_minutes', v.time_limit_minutes,
      'status', v.status, 'score', v.score, 'percentage', v.percentage,
      'started_at', v.started_at, 'submitted_at', v.submitted_at,
      'responses', jsonb_agg(jsonb_build_object(
        'response_id', v.response_id, 'order', v."order", 'question_id', v.question_id,
        'selected_answer', v.selected_answer, 'is_correct', v.is_correct,
        'question', v.question, 'question_photo', v.question_photo,
        'option_a', v.option_a, 'option_a_photo', v.option_a_photo,
        'option_b', v.option_b, 'option_b_photo', v.option_b_photo,
        'option_c', v.option_c, 'option_c_photo', v.option_c_photo,
        'correct_answer', v.correct_answer, 'explanation', v.explanation,
        'translations', v.translations
      ) order by v."order")
    )
    from public.exam_results_view v
    where v.id = p_exam_id
    group by v.id, v.category, v.language_used, v.total_questions, v.time_limit_minutes,
             v.status, v.score, v.percentage, v.started_at, v.submitted_at
  );
end;
$$;

grant execute on function public.submit_exam(bigint, jsonb, int) to authenticated;
