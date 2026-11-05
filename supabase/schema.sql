-- Gumboot Project — schéma initial
-- À exécuter dans Supabase SQL Editor après création du projet.
create extension if not exists pgcrypto;

create table if not exists public.group_members (
  user_id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null,
  role text not null default 'Membre',
  created_at timestamptz not null default now()
);
create or replace function public.is_group_member()
returns boolean language sql stable security definer set search_path = public
as $$ select exists(select 1 from public.group_members where user_id = auth.uid()); $$;

create table if not exists public.messages (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 author_name text, body text not null check(length(body) between 1 and 2000), created_at timestamptz not null default now()
);
create table if not exists public.research (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 title text not null, description text, source text, created_at timestamptz not null default now()
);
create table if not exists public.tasks (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 title text not null, assignee text, done boolean not null default false, created_at timestamptz not null default now()
);
create table if not exists public.events (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 title text not null, event_date date, created_at timestamptz not null default now()
);
create table if not exists public.media (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 title text not null, url text, created_at timestamptz not null default now()
);
create table if not exists public.steps (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 title text not null, description text, created_at timestamptz not null default now()
);
create table if not exists public.votes (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 title text not null, description text, options jsonb not null default '[]'::jsonb, created_at timestamptz not null default now()
);
create table if not exists public.vote_responses (
 id uuid primary key default gen_random_uuid(), vote_id uuid not null references public.votes(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade, choice integer not null,
 created_at timestamptz not null default now(), unique(vote_id,user_id)
);
create table if not exists public.dictionary (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 term text not null, definition text not null, created_at timestamptz not null default now()
);
create table if not exists public.files (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 title text not null, file_url text, created_at timestamptz not null default now()
);

alter table public.group_members enable row level security;
alter table public.messages enable row level security;
alter table public.research enable row level security;
alter table public.tasks enable row level security;
alter table public.events enable row level security;
alter table public.media enable row level security;
alter table public.steps enable row level security;
alter table public.votes enable row level security;
alter table public.vote_responses enable row level security;
alter table public.dictionary enable row level security;
alter table public.files enable row level security;

-- Membres uniquement : lecture de l'espace partagé. Chaque utilisateur écrit en son nom.
create policy "members can read group" on public.group_members for select to authenticated using (public.is_group_member());
create policy "members read messages" on public.messages for select to authenticated using (public.is_group_member());
create policy "members send messages" on public.messages for insert to authenticated with check (public.is_group_member() and user_id = auth.uid());
create policy "members read research" on public.research for select to authenticated using (public.is_group_member());
create policy "members add research" on public.research for insert to authenticated with check (public.is_group_member() and user_id = auth.uid());
create policy "members read tasks" on public.tasks for select to authenticated using (public.is_group_member());
create policy "members add tasks" on public.tasks for insert to authenticated with check (public.is_group_member() and user_id = auth.uid());
create policy "members read events" on public.events for select to authenticated using (public.is_group_member());
create policy "members add events" on public.events for insert to authenticated with check (public.is_group_member() and user_id = auth.uid());
create policy "members read media" on public.media for select to authenticated using (public.is_group_member());
create policy "members add media" on public.media for insert to authenticated with check (public.is_group_member() and user_id = auth.uid());
create policy "members read steps" on public.steps for select to authenticated using (public.is_group_member());
create policy "members add steps" on public.steps for insert to authenticated with check (public.is_group_member() and user_id = auth.uid());
create policy "members read votes" on public.votes for select to authenticated using (public.is_group_member());
create policy "members add votes" on public.votes for insert to authenticated with check (public.is_group_member() and user_id = auth.uid());
create policy "members read vote responses" on public.vote_responses for select to authenticated using (public.is_group_member());
create policy "members cast own vote" on public.vote_responses for insert to authenticated with check (public.is_group_member() and user_id = auth.uid());
create policy "members read dictionary" on public.dictionary for select to authenticated using (public.is_group_member());
create policy "members add dictionary" on public.dictionary for insert to authenticated with check (public.is_group_member() and user_id = auth.uid());
create policy "members read files" on public.files for select to authenticated using (public.is_group_member());
create policy "members add files" on public.files for insert to authenticated with check (public.is_group_member() and user_id = auth.uid());

-- Le profil de chaque membre est géré par un administrateur via le tableau de bord.
-- Ne jamais exposer la clé service_role dans le site.
alter publication supabase_realtime add table public.messages;
