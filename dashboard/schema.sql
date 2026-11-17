-- EAGLE EMERGENCY SECURITY - Dashibodi: jedwali na ulinzi (RLS)
-- Unaweza kuiendesha mara nyingi (haivunji data). Supabase > SQL Editor > New query > Paste > Run

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text not null default 'msimamizi' check (role in ('admin','msimamizi'))
);
create table if not exists public.clients (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz default now()
);
create table if not exists public.contracts (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null unique references public.clients(id) on delete cascade,
  guards_required int not null default 0,
  monthly_fee numeric not null default 0,
  end_date date
);
create table if not exists public.guards (
  id uuid primary key default gen_random_uuid(),
  code text unique,
  full_name text not null,
  phone text,
  client_id uuid references public.clients(id) on delete set null,
  status text not null default 'Kazini' check (status in ('Kazini','Likizo','Amesimamishwa')),
  created_at timestamptz default now()
);
create table if not exists public.attendance (
  id uuid primary key default gen_random_uuid(),
  guard_id uuid not null references public.guards(id) on delete cascade,
  work_date date not null,
  status text not null check (status in ('P','L','A')),
  marked_by uuid default auth.uid() references auth.users(id),
  unique (guard_id, work_date)
);

-- Nyaraka: nukuu, ankara, hati ya kukabidhi, risiti
drop table if exists public.invoices;   -- jedwali la zamani la ankara rahisi
create table if not exists public.documents (
  id uuid primary key default gen_random_uuid(),
  doc_type text not null check (doc_type in ('quotation','invoice','delivery_note','receipt')),
  doc_number text not null unique,
  client_id uuid not null references public.clients(id) on delete restrict,
  parent_id uuid references public.documents(id) on delete set null,
  issue_date date not null default current_date,
  due_date date,
  items jsonb not null default '[]',
  vat_percent numeric not null default 0,
  discount numeric not null default 0,
  amount_paid numeric not null default 0,
  pay_method text,
  pay_ref text,
  notes text,
  status text not null default 'draft' check (status in ('draft','sent','accepted','rejected','cancelled')),
  created_at timestamptz default now()
);
-- Mipangilio ya kampuni, benki na pesa ya simu (safu moja tu)
create table if not exists public.settings (
  id int primary key default 1 check (id = 1),
  company jsonb not null default '{}',
  banks jsonb not null default '[]',
  mobile jsonb not null default '[]'
);
insert into public.settings (id) values (1) on conflict do nothing;
-- Stoo
create table if not exists public.stock_items (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  unit text not null default 'pcs',
  reorder_level numeric not null default 0,
  created_at timestamptz default now()
);
create table if not exists public.stock_moves (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null references public.stock_items(id) on delete cascade,
  kind text not null check (kind in ('in','out','adjust')),
  qty numeric not null,
  move_date date not null default current_date,
  note text,
  created_at timestamptz default now()
);

create or replace function public.my_role() returns text
language sql stable security definer set search_path = public as
$$ select role from public.profiles where id = auth.uid() $$;

alter table public.profiles    enable row level security;
alter table public.clients     enable row level security;
alter table public.contracts   enable row level security;
alter table public.guards      enable row level security;
alter table public.attendance  enable row level security;
alter table public.documents   enable row level security;
alter table public.settings    enable row level security;
alter table public.stock_items enable row level security;
alter table public.stock_moves enable row level security;

-- futa sheria za zamani, kisha weka mpya (salama kuendesha tena)
do $$ declare r record; begin
  for r in select policyname, tablename from pg_policies where schemaname = 'public' loop
    execute format('drop policy %I on public.%I', r.policyname, r.tablename);
  end loop;
end $$;

create policy p_sel on public.profiles for select to authenticated using (id = auth.uid() or public.my_role() = 'admin');
create policy p_adm on public.profiles for all    to authenticated using (public.my_role() = 'admin') with check (public.my_role() = 'admin');
-- wateja na walinzi: wafanyakazi wote wanasoma; admin anaandika na kufuta
create policy c_sel on public.clients for select to authenticated using (public.my_role() is not null);
create policy c_adm on public.clients for all    to authenticated using (public.my_role() = 'admin') with check (public.my_role() = 'admin');
create policy g_sel on public.guards  for select to authenticated using (public.my_role() is not null);
create policy g_adm on public.guards  for all    to authenticated using (public.my_role() = 'admin') with check (public.my_role() = 'admin');
-- fedha, nyaraka, mipangilio na stoo: admin pekee
create policy k_adm  on public.contracts   for all to authenticated using (public.my_role() = 'admin') with check (public.my_role() = 'admin');
create policy d_adm  on public.documents   for all to authenticated using (public.my_role() = 'admin') with check (public.my_role() = 'admin');
create policy s_adm  on public.settings    for all to authenticated using (public.my_role() = 'admin') with check (public.my_role() = 'admin');
create policy si_adm on public.stock_items for all to authenticated using (public.my_role() = 'admin') with check (public.my_role() = 'admin');
create policy sm_adm on public.stock_moves for all to authenticated using (public.my_role() = 'admin') with check (public.my_role() = 'admin');
-- mahudhurio: wafanyakazi wote wanasoma na kuweka; admin pekee anafuta
create policy a_sel on public.attendance for select to authenticated using (public.my_role() is not null);
create policy a_ins on public.attendance for insert to authenticated with check (public.my_role() is not null);
create policy a_upd on public.attendance for update to authenticated using (public.my_role() is not null) with check (public.my_role() is not null);
create policy a_del on public.attendance for delete to authenticated using (public.my_role() = 'admin');

-- BAADA ya kutengeneza mtumiaji wa kwanza (Authentication > Users), mfanye admin:
-- insert into public.profiles (id, full_name, role)
-- select id, 'John Fabian Mfoi', 'admin' from auth.users where email = 'BARUA-PEPE-YAKO';
