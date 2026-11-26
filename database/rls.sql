-- ============================================================
-- 3iii-Copilot  |  rls.sql  (complete)
-- ============================================================
-- Rules:
--   1. Every table reachable by the client has RLS enabled.
--   2. Every operation (SELECT / INSERT / UPDATE / DELETE) has
--      its own explicit policy -- no catch-all FOR ALL.
--   3. INSERT and UPDATE policies carry WITH CHECK so the server
--      re-validates ownership even when the client sends data.
--   4. Ownership is always verified via auth.uid(); client-
--      supplied owner_id values are never trusted on their own.
-- ============================================================

------------------------------------------------------------
-- ENABLE RLS ON ALL TABLES
------------------------------------------------------------
alter table profiles           enable row level security;
alter table projects           enable row level security;
alter table project_settings   enable row level security;
alter table chats              enable row level security;
alter table messages           enable row level security;
alter table files              enable row level security;
alter table terminal_history   enable row level security;
alter table connectors         enable row level security;
alter table project_connectors enable row level security;
alter table exports            enable row level security;

------------------------------------------------------------
-- 1. PROFILES
------------------------------------------------------------
create policy "profiles: select own"
  on profiles for select
  using (auth.uid() = id);

create policy "profiles: insert own"
  on profiles for insert
  with check (auth.uid() = id);

create policy "profiles: update own"
  on profiles for update
  using      (auth.uid() = id)
  with check (auth.uid() = id);

create policy "profiles: delete own"
  on profiles for delete
  using (auth.uid() = id);

------------------------------------------------------------
-- 2. PROJECTS
------------------------------------------------------------
create policy "projects: select own"
  on projects for select
  using (auth.uid() = owner_id);

create policy "projects: insert own"
  on projects for insert
  with check (auth.uid() = owner_id);

create policy "projects: update own"
  on projects for update
  using      (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

create policy "projects: delete own"
  on projects for delete
  using (auth.uid() = owner_id);

------------------------------------------------------------
-- 3. PROJECT SETTINGS
------------------------------------------------------------
create policy "project_settings: select own"
  on project_settings for select
  using (
    exists (
      select 1 from projects
      where projects.id       = project_settings.project_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "project_settings: insert own"
  on project_settings for insert
  with check (
    exists (
      select 1 from projects
      where projects.id       = project_settings.project_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "project_settings: update own"
  on project_settings for update
  using (
    exists (
      select 1 from projects
      where projects.id       = project_settings.project_id
        and projects.owner_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from projects
      where projects.id       = project_settings.project_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "project_settings: delete own"
  on project_settings for delete
  using (
    exists (
      select 1 from projects
      where projects.id       = project_settings.project_id
        and projects.owner_id = auth.uid()
    )
  );

------------------------------------------------------------
-- 4. CHATS
------------------------------------------------------------
create policy "chats: select own"
  on chats for select
  using (
    exists (
      select 1 from projects
      where projects.id       = chats.project_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "chats: insert own"
  on chats for insert
  with check (
    exists (
      select 1 from projects
      where projects.id       = chats.project_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "chats: update own"
  on chats for update
  using (
    exists (
      select 1 from projects
      where projects.id       = chats.project_id
        and projects.owner_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from projects
      where projects.id       = chats.project_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "chats: delete own"
  on chats for delete
  using (
    exists (
      select 1 from projects
      where projects.id       = chats.project_id
        and projects.owner_id = auth.uid()
    )
  );

------------------------------------------------------------
-- 5. MESSAGES
------------------------------------------------------------
create policy "messages: select own"
  on messages for select
  using (
    exists (
      select 1 from chats
      join projects on projects.id = chats.project_id
      where chats.id          = messages.chat_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "messages: insert own"
  on messages for insert
  with check (
    exists (
      select 1 from chats
      join projects on projects.id = chats.project_id
      where chats.id          = messages.chat_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "messages: update own"
  on messages for update
  using (
    exists (
      select 1 from chats
      join projects on projects.id = chats.project_id
      where chats.id          = messages.chat_id
        and projects.owner_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from chats
      join projects on projects.id = chats.project_id
      where chats.id          = messages.chat_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "messages: delete own"
  on messages for delete
  using (
    exists (
      select 1 from chats
      join projects on projects.id = chats.project_id
      where chats.id          = messages.chat_id
        and projects.owner_id = auth.uid()
    )
  );

------------------------------------------------------------
-- 6. FILES
------------------------------------------------------------
create policy "files: select own"
  on files for select
  using (
    exists (
      select 1 from projects
      where projects.id       = files.project_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "files: insert own"
  on files for insert
  with check (
    exists (
      select 1 from projects
      where projects.id       = files.project_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "files: update own"
  on files for update
  using (
    exists (
      select 1 from projects
      where projects.id       = files.project_id
        and projects.owner_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from projects
      where projects.id       = files.project_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "files: delete own"
  on files for delete
  using (
    exists (
      select 1 from projects
      where projects.id       = files.project_id
        and projects.owner_id = auth.uid()
    )
  );

------------------------------------------------------------
-- 7. TERMINAL HISTORY
------------------------------------------------------------
create policy "terminal_history: select own"
  on terminal_history for select
  using (
    exists (
      select 1 from projects
      where projects.id       = terminal_history.project_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "terminal_history: insert own"
  on terminal_history for insert
  with check (
    exists (
      select 1 from projects
      where projects.id       = terminal_history.project_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "terminal_history: delete own"
  on terminal_history for delete
  using (
    exists (
      select 1 from projects
      where projects.id       = terminal_history.project_id
        and projects.owner_id = auth.uid()
    )
  );

------------------------------------------------------------
-- 8. CONNECTORS
------------------------------------------------------------
create policy "connectors: select own"
  on connectors for select
  using (auth.uid() = owner_id);

create policy "connectors: insert own"
  on connectors for insert
  with check (auth.uid() = owner_id);

create policy "connectors: update own"
  on connectors for update
  using      (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

create policy "connectors: delete own"
  on connectors for delete
  using (auth.uid() = owner_id);

------------------------------------------------------------
-- 9. PROJECT CONNECTORS
------------------------------------------------------------
create policy "project_connectors: select own"
  on project_connectors for select
  using (
    exists (
      select 1 from projects
      where projects.id       = project_connectors.project_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "project_connectors: insert own"
  on project_connectors for insert
  with check (
    exists (
      select 1 from projects
      where projects.id       = project_connectors.project_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "project_connectors: delete own"
  on project_connectors for delete
  using (
    exists (
      select 1 from projects
      where projects.id       = project_connectors.project_id
        and projects.owner_id = auth.uid()
    )
  );

------------------------------------------------------------
-- 10. EXPORTS
------------------------------------------------------------
create policy "exports: select own"
  on exports for select
  using (auth.uid() = owner_id);

create policy "exports: insert own"
  on exports for insert
  with check (
    auth.uid() = owner_id
    and exists (
      select 1 from projects
      where projects.id       = exports.project_id
        and projects.owner_id = auth.uid()
    )
  );

create policy "exports: update own"
  on exports for update
  using      (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

create policy "exports: delete own"
  on exports for delete
  using (auth.uid() = owner_id);

