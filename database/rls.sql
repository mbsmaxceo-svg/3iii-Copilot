alter table profiles enable row level security;
alter table projects enable row level security;
alter table project_settings enable row level security;
alter table chats enable row level security;
alter table messages enable row level security;
alter table files enable row level security;
alter table terminal_history enable row level security;
alter table connectors enable row level security;
alter table project_connectors enable row level security;
alter table exports enable row level security;

----------------------------------------------------
-- PROFILES
----------------------------------------------------

create policy "own profile"
  on profiles
  for all
  using (
    auth.uid() = id
  );

----------------------------------------------------
-- PROJECTS
----------------------------------------------------

create policy "own projects"
  on projects
  for all
  using (
    auth.uid() = owner_id
  );

----------------------------------------------------
-- PROJECT SETTINGS
----------------------------------------------------

create policy "own project settings"
  on project_settings
  for all
  using (
    exists (
      select 1
      from projects
      where projects.id = project_settings.project_id
        and projects.owner_id = auth.uid()
    )
  );

----------------------------------------------------
-- CHATS
----------------------------------------------------

create policy "own chats"
  on chats
  for all
  using (
    project_id is null
    or exists (
      select 1
      from projects
      where projects.id = chats.project_id
        and projects.owner_id = auth.uid()
    )
  );

----------------------------------------------------
-- MESSAGES
----------------------------------------------------

create policy "own messages"
  on messages
  for all
  using (
    exists (
      select 1
      from chats
      join projects
        on projects.id = chats.project_id
      where chats.id = messages.chat_id
        and projects.owner_id = auth.uid()
    )
  );

----------------------------------------------------
-- FILES
----------------------------------------------------

create policy "own files"
  on files
  for all
  using (
    exists (
      select 1
      from projects
      where projects.id = files.project_id
        and projects.owner_id = auth.uid()
    )
  );

----------------------------------------------------
-- TERMINAL
----------------------------------------------------

create policy "terminal isolation"
  on terminal_history
  for all
  using (
    exists (
      select 1
      from projects
      where projects.id = terminal_history.project_id
        and projects.owner_id = auth.uid()
    )
  );

----------------------------------------------------
-- CONNECTORS
----------------------------------------------------

create policy "own connectors"
  on connectors
  for all
  using (
    auth.uid() = owner_id
  );
