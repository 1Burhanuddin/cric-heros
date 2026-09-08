-- handle_new_user() only copied phone from auth.users into the new
-- public.users row, not email - fine when phone was the only sign-in
-- method, but now that Google and email/password sign-in are live,
-- auth.users.email is often the only identifying value available at
-- signup time. Without this, a fresh Google/email sign-up would show a
-- blank email in the profile until the user manually re-typed the same
-- email they just signed up with.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  -- auth.users.email is '' rather than null for phone-only signups -
  -- nullif() keeps public.users.email genuinely null in that case instead
  -- of an empty string.
  insert into public.users (id, phone, email)
  values (new.id, new.phone, nullif(new.email, ''))
  on conflict (id) do nothing;
  return new;
end;
$$;
