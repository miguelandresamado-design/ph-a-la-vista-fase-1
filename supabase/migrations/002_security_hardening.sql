-- pH a la vista · endurecimiento previo al piloto
-- Ejecutar después de 001_schema.sql.

alter table public.sampling_sessions
  add column if not exists received_at timestamptz not null default now();

alter table public.measurements
  add column if not exists received_at timestamptz not null default now();

alter table public.lots
  drop constraint if exists lots_name_length_check;
alter table public.lots
  add constraint lots_name_length_check check (char_length(btrim(name)) between 1 and 80);

alter table public.lots
  drop constraint if exists lots_area_upper_bound_check;
alter table public.lots
  add constraint lots_area_upper_bound_check check (area_ha is null or area_ha <= 10000);

alter table public.lots
  drop constraint if exists lots_planting_year_check;
alter table public.lots
  add constraint lots_planting_year_check check (planting_year is null or planting_year between 1900 and 2100);

alter table public.lots
  drop constraint if exists lots_pilot_crop_check;
alter table public.lots
  add constraint lots_pilot_crop_check check (crop = 'coffee');

create unique index if not exists lots_farm_name_ci_unique
  on public.lots(farm_id, lower(btrim(name)));

alter table public.measurements
  drop constraint if exists measurements_pilot_source_check;
alter table public.measurements
  add constraint measurements_pilot_source_check check (source in ('manual', 'bluetooth'));

create or replace function public.is_admin() returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists(
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  )
$$;

create or replace function public.is_assigned(target_farm uuid) returns boolean
language sql stable security definer set search_path = ''
as $$
  select public.is_admin() or exists(
    select 1 from public.farm_assignments
    where profile_id = auth.uid() and farm_id = target_farm
  )
$$;

create or replace function public.protect_lot_identity() returns trigger
language plpgsql set search_path = ''
as $$
begin
  if tg_op = 'INSERT' then
    new.name := btrim(new.name);
    new.created_at := now();
    new.updated_at := now();
  else
    if new.farm_id is distinct from old.farm_id then
      raise exception 'Un lote no puede moverse a otra finca';
    end if;
    if new.crop is distinct from old.crop then
      raise exception 'El cultivo del lote no puede modificarse en esta fase';
    end if;
    new.name := btrim(new.name);
    new.created_at := old.created_at;
    new.updated_at := now();
  end if;
  return new;
end;
$$;

drop trigger if exists lots_keep_farm on public.lots;
drop trigger if exists lots_protect_identity on public.lots;
create trigger lots_protect_identity
before insert or update on public.lots
for each row execute function public.protect_lot_identity();

create or replace function public.validate_sampling_session_scope() returns trigger
language plpgsql set search_path = ''
as $$
declare
  farm_country text;
  lot_farm uuid;
  campaign_country text;
  technician_country text;
  device_owner uuid;
begin
  select country_id into technician_country
  from public.profiles where id = new.technician_id;

  select country_id into farm_country
  from public.farms where id = new.farm_id;

  select farm_id into lot_farm
  from public.lots where id = new.lot_id;

  if technician_country is null
     or technician_country is distinct from new.country_id
     or farm_country is distinct from new.country_id
     or lot_farm is distinct from new.farm_id then
    raise exception 'La jornada no coincide con el técnico, país, finca y lote autorizados';
  end if;

  if new.campaign_id is not null then
    select country_id into campaign_country
    from public.monitoring_campaigns where id = new.campaign_id;
    if campaign_country is distinct from new.country_id then
      raise exception 'La campaña no pertenece al país de la jornada';
    end if;
  end if;

  if new.device_id is not null then
    select user_id into device_owner
    from public.devices where id = new.device_id;
    if device_owner is distinct from new.technician_id then
      raise exception 'El dispositivo no pertenece al técnico de la jornada';
    end if;
  end if;

  if tg_op = 'INSERT' then
    new.received_at := now();
  elsif auth.uid() is not null and not public.is_admin() and (
    new.technician_id is distinct from old.technician_id
    or new.country_id is distinct from old.country_id
    or new.farm_id is distinct from old.farm_id
    or new.lot_id is distinct from old.lot_id
    or new.campaign_id is distinct from old.campaign_id
    or new.device_id is distinct from old.device_id
    or new.target_samples is distinct from old.target_samples
    or new.started_at is distinct from old.started_at
  ) then
    raise exception 'La identidad de una jornada iniciada no puede modificarse';
  end if;

  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists sessions_validate_scope on public.sampling_sessions;
create trigger sessions_validate_scope
before insert or update on public.sampling_sessions
for each row execute function public.validate_sampling_session_scope();

create or replace function public.validate_measurement_scope() returns trigger
language plpgsql set search_path = ''
as $$
declare
  linked_session public.sampling_sessions%rowtype;
