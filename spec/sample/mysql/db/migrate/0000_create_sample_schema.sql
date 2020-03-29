-- TODO: Use ActiveRecord::Migration

CREATE DATABASE IF NOT EXISTS sample;
USE sample;
CREATE TABLE IF NOT EXISTS samples (
  id integer not null,
  category integer,
  title varchar(255) not null,
  body text
);
