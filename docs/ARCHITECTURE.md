# 3iii-Copilot Architecture

> สถานะ: ข้อเสนอสำหรับ MVP อ้างอิง PRD v1.0 และ `supabase/config.toml` ที่มีอยู่ ณ วันที่จัดทำ เอกสารนี้เป็นแนวทางสถาปัตยกรรม ไม่ได้หมายความว่าระบบทั้งหมดถูก implement แล้ว

## 1. เป้าหมายและขอบเขต

สถาปัตยกรรมนี้รองรับแอป Android-first สำหรับจัดการหลายโปรเจ็กต์ เขียนและจัดการไฟล์ สนทนากับ AI หลายผู้ให้บริการ และเชื่อมต่อ GitHub, Supabase และ Vercel โดยรักษาการแยกข้อมูลระหว่างโปรเจ็กต์และผู้ใช้

MVP ใช้ workspace ส่วนตัวต่อผู้ใช้ ยังไม่ทำ team workspace, marketplace, full workspace restore หรือ iOS/desktop ตาม Out Of Scope ใน PRD ส่วนการรันคำสั่ง terminal ต้องจำกัดใน sandbox และต้องขอความยินยอมจากผู้ใช้ก่อนคำสั่งที่มีผลต่อไฟล์หรือเครือข่าย

## 2. ภาพรวมองค์ประกอบ

```text
Flutter app (Android)
  ├─ Supabase Auth: session/JWT และ OAuth sign-in
  ├─ Supabase API: อ่าน/เขียนข้อมูล โดย PostgreSQL RLS บังคับสิทธิ์
  ├─ Supabase Storage: ไฟล์โปรเจ็กต์ใน private bucket
  └─ Supabase Edge Functions
       ├─ AI gateway → OpenAI / Anthropic / Google AI
       └─ connector callbacks / งานที่ต้องใช้ secret ฝั่ง server

Supabase project
  ├─ Auth
  ├─ PostgreSQL (schema, migrations, RLS)
  ├─ Storage
  ├─ Edge Functions
  └─ Realtime (เปิดใช้เฉพาะฟีเจอร์ที่ต้อง sync สด)
```

Flutter จัดการ UI, state, การเลือกโปรเจ็กต์, editor และ locale (`th`, `en`) ส่วน Supabase เป็น backend หลักตาม PRD การเรียกบริการภายนอกที่ต้องใช้ secret ให้ผ่าน Edge Function ไม่ฝังคีย์ผู้ให้บริการไว้ในแอป และไม่ใช้ service-role key จาก client

## 3. โครงสร้างโค้ดที่แนะนำ

```text
mobile/flutter_app/
  lib/
    app/                 app bootstrap, routes, theme, dependency setup
    core/                error handling, config, shared utilities
    features/
      auth/              sign-in/session
      workspaces/        personal workspace และการเลือก workspace
      projects/          CRUD และ project isolation
      chat/              chat, messages, AI routing UI
      files/             file browser/editor และ .3iii import/export
      terminal/          sandboxed command interface
      connectors/        GitHub, Supabase, Vercel connections
    data/                Supabase clients, repositories, DTOs
    l10n/                generated localization + ARB ภาษา th/en
  test/
supabase/
  migrations/            SQL migrations เป็นแหล่ง schema หลัก
  functions/             AI gateway และ connector endpoints
  seed.sql               local development data ที่ไม่ใช่ secrets
  config.toml
schemas/
  3iii-file-schema.json  schema ของไฟล์ .3iii
```

ให้จัด feature ตามความสามารถทางผลิตภัณฑ์ และแยก UI ออกจาก data access ผ่าน repository/service interfaces เพื่อให้ทดสอบได้ การสร้างโครงสร้างนี้เป็นงาน implementation ขั้นถัดไป; ปัจจุบัน repo ยังไม่มี Flutter scaffold, migrations หรือ Edge Functions

## 4. ข้อมูลและการแยกสิทธิ์