begin
  if new.session_id is null then
    if new.farm_id is not null
       or new.lot_id is not null
       or new.campaign_id is not null
       or new.sample_number is not null then
      raise exception 'Una medición individual no puede atribuirse a finca, lote, campaña o punto';
    end if;
  else
    select * into linked_session
    from public.sampling_sessions where id = new.session_id;

    if not found
       or new.technician_id is distinct from linked_session.technician_id
       or new.country_id is distinct from linked_session.country_id
       or new.farm_id is distinct from linked_session.farm_id
       or new.lot_id is distinct from linked_session.lot_id
       or new.campaign_id is distinct from linked_session.campaign_id
       or new.sample_number is null then
      raise exception 'La medición no coincide con la jornada, técnico, finca, lote o campaña';
    end if;
  end if;

  if tg_op = 'INSERT' then
    new.received_at := now();
  elsif auth.uid() is not null and not public.is_admin() and (
    new.session_id is distinct from old.session_id
    or new.technician_id is distinct from old.technician_id
    or new.country_id is distinct from old.country_id
    or new.farm_id is distinct from old.farm_id
    or new.lot_id is distinct from old.lot_id
    or new.campaign_id is distinct from old.campaign_id
    or new.sample_number is distinct from old.sample_number
    or new.ph is distinct from old.ph
    or new.temperature_c is distinct from old.temperature_c
    or new.latitude is distinct from old.latitude
    or new.longitude is distinct from old.longitude
    or new.gps_accuracy_m is distinct from old.gps_accuracy_m
    or new.source is distinct from old.source
    or new.captured_at is distinct from old.captured_at
  ) then
    raise exception 'Una medición sincronizada es inmutable';
  end if;

  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists measurements_validate_scope on public.measurements;
create trigger measurements_validate_scope
before insert or update on public.measurements
for each row execute function public.validate_measurement_scope();

drop policy if exists measurements_insert_own on public.measurements;
create policy measurements_insert_own on public.measurements for insert with check (
  technician_id = auth.uid()
  and country_id = (select country_id from public.profiles where id = auth.uid())
  and (
    (
      session_id is null and farm_id is null and lot_id is null
      and campaign_id is null and sample_number is null
    )
    or exists (
      select 1 from public.sampling_sessions s
      where s.id = measurements.session_id
        and s.technician_id = auth.uid()
        and s.country_id = measurements.country_id
        and s.farm_id = measurements.farm_id
        and s.lot_id = measurements.lot_id
        and s.campaign_id is not distinct from measurements.campaign_id
        and public.is_assigned(s.farm_id)
    )
  )
);

drop policy if exists measurements_update_own on public.measurements;
create policy measurements_update_own on public.measurements for update
using (technician_id = auth.uid() or public.is_admin())
with check (
  public.is_admin() or (
    technician_id = auth.uid()
    and country_id = (select country_id from public.profiles where id = auth.uid())
    and (
      (
        session_id is null and farm_id is null and lot_id is null
        and campaign_id is null and sample_number is null
      )
      or exists (
        select 1 from public.sampling_sessions s
        where s.id = measurements.session_id
          and s.technician_id = auth.uid()
          and s.country_id = measurements.country_id
          and s.farm_id = measurements.farm_id
          and s.lot_id = measurements.lot_id
          and s.campaign_id is not distinct from measurements.campaign_id
          and public.is_assigned(s.farm_id)
      )
    )
  )
);

create or replace function public.capture_audit_event() returns trigger
language plpgsql security definer set search_path = ''
as $$
declare
  target_id uuid;
  target_farm uuid;
begin
  target_id := case when tg_op = 'DELETE' then old.id else new.id end;
  target_farm := case when tg_op = 'DELETE' then old.farm_id else new.farm_id end;

  insert into public.audit_events(user_id, entity, record_id, action, detail)
  values (
    auth.uid(),
    tg_table_name,
    target_id,
    lower(tg_op),
    jsonb_build_object('farm_id', target_farm)
  );
  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end;
$$;

drop trigger if exists lots_audit on public.lots;
create trigger lots_audit after insert or update on public.lots
for each row execute function public.capture_audit_event();

drop trigger if exists sessions_audit on public.sampling_sessions;
create trigger sessions_audit after insert or update on public.sampling_sessions
for each row execute function public.capture_audit_event();

drop trigger if exists measurements_audit on public.measurements;
create trigger measurements_audit after insert or update on public.measurements
for each row execute function public.capture_audit_event();

drop policy if exists audit_insert_own on public.audit_events;

revoke all on function public.is_admin() from public, anon;
revoke all on function public.is_assigned(uuid) from public, anon;
grant execute on function public.is_admin() to authenticated, service_role;
grant execute on function public.is_assigned(uuid) to authenticated, service_role;
revoke all on function public.protect_lot_identity() from public, anon, authenticated;
revoke all on function public.validate_sampling_session_scope() from public, anon, authenticated;
revoke all on function public.validate_measurement_scope() from public, anon, authenticated;
revoke all on function public.capture_audit_event() from public, anon, authenticated;

revoke all privileges on all tables in schema public from anon;
revoke all privileges on public.countries, public.profiles, public.farms,
  public.farm_assignments, public.lots, public.monitoring_campaigns,
  public.devices, public.sampling_sessions, public.measurements,
  public.audit_events from authenticated;

grant select on public.countries, public.profiles, public.farms,
  public.farm_assignments, public.monitoring_campaigns, public.audit_events
  to authenticated;
grant select, insert, update on public.lots, public.sampling_sessions,
  public.measurements to authenticated;
grant select, insert, update, delete on public.devices to authenticated;
