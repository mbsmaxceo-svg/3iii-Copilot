# 3iii-Copilot [AI & Coding]

> ● ไม่ว่าโปรเจ็คไหน 3iii-Copilot พร้อมไปกับคุณ ●
>
> ● Code เองก็ได้ AI Assist ก็ได้ หรือให้ AI ทำงานร่วมกับคุณตลอดทั้งโปรเจ็ค ●

---

# Product Requirements Document (PRD)

| Field | Value |
|---------|---------|
| Product Name | 3iii-Copilot |
| Version | 1.0 |
| Status | MVP |
| Platform | Android First |
| Company | 3iii |
| Category | AI Coding Workspace |
| Document Type | Product Requirements Document |
| Last Updated | 2026-11-17 |

---

# 1. Executive Summary

3iii-Copilot คือ Mobile-First AI Coding Workspace ที่ออกแบบมาเพื่อช่วยให้ผู้ใช้งานสามารถสร้าง พัฒนา และบริหารโปรเจ็คซอฟต์แวร์ได้จากอุปกรณ์พกพา โดยมี AI เป็นผู้ช่วยหลักในการทำงาน

ระบบรองรับการทำงานหลายโปรเจ็คภายใน Workspace เดียว โดยใช้หลักการ Project Isolation เพื่อป้องกันข้อมูลและ Context ของแต่ละโปรเจ็คไม่ให้ปะปนกัน

ผู้ใช้งานสามารถเชื่อมต่อ AI หลายผู้ให้บริการ รวมถึง GitHub, Supabase และ Vercel ภายใต้ระบบเดียว

---

# 2. Product Vision

## The Operating System for AI Projects

สร้างแพลตฟอร์มศูนย์กลางสำหรับ

- Learning
- Planning
- Coding
- Building
- Deploying

โดยมี AI เป็น Co-Pilot ในทุกขั้นตอน

---

# 3. Product Mission

ลดระยะทางระหว่าง

```text
Idea
 ↓
Planning
 ↓
Design
 ↓
Development
 ↓
Deployment
```

ผ่านระบบเดียว

---

# 4. Problem Statement

ปัจจุบันผู้ใช้งานต้องสลับการทำงานระหว่างหลายบริการ

- ChatGPT
- Claude
- Gemini
- GitHub
- Supabase
- Vercel
- Cursor
- Notion

ซึ่งทำให้สูญเสีย Context และลดประสิทธิภาพการทำงาน

3iii-Copilot จึงถูกออกแบบเพื่อรวมทุกอย่างไว้ใน Workspace เดียว

---

# 5. Target Users

## Student

### Age

18-25

### Goals

- เรียนรู้การเขียนโปรแกรม
- พัฒนาโปรเจ็คจบ
- ใช้งานผ่านมือถือ

---

## Freelancer

### Goals

- ดูแลหลายโปรเจ็ค
- ใช้ AI ช่วยงาน
- เชื่อมต่อ GitHub

---

## Startup Founder

### Goals

- สร้าง MVP
- ทดลองไอเดีย
- ใช้ AI เร่งการพัฒนา

---

# 6. MVP Objectives

MVP ต้องพิสูจน์ว่า

- ผู้ใช้สามารถจัดการหลายโปรเจ็คในระบบเดียวได้
- Mobile Coding Workspace ใช้งานได้จริง
- Project Isolation สามารถแยก Context ได้จริง
- Multi-AI Workspace มีคุณค่าต่อผู้ใช้

---

# 7. Scope

## Included In MVP

### Authentication

- Google Login
- Microsoft Login
- GitHub Login

---

### Dashboard

- New Chat
- Projects
- Profile

---

### AI System

- 3iii-Copilot
- GPT
- Claude
- Gemini

---

### Project System

- Create Project
- Edit Project
- Delete Project
- Project Isolation

---

### File Manager

- Create File
- Read File
- Rename File
- Delete File

---

### Smart Terminal

- Command Mode
- AI Mode

---

### Connectors

- GitHub
- Supabase
- Vercel

---

### Import

- TXT
- Markdown
- .3iii

---

### Export

- PDF
- Markdown
- .3iii

---

# 8. Out Of Scope

