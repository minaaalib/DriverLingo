-- Adds resume_exam(), letting a user pick an in_progress exam back up from
-- the History tab instead of only ever starting fresh. Returns the exact
-- same shape as start_exam() (see 0001_init.sql) so the client can reuse
-- ExamSession.fromJson unchanged, plus a `selected_answer` per question so
-- ExamScreen can prefill answers already given before the user left.
--
-- Additive only - safe to run against a project that already has real
-- user data. Does not touch any existing table, policy, or function.

drop function if exists public.resume_exam(bigint);

create function public.resume_exam(p_exam_id bigint)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  v_user uuid := auth.uid();
begin
  if v_user is null then
    raise exception 'Not authenticated' using errcode = '28000';
  end if;

  if not exists (
    select 1 from public.exams
    where id = p_exam_id and user_id = v_user and status = 'in_progress'
  ) then
    raise exception 'Exam not found or no longer in progress.' using errcode = 'P0001';
  end if;

  return jsonb_build_object(
    'exam', (
      select jsonb_build_object(
        'id', id, 'category', category, 'language_used', language_used,
        'total_questions', total_questions, 'time_limit_minutes', time_limit_minutes,
        'status', status, 'score', score, 'percentage', percentage,
        'started_at', started_at, 'submitted_at', submitted_at
      )
      from public.exams where id = p_exam_id
    ),
    'questions', (
      select jsonb_agg(jsonb_build_object(
        'response_id', r.id,
        'order', r.order_num,
        'question_id', q.id,
        'question', public.localize(q.question_en, q.question_ph, q.question_hl, e.language_used),
        'question_photo', q.question_photo_url,
        'option_a', public.localize(q.option_a_en, q.option_a_ph, q.option_a_hl, e.language_used),
        'option_a_photo', q.option_a_photo_url,
        'option_b', public.localize(q.option_b_en, q.option_b_ph, q.option_b_hl, e.language_used),
        'option_b_photo', q.option_b_photo_url,
        'option_c', public.localize(q.option_c_en, q.option_c_ph, q.option_c_hl, e.language_used),
        'option_c_photo', q.option_c_photo_url,
        'selected_answer', r.selected_answer,
        'translations', public.question_translations(q, false)
      ) order by r.order_num)
      from public.exam_responses r
      join public.questions q on q.id = r.question_id
      join public.exams e on e.id = r.exam_id
      where r.exam_id = p_exam_id
    )
  );
end;
$$;

grant execute on function public.resume_exam(bigint) to authenticated;
