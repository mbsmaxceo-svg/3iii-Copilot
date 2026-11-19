# Contributing to 3iii-Copilot / แนวทางการร่วมพัฒนา

Thanks for helping improve 3iii-Copilot. Please keep contributions focused and aligned with `docs/PRD.md` and `docs/ARCHITECTURE.md`.

## Getting started

- Review the product requirements, architecture, user flow, and security policy.
- For Flutter work, follow `mobile/flutter_app/README.md` and use the repository's Flutter/Supabase setup.
- Never commit secrets, local `.env` files, generated credentials, or real user data.

## Change guidelines

- Keep the product mobile-first and support Thai and English for user-facing app text. Add matching ARB entries rather than hard-coding widget strings.
- Preserve the product name `3iii-Copilot` and `.3iii` extension.
- Keep database changes aligned across schema, RLS, seed data, and migrations. Test ownership isolation; do not weaken RLS to make a client operation pass.
- Prefer small, reviewable changes and explain user-visible or security-sensitive behavior.

## Before opening a pull request

1. Run `flutter pub get` and `flutter gen-l10n` from `mobile/flutter_app` when changing the Flutter app.
2. Run `flutter analyze` and `flutter test` from `mobile/flutter_app` when Flutter is available.
3. Validate SQL against a disposable development Supabase project; never test destructive changes against production.
4. Describe the change, verification performed, and any setup or migration steps in the pull request.

Do not include credentials in pull request descriptions or screenshots.

---

## ภาษาไทย

ขอบคุณที่ร่วมพัฒนา 3iii-Copilot โปรดอ่าน `docs/PRD.md`, `docs/ARCHITECTURE.md`, `docs/USER-FLOW.md` และ `docs/SECURITY.md` ก่อนเริ่มงาน

ข้อความในแอปต้องรองรับภาษาไทยและ English ผ่าน ARB โดยเพิ่มคำแปลทั้งสองภาษา ห้าม commit secret หรือข้อมูลผู้ใช้จริง การเปลี่ยนฐานข้อมูลต้องสอดคล้องกันทั้ง schema, RLS, seed และ migration พร้อมทดสอบการแยกข้อมูลของผู้ใช้

ก่อนส่ง Pull Request ให้รัน `flutter pub get`, `flutter gen-l10n`, `flutter analyze` และ `flutter test` เมื่อมี Flutter SDK พร้อมระบุสิ่งที่ทดสอบและขั้นตอนตั้งค่าที่จำเป็น
