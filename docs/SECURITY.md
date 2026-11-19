# Security Policy / นโยบายความปลอดภัย

## Reporting a vulnerability

Please do not report exploitable vulnerabilities in public issues. Contact the repository maintainer privately through GitHub's security advisory/reporting flow. Include affected versions, impact, and concise reproduction details. Do not include real user data, passwords, tokens, or unredacted secrets.

## Security requirements

- Keep Supabase `service_role` keys, OAuth client secrets, AI provider keys, and signing credentials server-side. Never add them to Flutter, source control, screenshots, or issue reports.
- The Flutter client may use only the Supabase project URL and publishable/anon key. RLS must enforce access; a client key is not an authorization boundary by itself.
- Enable and test least-privilege RLS policies for every client-accessible table and Storage object. Do not deploy the current SQL scripts until the schema/policy mismatches noted in `supabase/SETUP.md` are resolved.
- Keep development and production projects, credentials, and data separate. Rotate any exposed credential immediately.
- Validate and size-limit uploaded files. Treat `.3iii` imports as untrusted data; validate against the schema and never execute imported content.
- Use HTTPS and narrowly scoped OAuth redirect URLs in deployed environments.

## Supported scope

This policy applies to the 3iii-Copilot repository and its maintained MVP code. Please include the affected commit or release when reporting an issue.

---

## ภาษาไทย

โปรดรายงานช่องโหว่ผ่านช่องทาง Security Advisory แบบส่วนตัวของ GitHub แทนการเปิด issue สาธารณะ ห้ามแนบข้อมูลผู้ใช้จริง รหัสผ่าน token หรือ secret ที่ยังไม่ปกปิด

ห้ามใส่ `service_role`, OAuth client secret, AI provider key หรือ signing credential ใน Flutter หรือ Git ใช้เฉพาะ publishable/anon key ในแอป และต้องเปิดใช้พร้อมทดสอบ RLS ทุกตารางและ Storage object ก่อนใช้งานจริง แยกโปรเจ็กต์และข้อมูล development ออกจาก production และหมุนเวียน credential ทันทีหากรั่วไหล
