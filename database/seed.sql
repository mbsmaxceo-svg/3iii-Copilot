insert into projects
(
  id,
  owner_id,
  name,
  description,
  goal,
  project_type
)
values
(
  uuid_generate_v4(),
  null,
  'Sample Project',
  'Demo Project',
  'Learn 3iii-Copilot',
  'Web Application'
);
