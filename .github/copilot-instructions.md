# Copilot instructions for 3iii-Copilot

## Product context
- This is a mobile-first AI coding workspace; the approved product requirements specify Flutter, Supabase, and PostgreSQL.
- Treat Thai as a first-class product language and provide English alongside Thai for user-facing content unless the user asks for a single language.
- Preserve the product name `3iii-Copilot`, the `.3iii` file extension, and the product requirements in `docs/PRD.md`.

## Implementation guidance
- Inspect the existing project structure before adding application code. Do not assume a Flutter app scaffold exists; create one only when explicitly requested.
- For user-facing text, avoid hard-coded strings in widgets. Use Flutter localization resources (ARB) and generated localization APIs once the Flutter app scaffold exists.
- Keep translation keys semantically stable and provide matching Thai (`th`) and English (`en`) values. Do not translate code identifiers, API fields, or file extensions.
- Prefer accessible, responsive UI that works on small Android screens, and verify long Thai and English labels do not overflow.
- Never commit secrets, API keys, or personal MCP credentials. Do not add an MCP server configuration without a specific server, approved tools, and required credentials being supplied.
