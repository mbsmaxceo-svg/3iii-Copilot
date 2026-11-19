# 3iii-Copilot Flutter app

This is the Flutter Sprint 1 skeleton for the Android-first app: Supabase OAuth entry screen, localized Home/Projects/Profile screens, and bottom navigation. Home project cards are local previews; persistent project CRUD and a project repository are not implemented yet.

## Requirements

- Flutter SDK supporting Dart 3.3 or later
- A development Supabase project for OAuth sign-in

## Run

```sh
flutter pub get
flutter gen-l10n
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLISHABLE_OR_ANON_KEY
```

Without the two compile-time values, the app opens in setup mode and disables sign-in. Never use a Supabase `service_role` key as the app key.

## Localization

User-facing strings are in `lib/l10n/app_en.arb` and `lib/l10n/app_th.arb`. After editing ARB files, run `flutter gen-l10n` before analyze/build.

## OAuth callback setup

The app currently requests `io.supabase.iii_copilot://login-callback`. Configure the matching callback/redirect in Supabase Auth and the Android app's deep-link intent filter before testing provider sign-in on device. Provider credentials belong in the Supabase dashboard, not this repository.

## Current limitations

- Projects are localized local preview data, not loaded from Supabase.
- Authentication screens call Supabase OAuth; project data access and profile details are not wired up.
- Reconcile and validate `database/schema.sql`, `database/rls.sql`, and `database/seed.sql` before applying them; see `supabase/SETUP.md`.

Run `flutter analyze` and `flutter test` after setup when Flutter is installed.
