-- ============================================================
-- 3iii-Copilot  |  schema.sql  (complete)
-- ============================================================
-- Run order matters: parent tables before child tables.
-- All timestamps use timestamptz (timezone-aware).
-- All FKs cascade delete to keep data isolated per owner.
-- ============================================================

------------------------------------------------------------
-- EXTENSIONS
------------------------------------------------------------
create extension if not exists "pgcrypto";   -- gen_random_uuid()

------------------------------------------------------------
-- ENUMS
------------------------------------------------------------
create type project_visibility as enum ('private', 'public');
create type project_type_enum  as enum (
  'web_app', 'mobile_app', 'api', 'data', 'other'
);
create type connector_provider as enum (
  'github', 'supabase', 'vercel', 'other'
);
create type chat_role as enum ('user', 'assistant', 'system');
create type export_format as enum ('json', 'markdown', 'zip');
create type export_status as enum ('pending', 'done', 'failed');

------------------------------------------------------------
-- 1. PROFILES  (linked 1-to-1 with auth.users)
------------------------------------------------------------
create table profiles (
  id           uuid primary key references auth.users (id) on delete cascade,
  email        text        not null,
  display_name text        not null default '',
  avatar_url   text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

comment on table profiles is
  'Public-facing user data; id mirrors auth.users.id.';

------------------------------------------------------------
-- 2. PROJECTS
------------------------------------------------------------
create table projects (
  id           uuid primary key default gen_random_uuid(),
  owner_id     uuid        not null references profiles (id) on delete cascade,
  name         text        not null check (char_length(name) between 1 and 120),
  description  text        not null default '',
  goal         text        not null default '',
  project_type project_type_enum not null default 'other',
  visibility   project_visibility not null default 'private',
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create index projects_owner_idx on projects (owner_id);

comment on table projects is
  'Each project belongs to exactly one owner. All child tables cascade-delete with it.';

------------------------------------------------------------
-- 3. PROJECT SETTINGS  (1-to-1 with projects)
------------------------------------------------------------
create table project_settings (
  project_id    uuid primary key references projects (id) on delete cascade,
  ai_provider   text        not null default 'anthropic',
  ai_model      text        not null default 'claude-sonnet-4-6',
  system_prompt text        not null default '',
  max_tokens    integer     not null default 4096 check (max_tokens between 256 and 32768),
  temperature   numeric(3,2) not null default 0.7 check (temperature between 0 and 2),
  updated_at    timestamptz not null default now()
);

comment on table project_settings is
  'Per-project AI and display settings. Created automatically when a project is created.';

------------------------------------------------------------
-- 4. CHATS  (conversation threads per project)
------------------------------------------------------------
create table chats (
  id         uuid primary key default gen_random_uuid(),
  project_id uuid        not null references projects (id) on delete cascade,
  title      text        not null default 'New chat',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index chats_project_idx on chats (project_id);

comment on table chats is
  'A chat thread belongs to a project. Messages are stored in the messages table.';

------------------------------------------------------------
-- 5. MESSAGES  (individual turns inside a chat)
------------------------------------------------------------
create table messages (
  id         uuid primary key default gen_random_uuid(),
  chat_id    uuid        not null references chats (id) on delete cascade,
  role       chat_role   not null,
  content    text        not null check (char_length(content) > 0),
  tokens     integer,
  created_at timestamptz not null default now()
);

create index messages_chat_idx on messages (chat_id, created_at);

comment on table messages is
  'Each row is one turn (user, assistant, or system) in a chat thread.';

------------------------------------------------------------
-- 6. FILES  (project file metadata; content lives in Storage)
------------------------------------------------------------
create table files (
  id           uuid primary key default gen_random_uuid(),
  project_id   uuid        not null references projects (id) on delete cascade,
  name         text        not null check (char_length(name) between 1 and 255),
  storage_path text        not null,
  mime_type    text        not null default 'application/octet-stream',
  size_bytes   bigint      not null default 0 check (size_bytes >= 0),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create index files_project_idx on files (project_id);

comment on table files is
  'File metadata only. Actual content is stored in Supabase Storage private bucket.';

------------------------------------------------------------
-- 7. TERMINAL HISTORY
------------------------------------------------------------
create table terminal_history (
  id         uuid primary key default gen_random_uuid(),
  project_id uuid        not null references projects (id) on delete cascade,
  command    text        not null check (char_length(command) > 0),
  output     text        not null default '',
  exit_code  integer     not null default 0,
  ran_at     timestamptz not null default now()
);

create index terminal_project_idx on terminal_history (project_id, ran_at);

comment on table terminal_history is
  'Sandboxed command history per project. Never stores secrets or tokens.';

------------------------------------------------------------
-- 8. CONNECTORS  (OAuth account connections per owner)
------------------------------------------------------------
create table connectors (
  id           uuid primary key default gen_random_uuid(),
  owner_id     uuid             not null references profiles (id) on delete cascade,
  provider     connector_provider not null,
  account_name text             not null default '',
  scopes       text[]           not null default '{}',
  connected_at timestamptz      not null default now(),
  expires_at   timestamptz,
  unique (owner_id, provider)
);

create index connectors_owner_idx on connectors (owner_id);

comment on table connectors is
  'OAuth connection state per provider per user. Tokens are NEVER stored here -- use Vault/secrets.';

------------------------------------------------------------
-- 9. PROJECT CONNECTORS  (which connectors a project uses)
------------------------------------------------------------
create table project_connectors (
  project_id   uuid not null references projects   (id) on delete cascade,
  connector_id uuid not null references connectors (id) on delete cascade,
  linked_at    timestamptz not null default now(),
  primary key  (project_id, connector_id)
);

comment on table project_connectors is
  'Many-to-many join between projects and their linked OAuth connectors.';

------------------------------------------------------------
-- 10. EXPORTS
------------------------------------------------------------
create table exports (
  id           uuid primary key default gen_random_uuid(),
  project_id   uuid          not null references projects (id) on delete cascade,
  owner_id     uuid          not null references profiles  (id) on delete cascade,
  format       export_format not null default 'json',
  status       export_status not null default 'pending',
  storage_path text,
  created_at   timestamptz   not null default now(),
  completed_at timestamptz
);

create index exports_project_idx on exports (project_id);
create index exports_owner_idx   on exports (owner_id);

comment on table exports is
  'Export jobs for .3iii / markdown / zip. storage_path set when status = done.';

------------------------------------------------------------
-- AUTO-UPDATE updated_at via trigger
------------------------------------------------------------
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_updated_at
  before update on profiles
  for each row execute function set_updated_at();

create trigger projects_updated_at
  before update on projects
  for each row execute function set_updated_at();

create trigger project_settings_updated_at
  before update on project_settings
  for each row execute function set_updated_at();

create trigger chats_updated_at
  before update on chats
  for each row execute function set_updated_at();

create trigger files_updated_at
  before update on files
  for each row execute function set_updated_at();
