# Supabase Setup

## Create the development project

In the Supabase dashboard, create a project with:

- **Project name:** `3iii-copilot-dev`
- **Region:** Singapore
- **Environment:** development only

Keep production separate. Use Supabase's password manager/secret manager for the database password and provider credentials.

## Authentication

In **Authentication → Sign In / Providers**, enable Google, GitHub, and Azure (Microsoft). Configure each provider's client credentials in the dashboard and register the Supabase callback URL with that provider. Add the app's Android redirect URI to Supabase's allowed redirect URLs after choosing and configuring the Android application ID and deep-link scheme.

OAuth provider setup requires credentials from the respective provider consoles. Never commit those credentials.

## Database scripts — review before applying

The SQL files are in `database/`:

- `database/schema.sql`
- `database/rls.sql`
- `database/seed.sql`

**Do not run these scripts against a shared or production project as-is.** The current schema defines only a subset of the tables referenced by `rls.sql`, and `seed.sql` uses `project_type` while `schema.sql` defines `type`. Review and reconcile the schema, RLS policies, and seed data first; apply only to a disposable development project after validation. Prefer versioned Supabase migrations as the schema source of truth going forward.

## Storage buckets

Create two **private** buckets in **Storage**:

- `project-files`
- `exports`

`supabase/storage.sql` is an alternative for creating the buckets once. Check whether each bucket already exists before running it; the current inserts are not idempotent. Add and test object-level policies before allowing client access.

## App configuration

The Flutter app reads the Supabase project URL and **publishable/anon key** from Dart compile-time defines. Example:

```sh
cd mobile/flutter_app
flutter pub get
flutter gen-l10n
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLISHABLE_OR_ANON_KEY
```

The publishable/anon key is intended for client apps when Row Level Security is correctly enabled. **Never put the `service_role` key in Flutter, a client build, or a committed file.** Keep it only in trusted server-side environments. If a key has been exposed, rotate it in Supabase.

## Verify before sharing the project

- Test each OAuth sign-in and Android callback on a device.
- Verify table and Storage RLS using separate accounts, including attempts to read another user's data.
- Confirm no service-role key or provider secret is in Git history or app configuration.
- Keep development credentials and data separate from production.
