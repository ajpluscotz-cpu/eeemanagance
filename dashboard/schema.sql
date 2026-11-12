-- EAGLE EMERGENCY SECURITY - Dashibodi: jedwali na ulinzi (RLS)
-- Endesha kwenye Supabase: SQL Editor > New query > Paste > Run

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text not null default 'msimamizi' check (role in ('admin','msimamizi'))
);
create table public.clients (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz default now()
);
create table public.contracts (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null unique references public.clients(id) on delete cascade,
  guards_required int not null default 0,
  monthly_fee numeric not null default 0,
  end_date date
);
create table public.guards (
  id uuid primary key default gen_random_uuid(),
  code text unique,
  full_name text not null,
  phone text,
  client_id uuid references public.clients(id) on delete set null,
  status text not null default 'Kazini' check (status in ('Kazini','Likizo','Amesimamishwa')),
  created_at timestamptz default now()
);
create table public.attendance (
  id uuid primary key default gen_random_uuid(),
  guard_id uuid not null references public.guards(id) on delete cascade,
  work_date date not null,
  status text not null check (status in ('P','L','A')),
  marked_by uuid default auth.uid() references auth.users(id),
  unique (guard_id, work_date)
);
create table public.invoices (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references public.clients(id) on delete cascade,
  amount numeric not null,
  due_date date not null,
  paid_at date,
  note text,
  created_at timestamptz default now()
);

create or replace function public.my_role() returns text
language sql stable security definer set search_path = public as
$$ select role from public.profiles where id = auth.uid() $$;

alter table public.profiles   enable row level security;
alter table public.clients    enable row level security;
alter table public.contracts  enable row level security;
alter table public.guards     enable row level security;
alter table public.attendance enable row level security;
alter table public.invoices   enable row level security;

-- profiles: kila mtu anaona yake; admin anasimamia zote
create policy p_sel on public.profiles for select to authenticated using (id = auth.uid() or public.my_role() = 'admin');
create policy p_adm on public.profiles for all    to authenticated using (public.my_role() = 'admin') with check (public.my_role() = 'admin');
-- clients na guards: wafanyakazi wote wanasoma; admin anaandika
create policy c_sel on public.clients for select to authenticated using (public.my_role() is not null);
create policy c_adm on public.clients for all    to authenticated using (public.my_role() = 'admin') with check (public.my_role() = 'admin');
create policy g_sel on public.guards  for select to authenticated using (public.my_role() is not null);
create policy g_adm on public.guards  for all    to authenticated using (public.my_role() = 'admin') with check (public.my_role() = 'admin');
-- mikataba na malipo: admin pekee (siri za fedha)
create policy k_adm on public.contracts for all to authenticated using (public.my_role() = 'admin') with check (public.my_role() = 'admin');
create policy i_adm on public.invoices  for all to authenticated using (public.my_role() = 'admin') with check (public.my_role() = 'admin');
-- mahudhurio: wafanyakazi wote wanasoma na kuweka; admin pekee anafuta
create policy a_sel on public.attendance for select to authenticated using (public.my_role() is not null);
create policy a_ins on public.attendance for insert to authenticated with check (public.my_role() is not null);
create policy a_upd on public.attendance for update to authenticated using (public.my_role() is not null) with check (public.my_role() is not null);
create policy a_del on public.attendance for delete to authenticated using (public.my_role() = 'admin');

-- BAADA ya kutengeneza mtumiaji wa kwanza (Authentication > Users), mfanye admin:
-- insert into public.profiles (id, full_name, role)
-- select id, 'John Fabian Mfoi', 'admin' from auth.users where email = 'BARUA-PEPE-YAKO';
