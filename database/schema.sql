create table profiles (
    id uuid primary key,
    email text,
    display_name text,
    created_at timestamp
);

create table projects (
    id uuid primary key,
    owner_id uuid,
    name text,
    description text,
    goal text,
    type text,
    visibility text,
    created_at timestamp
);

create table chats (
    id uuid primary key,
    project_id uuid,
    role text,
    content text,
    created_at timestamp
);

create table connectors (
    id uuid primary key,
    owner_id uuid,
    provider text,
    account_name text,
    created_at timestamp
);
