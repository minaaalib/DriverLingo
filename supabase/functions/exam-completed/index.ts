// Fired by a Database Webhook on `exams` (UPDATE, status -> 'completed').
// Sends the "your results are in" email via Resend, replacing
// backend/accounts/emails.py's send_exam_completed_email - and like that
// fix, this runs fire-and-forget outside the submit_exam transaction, so
// it never adds latency to the exam-submission request itself.
//
// One-time setup in Supabase Studio:
//   1. Deploy this function: `supabase functions deploy exam-completed`
//      (needs the Supabase CLI linked to the project).
//   2. Edge Functions -> exam-completed -> Secrets: set RESEND_API_KEY
//      (from resend.com, free tier) and FROM_EMAIL
//      (e.g. "LTO Exam Reviewer <no-reply@yourdomain.com>").
//      SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY are provided automatically.
//   3. Database -> Webhooks -> New webhook: table `exams`, event UPDATE,
//      type "HTTP Request" pointed at this function's URL.

import { createClient } from "jsr:@supabase/supabase-js@2";

const CATEGORY_LABELS: Record<string, string> = {
  student: "Student Permit",
  non_professional: "Non-Professional",
  professional: "Professional",
};

const LANGUAGE_LABELS: Record<string, string> = {
  en: "English",
  ph: "Filipino",
  hl: "Hiligaynon",
};

Deno.serve(async (req) => {
  const payload = await req.json();
  const { record, old_record } = payload;

  // Only fire on the transition into 'completed', not every update to an
  // already-completed row.
  if (record?.status !== "completed" || old_record?.status === "completed") {
    return new Response("ignored", { status: 200 });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const { data: userData, error: userError } = await supabase.auth.admin.getUserById(record.user_id);
  if (userError || !userData?.user?.email) {
    console.error("exam-completed: could not load user for exam", record.id, userError);
    return new Response("no email", { status: 200 });
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("name")
    .eq("id", record.user_id)
    .single();

  const name = profile?.name || userData.user.email.split("@")[0];
  const category = CATEGORY_LABELS[record.category] ?? record.category;
  const language = LANGUAGE_LABELS[record.language_used] ?? record.language_used;

  const text = `Hi ${name},

You just completed a ${category} mock exam (${language}).

Score: ${record.score} / ${record.total_questions}

Open the app to review your answers and the correct answers for any questions you missed.

Keep practicing - good luck on your LTO exam!

- LTO Exam Reviewer Team`;

  const resendResp = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${Deno.env.get("RESEND_API_KEY")}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      from: Deno.env.get("FROM_EMAIL"),
      to: userData.user.email,
      subject: "Your LTO mock exam results are in",
      text,
    }),
  });

  if (!resendResp.ok) {
    console.error("exam-completed: resend error", await resendResp.text());
  }

  return new Response("ok", { status: 200 });
});
