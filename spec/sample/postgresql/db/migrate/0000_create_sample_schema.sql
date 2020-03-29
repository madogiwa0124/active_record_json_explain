-- TODO: Use ActiveRecord::Migration

CREATE TABLE IF NOT EXISTS samples (
  id integer not null,
  category integer,
  title varchar(255) not null,
  body text
);
