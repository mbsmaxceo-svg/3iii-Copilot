# API CONTRACT

Version: 1.0

---

## Base URL

/api/v1

---

# Authentication

## POST /auth/login

Request

{
  "provider": "google"
}

Response

{
  "access_token": "jwt-token"
}

---

# Projects

## GET /projects

Response

[
  {
    "id":"uuid",
    "name":"CRM"
  }
]

---

## POST /projects

Request

{
  "name":"CRM",
  "description":"Customer Management",
  "goal":"Build CRM"
}

Response

{
  "success": true
}

---

# Chats

## GET /projects/{project_id}/chats

## POST /projects/{project_id}/chats

---

# Messages

## POST /messages

Request

{
  "chat_id":"uuid",
  "message":"Create Login Page"
}

Response

{
  "response":"Generated Result"
}

---

# Connectors

## GET /connectors

## POST /connectors

---

# Export

## POST /export

Types

- PDF
- MD
- 3III

---

# Import

## POST /import

Types

- TXT
- MD
- 3III
