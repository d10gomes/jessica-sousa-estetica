-- Banco de dados das avaliações online (Centro Estético Jéssica Sousa)
-- Rode este arquivo uma vez no SQL Editor do Supabase.

-- Quem pode acessar o painel (e-mails da equipe autorizada)
create table if not exists public.admins (
  email text primary key
);
alter table public.admins enable row level security;
-- ninguém lê ou altera esta tabela pelo site; ela é mantida pelo painel do Supabase.

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.admins a
    where lower(a.email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;
revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

create table if not exists public.leads (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  atualizado_em timestamptz not null default now(),

  nome text not null check (char_length(nome) between 2 and 80),
  whatsapp text not null check (whatsapp ~ '^[0-9]{10,13}$'),
  cidade text check (char_length(cidade) <= 80),

  queixa text check (char_length(queixa) <= 60),
  tempo text check (char_length(tempo) <= 40),
  historico text check (char_length(historico) <= 80),
  condicoes text[] not null default '{}' check (cardinality(condicoes) <= 4),
  presencial text check (char_length(presencial) <= 40),
  inicio text check (char_length(inicio) <= 40),

  elegibilidade text not null default 'apta' check (elegibilidade in ('apta','avaliacao_especial','nao_indicado')),
  temperatura text not null default 'morna' check (temperatura in ('quente','morna','fria','contraindicado')),
  status text not null default 'novo' check (status in ('novo','em_conversa','avaliacao_agendada','cliente','nao_fechou','descartado')),
  observacoes text check (char_length(observacoes) <= 2000),

  utm_source text check (char_length(utm_source) <= 120),
  utm_medium text check (char_length(utm_medium) <= 120),
  utm_campaign text check (char_length(utm_campaign) <= 120),
  utm_content text check (char_length(utm_content) <= 120),
  utm_term text check (char_length(utm_term) <= 120),
  referrer text check (char_length(referrer) <= 200),

  consentimento_dados boolean not null,
  consentimento_saude boolean not null,
  consentimento_marketing boolean not null default false,
  consentimento_em timestamptz not null default now()
);

create index if not exists leads_created_at_idx on public.leads (created_at desc);
create index if not exists leads_status_idx on public.leads (status);

create or replace function public.leads_touch()
returns trigger language plpgsql set search_path = '' as $$
begin new.atualizado_em := now(); return new; end; $$;
drop trigger if exists leads_touch on public.leads;
create trigger leads_touch before update on public.leads
for each row execute function public.leads_touch();

alter table public.leads enable row level security;

-- O site (visitante anônimo) só pode CADASTRAR, nunca ler, alterar ou apagar.
drop policy if exists "site cadastra avaliacao" on public.leads;
create policy "site cadastra avaliacao" on public.leads
  for insert to anon
  with check (
    consentimento_dados = true
    and consentimento_saude = true
    and status = 'novo'
    and observacoes is null
  );

-- Somente a equipe autorizada (tabela admins) lê, atualiza e exclui pelo painel.
drop policy if exists "equipe le" on public.leads;
create policy "equipe le" on public.leads for select to authenticated using (public.is_admin());
drop policy if exists "equipe atualiza" on public.leads;
create policy "equipe atualiza" on public.leads for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "equipe exclui" on public.leads;
create policy "equipe exclui" on public.leads for delete to authenticated using (public.is_admin());

revoke all on public.leads from anon;
grant insert on public.leads to anon;
grant select, update, delete on public.leads to authenticated;