ไม่รวมใน MVP

- Team Workspace
- Marketplace
- Bolt Integration
- Lovable Integration
- Base44 Integration
- GitLab Integration
- Firebase Integration
- Desktop Version
- iOS Version
- Full Project Export
- Full Project Restore

---

# 9. Functional Requirements

## FR-001 Authentication

ผู้ใช้งานต้องสามารถเข้าสู่ระบบผ่าน

- Google
- Microsoft
- GitHub

---

## FR-002 General Chat

ผู้ใช้งานต้องสามารถ

- สร้างแชทใหม่
- เปลี่ยนชื่อแชท
- ลบแชท
- Export แชท

ได้

---

## FR-003 Project Management

ผู้ใช้งานต้องสามารถ

- สร้างโปรเจ็ค
- แก้ไขโปรเจ็ค
- ลบโปรเจ็ค
- เปิดโปรเจ็ค

ได้

---

## FR-004 Project Isolation

Context ของแต่ละโปรเจ็คต้องแยกออกจากกัน

ตัวอย่าง

```text
Project CRM

cannot access

Project ERP
```

จนกว่าผู้ใช้จะอนุญาต

---

## FR-005 AI Routing

ตัวอย่าง

```text
@GPT

ออกแบบ Database
```

```text
@Claude

เขียน PRD
```

```text
@Gemini

วิเคราะห์คู่แข่ง
```

เมื่อ Agent ทำงานเสร็จ

ระบบจะส่ง Context กลับ

```text
3iii-Copilot
```

อัตโนมัติ

---

## FR-006 Smart Terminal

รองรับ

### Command Mode

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

### AI Mode

```text
สร้างหน้า Login
```

```text
เพิ่มระบบ Authentication
```

---

## FR-007 File Manager

รองรับ

- Browse
- Create
- Open
- Rename
- Delete

---

## FR-008 Connector Management

รองรับหลายบัญชี

### GitHub

- Multiple Accounts
- Multiple Organizations
- Multiple Repositories

### Supabase

- Multiple Projects

### Vercel

- Multiple Deployments

---

## FR-009 Import

รองรับ

- TXT
- MD
- .3iii

---

## FR-010 Export

รองรับ

- PDF
- Markdown
- .3iii

---

# 10. 3iii Native Format

## Purpose

AI Native Context Format

---

## File Extension

```text
.3iii
```

---

## Structure

```json
{
  "version": "1.0",
  "metadata": {},
  "project": {},
  "chat": [],
  "tasks": [],
  "context": [],
  "references": []
}
```

---

## Benefits

- AI Friendly
- Context Portable
- Human Readable
- System Restorable

---

# 11. Non Functional Requirements

## Performance

### App Startup

≤ 3 Seconds

### AI Response

≤ 10 Seconds

---

## Scalability

Architecture ต้องรองรับ

- Multi Project
- Multi AI
- Multi Connector

---

## Security

- JWT Authentication
- Encrypted Storage
- Project Isolation
- Workspace Isolation

---

# 12. Technology Stack

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

## AI Providers

- OpenAI
- Anthropic
- Google AI

---

# 13. Success Metrics

## User Metrics

- 100 Registered Users
- 20 Daily Active Users

---

## Project Metrics

- 30 Active Projects

---

## Connector Metrics

- 10 GitHub Connections
- 10 Supabase Connections

---

# 14. Future Roadmap

## Phase 2

- Bolt Integration
- Lovable Integration
- Base44 Integration
- AI Builder Hub

---

## Phase 3

- Workspace Export
- Workspace Restore
- Marketplace

---

## Phase 4

- Team Workspace
- Collaboration Features
- Public Projects

---

# 15. Product Tagline

> ไม่ว่าโปรเจ็คไหน 3iii-Copilot พร้อมไปกับคุณ

> Code เองก็ได้ AI Assist ก็ได้ หรือให้ AI ทำงานร่วมกับคุณตลอดทั้งโปรเจ็ค

---

# Approval

| Item | Value |
|--------|--------|
| Status | Approved |
| Version | 1.0 |
| Owner | 3iii |
| Next Step | Architecture Design |

---

END OF DOCUMENT
