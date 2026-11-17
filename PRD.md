# 3iii-Copilot [AI & Coding]

> ● ไม่ว่าโปรเจ็คไหน 3iii-Copilot พร้อมไปกับคุณ ●
>
> ● Code เองก็ได้ AI Assist ก็ได้ หรือให้ AI ทำงานร่วมกับคุณตลอดทั้งโปรเจ็ค ●

---

# Product Requirements Document (PRD)

| Item | Value |
|--------|--------|
| Product | 3iii-Copilot |
| Version | 1.0 |
| Status | MVP |
| Platform | Android First |
| Company | 3iii |
| Category | AI Coding Workspace |
| Last Updated | 2026-11-17 |

---

# 1. Executive Summary

3iii-Copilot คือ Mobile-First AI Coding Workspace ที่รวมการทำงานของ AI หลายผู้ให้บริการเข้ามาอยู่ในพื้นที่ทำงานเดียว

ผู้ใช้งานสามารถ:

- สร้างและบริหารหลายโปรเจ็ค
- แยก Context ของแต่ละโปรเจ็ค
- ใช้งาน AI หลายตัว
- ใช้ Smart Terminal
- เชื่อม GitHub
- เชื่อม Supabase
- เชื่อม Vercel
- Export / Import AI Context ผ่านไฟล์ .3iii

---

# 2. Vision

## The Operating System for AI Projects

สร้างแพลตฟอร์มที่ช่วยให้ผู้ใช้งานสามารถ:

- วางแผน
- ออกแบบ
- พัฒนา
- ทดสอบ
- Deploy

ภายในระบบเดียว

---

# 3. Mission

ลดระยะทางระหว่าง

Idea → Design → Develop → Deploy

โดยมี AI เป็น Co-Pilot ตลอดวงจรการพัฒนา

---

# 4. Product Positioning

## Current Workflow

ผู้ใช้งานต้องสลับไปมาระหว่าง

- ChatGPT
- Claude
- Gemini
- GitHub
- Supabase
- Vercel
- Notion
- Cursor

---

## 3iii-Copilot Workflow

รวมทุกอย่างไว้ใน Workspace เดียว

- Chat
- Projects
- Files
- AI
- Terminal
- Connectors

---

# 5. Target Users

## Student

อายุ 18-25 ปี

ความต้องการ

- เรียนเขียนโปรแกรม
- ทำโปรเจ็คส่งอาจารย์
- ใช้งานผ่านมือถือ

---

## Freelancer

ความต้องการ

- ใช้งานหลายโปรเจ็ค
- เชื่อม GitHub
- ใช้ AI ช่วยเขียนโค้ด

---

## Startup Founder

ความต้องการ

- สร้าง MVP
- ทดลองผลิตภัณฑ์
- ใช้ AI ทำงานร่วมกัน

---

# 6. MVP Goals

MVP ต้องพิสูจน์

- ผู้ใช้ทำหลายโปรเจ็คใน AI เดียวได้จริง
- Mobile Coding Workspace มีความต้องการจริง
- Project Isolation ทำงานได้จริง
- Multi AI Collaboration สร้างมูลค่าเพิ่มต่อผู้ใช้

---

# 7. Core Features

## General Chat

พื้นที่สนทนาทั่วไป

### Features

- Create Chat
- Rename Chat
- Delete Chat
- Export Chat

### Rules

General Chat จะไม่เข้าถึงข้อมูลของโปรเจ็คใด

---

## Projects

รองรับการสร้างโปรเจ็คไม่จำกัด

### Features

- Create Project
- Edit Project
- Delete Project
- Archive Project

---

## Project Types

- Web Application
- Mobile Application
- API
- AI Agent
- Other

---

# 8. Project Isolation

ทุกโปรเจ็คต้องแยก Context ออกจากกัน

## Example

Project A

จะไม่สามารถเข้าถึง

Project B

ได้โดยอัตโนมัติ

---

## Security Rule

```yaml
scope:
 current_project_only
```

---

# 9. AI Architecture

## Main AI

```text
3iii-Copilot
```

หน้าที่

- Main Assistant
- Context Manager
- AI Router
- Result Aggregator

---

## AI Providers

MVP

- GPT
- Claude
- Gemini

---

## AI Routing

ตัวอย่าง

```text
@GPT
```

```text
@Claude
```

```text
@Gemini
```

เมื่อจบงาน

ระบบจะกลับสู่

```text
3iii-Copilot
```

อัตโนมัติ

---

# 10. Smart Terminal

รองรับ 2 รูปแบบ

## Command Mode

```bash
git status
```

```bash
npm install
```

```bash
cd src
```

---

## AI Mode

```text
Create Login Page
```

```text
Build REST API
```

---

ระบบตรวจจับรูปแบบคำสั่งอัตโนมัติ

---

# 11. File Manager

รองรับ

- Browse Files
- Create Files
- Read Files
- Rename Files
- Delete Files

---

# 12. Connectors

## GitHub

รองรับ

- Multiple Accounts
- Multiple Organizations
- Multiple Repositories

---

## Supabase

รองรับ

- Multiple Projects

---

## Vercel

รองรับ

- Multiple Deployments

---

# 13. Connector Scope

## User Level

Global Connector

ตัวเลือกเริ่มต้นสำหรับทุกโปรเจ็ค

---

## Project Level

ผู้ใช้สามารถเลือก Connector ต่างจากค่า Default ได้

---

# 14. Import Features

MVP รองรับ

- TXT
- Markdown
- .3iii

---

# 15. Export Features

MVP รองรับ

- PDF
- Markdown
- .3iii

---

# 16. 3iii Native Format

## File Extension

```text
.3iii
```

---

## Purpose

AI Native Context Format

---

## Contains

- Metadata
- Chat History
- Tasks
- Context
- References
- AI Responses

---

## Example

```json
{
  "version": "1.0",
  "project": {},
  "chat": [],
  "context": [],
  "tasks": []
}
```

---

# 17. Mobile First Design

Target

- Android Phones
- Android Tablets

Primary Device

- Samsung Android

---

# 18. Navigation

Bottom Navigation

```text
Home
Projects
Assistant
Profile
```

---

# 19. Authentication

Supported Providers

- Google
- Microsoft
- GitHub

---

# 20. Security Requirements

- JWT Authentication
- Encrypted Storage
- Workspace Isolation
- Project Isolation

---

# 21. Performance Targets

## App Launch

<= 3 seconds

---

## AI Response

<= 10 seconds

---

## Memory Usage

Optimized for Android Devices

---

# 22. Technology Stack

## Frontend

Flutter

---

## Backend

Supabase

---

## Database

PostgreSQL

---

## Authentication

Supabase Auth

---

## Storage

Supabase Storage

---

## AI Layer

- OpenAI
- Anthropic
- Google AI

---

# 23. MVP Scope

Included

- Login
- Dashboard
- New Chat
- Projects
- AI Routing
- Smart Terminal
- GitHub Connector
- Supabase Connector
- Vercel Connector
- Import Chat
- Export Chat
- .3iii Format

---

# 24. Out of Scope

Future Roadmap

- Team Workspace
- Marketplace
- Plugin Store
- Bolt Integration
- Lovable Integration
- Base44 Integration
- GitLab Integration
- Firebase Integration
- Full Project Export
- Full Project Import
- Desktop Version
- iOS Version

---

# 25. Success Metrics

Initial KPI

- 100 Registered Users
- 30 Active Projects
- 20 Daily Active Users
- 10 GitHub Connections
- 10 Supabase
