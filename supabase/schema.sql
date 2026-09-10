-- Conciergia plan — Supabase setup
-- Run this in the Supabase SQL editor (Dashboard → SQL Editor → New query).

-- 1. The table. The whole plan lives in one JSON document.
create table if not exists plan_state (
  id          text primary key,
  doc         jsonb not null,
  updated_at  timestamptz not null default now()
);

-- 2. Realtime, so Anna's edits reach Bobby's screen without a refresh.
alter publication supabase_realtime add table plan_state;

-- 3. Lock it down. Do this AFTER creating the two users, or you will
--    lock yourself out of your own table from the page.
alter table plan_state enable row level security;

create policy "signed-in read" on plan_state
  for select to authenticated using (true);

create policy "signed-in write" on plan_state
  for all to authenticated using (true) with check (true);

-- To check it worked: sign out in the app and reload. You should get the
-- login screen, and the browser network tab should show no plan data.