แบบจำลองขั้นต่ำที่เสนอ:

- `profiles`: ข้อมูลแสดงผลที่ไม่อ่อนไหว อ้างอิง `auth.users.id`.
- `workspaces`: workspace ส่วนตัว มี `owner_id`; หนึ่งผู้ใช้มีได้หลาย workspace หากต้องการ.
- `projects`: มี `workspace_id`, ชื่อ และ metadata ของโปรเจ็กต์.
- `chats` และ `messages`: แชทและข้อความ ผูกกับ `project_id` หรือ workspace ตามชนิดแชท.
- `tasks`, `contexts`, `references`: ข้อมูลประกอบโปรเจ็กต์/แชท โดยมี foreign key ที่ตรวจสอบความเป็นเจ้าของได้.
- `project_files`: metadata/path; เนื้อหาไฟล์เก็บใน private Supabase Storage bucket.
- `connector_accounts`: สถานะและ metadata การเชื่อมต่อ; ห้ามเก็บ access token แบบ plaintext.

รายละเอียด schema จริงให้เพิ่มผ่าน migration ใต้ `supabase/migrations/` ไม่ควรดูแล schema ซ้ำในหลายไฟล์ SQL ที่แก้แยกจากกัน

### RLS เป็นขอบเขตความปลอดภัย

เปิด Row Level Security บนทุกตารางที่ client เข้าถึงได้ และกำหนด policy สำหรับ `SELECT`, `INSERT`, `UPDATE`, `DELETE` แยกชัดเจน ตรวจสิทธิ์จาก `auth.uid()` ผ่าน workspace/project ที่เป็นเจ้าของ โดยตรวจทั้ง `USING` และ `WITH CHECK`; ห้ามเชื่อ `owner_id` ที่ส่งมาจาก client โดยไม่ตรวจสอบ

Storage bucket ต้องเป็น private และ policy ของ object ต้องตรวจ workspace/project ownership ด้วย ไม่ควรให้ผู้ใช้ที่เข้าถึง project หนึ่งอ่านไฟล์หรือ context ของอีก project ได้ แม้ทราบ UUID หรือ path นั้นก็ตาม ทดสอบ policy ด้วยผู้ใช้สองบัญชีและ project สองชุดก่อนปล่อยใช้งาน

## 5. การไหลของคำขอหลัก

1. ผู้ใช้ลงชื่อเข้าใช้ผ่าน Supabase Auth และรับ session/JWT.
2. Flutter โหลด workspace/project ผ่าน Supabase API; PostgreSQL RLS กรองแถวตามสิทธิ์ทุกครั้ง.
3. คำขอ AI ส่งเฉพาะ context ที่ผู้ใช้เลือกไปยัง Edge Function พร้อม JWT; function ตรวจผู้ใช้และสิทธิ์ project ก่อนเรียก provider.
4. Edge Function เลือก OpenAI, Anthropic หรือ Google AI ตาม routing ที่ผู้ใช้ร้องขอ, เก็บ secret ฝั่ง server, จำกัด input/output และบันทึกผลตามนโยบาย retention.
5. ผลตอบกลับถูกบันทึกเป็น message/task โดยใช้สิทธิ์ผู้ใช้ ไม่ข้าม project boundary.
6. การนำเข้า/ส่งออก `.3iii` ตรวจ JSON ด้วย `schemas/3iii-file-schema.json` ก่อนใช้งาน และไม่ execute เนื้อหาจากไฟล์นำเข้า.

## 6. AI, connectors และ terminal

