-- Wasatch Haul Co. — quote requests
-- Paste this whole file into Supabase > SQL Editor > New query, then click Run.

-- 1. The table every quote request lands in
create table if not exists public.quotes (
  id            uuid primary key default gen_random_uuid(),
  created_at    timestamptz not null default now(),
  name          text not null check (char_length(name) between 1 and 120),
  phone         text not null check (char_length(phone) between 7 and 30),
  city          text,
  customer_type text,
  load_size     text,
  saturday      text,
  time_window   text,
  notes         text check (char_length(notes) <= 2000),
  photo_path    text,
  status        text not null default 'new'   -- change to quoted / booked / done as you work
);

-- 2. Lock it down: the public website may ADD a quote, but nobody can read the list
--    except you (you see everything in the Supabase dashboard).
alter table public.quotes enable row level security;

drop policy if exists "Website can submit quotes" on public.quotes;
create policy "Website can submit quotes"
  on public.quotes for insert
  to anon
  with check (status = 'new');

-- 3. A private bucket for the optional photo of the pile
insert into storage.buckets (id, name, public)
values ('quote-photos', 'quote-photos', false)
on conflict (id) do nothing;

drop policy if exists "Website can upload quote photos" on storage.objects;
create policy "Website can upload quote photos"
  on storage.objects for insert
  to anon
  with check (bucket_id = 'quote-photos');
