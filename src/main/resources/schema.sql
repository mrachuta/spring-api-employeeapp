DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
  id            INTEGER PRIMARY KEY,
  first_name    VARCHAR(64) NOT NULL,
  last_name     VARCHAR(64) NOT NULL
);
