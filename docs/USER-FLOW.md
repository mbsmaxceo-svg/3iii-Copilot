# User Flow / ขั้นตอนการใช้งาน

## MVP flow

1. **Open the app / เปิดแอป** — choose English or Thai (or follow the device locale).
2. **Sign in / เข้าสู่ระบบ** — authenticate with Google, GitHub, or Microsoft through Supabase Auth.
3. **Home / หน้าหลัก** — see a workspace overview and recent projects.
4. **Projects / โปรเจ็กต์** — browse and search projects; open a project to work in its isolated context.
5. **Profile / โปรไฟล์** — review the signed-in account or sign out.

## Sprint 1 screen map

```text
Unauthenticated → Authentication screen
Authenticated   → Home screen
Bottom navigation: Home | Projects | Profile
```

The current Flutter skeleton provides the screens, localized labels, OAuth entry points, and local preview project cards. Project CRUD, persistent workspace data, and project navigation are not implemented yet; connect them through repositories backed by Supabase after the database schema and RLS are reconciled.

## Safety boundaries

- A signed-in user should only see their own workspace and projects.
- Do not expose provider secrets or the Supabase service-role key in the app.
- Treat imported `.3iii` content as data; validate it before use and never execute it.

---

## ภาษาไทย

1. **เปิดแอป** — เลือกภาษาไทยหรือ English หรือใช้ภาษาตามอุปกรณ์
2. **เข้าสู่ระบบ** — ใช้ Google, GitHub หรือ Microsoft ผ่าน Supabase Auth
3. **หน้าหลัก** — ดูภาพรวม workspace และโปรเจ็กต์ล่าสุด
4. **โปรเจ็กต์** — ค้นหาและเลือกโปรเจ็กต์ โดยแยกบริบทของแต่ละโปรเจ็กต์
5. **โปรไฟล์** — ตรวจสอบบัญชีหรือออกจากระบบ

โครงสร้าง Flutter รุ่นเริ่มต้นมีหน้าจอ ป้ายกำกับสองภาษา จุดเริ่มต้น OAuth และรายการตัวอย่างในเครื่องเท่านั้น ยังไม่มี CRUD หรือการจัดเก็บโปรเจ็กต์จริง ต้องเชื่อมต่อ Supabase หลังจากปรับ schema และ RLS ให้สอดคล้องกันแล้ว
