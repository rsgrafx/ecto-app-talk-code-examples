DROP DATABASE IF EXISTS core_orders;

CREATE DATABASE core_orders;

\c core_orders;
-- Similar to USE core_orders (psql)

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS purchasers;
DROP TABLE IF EXISTS items;

CREATE TABLE purchasers (
  id serial primary key,
  user_name varchar(200),
  email varchar(40) constraint unique_email unique
);

CREATE TABLE orders (
  id serial primary key,
  purchaser_id integer references purchasers(id) not null,
  name varchar(150)
);

CREATE TABLE items (
  id serial primary key,
  order_id integer references orders(id),
  description varchar(200),
  name varchar(50) not null,
  quantity integer,
  price numeric
);
