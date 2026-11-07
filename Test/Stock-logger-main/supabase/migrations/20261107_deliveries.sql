-- Run in the existing Supabase SQL editor for the live backend.
-- Creates a separate delivery register linked to sales; no changes to the POS RPC signature.
-- Assumes public.sales.id is uuid and public.profiles.id = auth.uid().
create extension if not exists pgcrypto;

create table if not exists public.deliveries (
  id uuid primary key default gen_random_uuid(),
  sale_id uuid unique references public.sales(id) on delete set null,
  order_reference text not null default '',
  buyer text not null check (length(trim(buyer)) > 0),
  address text not null check (length(trim(address)) > 0),
  phone text not null default '',
  target_date date,
  carrier text not null default '',
  tracking text not null default '',
  status text not null default 'Pending'
    check (status in ('Pending', 'Scheduled', 'Out for delivery', 'Delivered', 'Cancelled')),
  notes text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists deliveries_created_at_idx on public.deliveries(created_at desc);
create index if not exists deliveries_status_idx on public.deliveries(status);

create or replace function public.touch_delivery_updated_at()
returns trigger language plpgsql set search_path = '' as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists deliveries_touch_updated_at on public.deliveries;
create trigger deliveries_touch_updated_at
before update on public.deliveries
for each row execute function public.touch_delivery_updated_at();

alter table public.deliveries enable row level security;

drop policy if exists "Active team can read deliveries" on public.deliveries;
create policy "Active team can read deliveries" on public.deliveries
for select to authenticated
using (exists (
  select 1 from public.profiles p where p.id = (select auth.uid()) and p.active = true
));

drop policy if exists "Active team can create deliveries" on public.deliveries;
create policy "Active team can create deliveries" on public.deliveries
for insert to authenticated
with check (exists (
  select 1 from public.profiles p where p.id = (select auth.uid()) and p.active = true
));

drop policy if exists "Active team can update deliveries" on public.deliveries;
create policy "Active team can update deliveries" on public.deliveries
for update to authenticated
using (exists (
  select 1 from public.profiles p where p.id = (select auth.uid()) and p.active = true
))
with check (exists (
  select 1 from public.profiles p where p.id = (select auth.uid()) and p.active = true
));

grant select, insert, update on public.deliveries to authenticated;
