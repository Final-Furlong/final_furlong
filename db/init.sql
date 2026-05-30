-- Only used for development where Postgres is run in Docker
CREATE ROLE finalfurlong WITH SUPERUSER LOGIN PASSWORD 'finalfurlong';
DROP DATABASE IF EXISTS finalfurlong;
CREATE DATABASE finalfurlong WITH OWNER finalfurlong;
CREATE ROLE ffrailsprod WITH SUPERUSER LOGIN PASSWORD 'finalfurlong';
