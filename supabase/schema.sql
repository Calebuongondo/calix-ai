-- Calix AI community Ekegusii vocabulary table.
-- Run this in Supabase SQL Editor once a project is connected.
create table if not exists public.ekegusii_words (
  id uuid primary key default gen_random_uuid(),
  word text not null check (char_length(word) between 1 and 120),
  meaning text not null check (char_length(meaning) between 1 and 500),
  example text not null default '' check (char_length(example) <= 500),
  notes text not null default '' check (char_length(notes) <= 500),
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now()
);

alter table public.ekegusii_words enable row level security;

-- Public can only read approved dictionary entries.
drop policy if exists "Anyone can read approved words" on public.ekegusii_words;
create policy "Anyone can read approved words"
on public.ekegusii_words for select
to anon, authenticated
using (status = 'approved');

-- Anonymous community members may submit new words, but cannot self-approve.
drop policy if exists "Anyone can submit pending words" on public.ekegusii_words;
create policy "Anyone can submit pending words"
on public.ekegusii_words for insert
to anon, authenticated
with check (status = 'pending');

-- Moderation (approve/reject) is performed securely by project administrators in Supabase.