- **AI gateway:** สร้าง Edge Function เป็นจุดรวมการเรียก provider; ตรวจ auth, ownership, provider allowlist, rate limit, ขนาด context และ error mapping. API keys เป็น Supabase Function secrets/environment variables.
- **OAuth connectors:** ใช้ authorization flow ที่ปลอดภัย, ตรวจ `state`/callback และเก็บ token ใน secret store ที่เหมาะสมหรือเข้ารหัสก่อน persistence; มี revoke/disconnect และหลีกเลี่ยงการ log token.
- **Terminal:** ห้ามส่งคำสั่ง shell อิสระไป execute ใน Edge Function หรือ environment ที่มีสิทธิ์กว้าง. หากทำใน MVP ให้แยก sandbox ต่อ project, ใช้ allowlist/limits, แสดงผลกระทบ และต้องยืนยันก่อนคำสั่ง destructive หรือ network access.

## 7. Auth และการตั้งค่า Supabase ปัจจุบัน

`supabase/config.toml` ปัจจุบันเปิด local API, DB (PostgreSQL 17), Auth, Realtime, Storage และ Edge Runtime; เปิด external Auth provider Google, GitHub และ Azure (ใช้สำหรับ Microsoft identity) โดยอ่านค่า credential จาก environment variables การตั้งค่านี้เป็น local CLI config ไม่ใช่หลักฐานว่า OAuth provider ถูกตั้งค่าครบใน production

- รักษา `site_url` และ `additional_redirect_urls` สำหรับ local development; เพิ่ม production redirect URL ที่เจาะจงก่อน deploy อย่าใช้ wildcard กว้าง.
- ตั้ง `GOOGLE_CLIENT_ID`, `GOOGLE_SECRET`, `GITHUB_CLIENT_ID`, `GITHUB_SECRET`, `AZURE_CLIENT_ID`, `AZURE_SECRET`, `AZURE_TENANT_ID` ผ่าน environment/secret manager เท่านั้น.
- แยก OAuth sign-in providers ออกจาก AI providers: การเปิด Google Auth ไม่ได้ตั้งค่า Google AI API.
- email confirmations, TLS, signup และ anonymous access ใน config ปัจจุบันเป็นค่าพัฒนา; ทบทวนและกำหนดค่าตาม threat model ก่อน production.
- เก็บ `.env` และ Supabase local state ใน `.gitignore`; commit เฉพาะ `.env.example` ที่ไม่มีค่าลับจริง.

## 8. Localization, observability และคุณภาพ

UI ใช้ Flutter localization (`flutter_localizations`, `intl`, ARB) สำหรับ Thai และ English; ไม่ฝังข้อความใน widget และทดสอบข้อความไทยบนหน้าจอ Android ขนาดเล็ก การ log ต้องไม่บันทึก prompt ที่อ่อนไหว, OAuth token, API key หรือเนื้อหาไฟล์โดยไม่จำเป็น

ก่อนเปิดใช้จริงให้มี migration/RLS tests, unit tests สำหรับ repositories และ `.3iii` validation, integration tests สำหรับ auth/AI gateway และทดสอบสิทธิ์ข้าม project CodeQL workflow ที่มีอยู่ช่วยสแกนโค้ด แต่ไม่แทนการทดสอบ RLS, secrets หรือการตรวจสอบ dependency

## 9. ลำดับการนำไปใช้

1. สร้าง Flutter scaffold, localization และ Supabase client/session handling.
2. เพิ่ม migration สำหรับ profiles/workspaces/projects พร้อม RLS และทดสอบ isolation.
3. เพิ่ม private Storage และ file metadata; กำหนดขอบเขตไฟล์และ quota.
4. เพิ่ม chats/messages/tasks/context, import/export `.3iii`.
5. เพิ่ม AI gateway/provider secrets, limits และ audit/error handling.
6. เพิ่ม connectors; terminal sandbox เฉพาะเมื่อมีแบบจำลองภัยคุกคามและข้อจำกัดการรันที่ชัดเจน.

จุดตัดสินใจที่ต้องยืนยันก่อน implementation: retention/ลบข้อมูล AI, การจัดการ provider keys ต่อผู้ใช้หรือใช้ platform keys, ความหมายและขอบเขตของ workspace, วิธี sandbox terminal และรูปแบบ connector token storage.
