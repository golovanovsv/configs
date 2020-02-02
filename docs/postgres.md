# postgres

psql -h <host> <db|postgres> <user>
pgcli - command line interface for Postgres with auto-completion and syntax

## Сокращения

\?  - помощь
\с  - соединиться с БД
\du - список родей
\l  - список БД
\db - список tablespace
\da - List of aggregate functions
\dn - список схем
\dt *.* - список таблиц с указанием владельца
\d+ *.* - посмотреть данные объекта

## Проверка активности

SELECT * FROM pg_stat_activity; - список коннектов

## Отключение сессий

select pg_terminate_backend(pid) from pg_stat_activity where datname='<db>';

select datname,usename,application_name,state,waiting,query from pg_stat_activity;
select datname,usename,application_name,state,wait_event_type,query from pg_stat_activity;

select datname,usename,application_name,state,waiting,query from pg_stat_activity where usename='pgsql';

wait_event_type | wait_event

select pg_terminate_backend(pid) from pg_stat_activity where usename='pgsql';

## Управление пользователями

CREATE USER <user>;
ALTER USER <user> WITH PASSWORD '<password>';
ALTER USER <user> WITH superuser createdb createrole replication bypassrls; 
GRANT ALL PRIVILEGES ON DATABASE <db> TO <user>;

## Управление правами

GRANT CONNECT ON DATABASE "<db>" TO <user>;
GRANT USAGE ON SCHEMA limits TO <user>;
GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA limits TO <user>;

ALTER DEFAULT PRIVILEGES IN SCHEMA limits GRANT SELECT ON TABLES TO <user>;

ALTER DATABASE <db> OWNER TO reptile;

## Просмотр прав пользователей

SELECT * FROM information_schema.role_table_grants WHERE grantee='<user>';

## Вычисление объемов

SELECT pg_database.datname as "Database", pg_size_pretty(pg_database_size(pg_database.datname)) as Size FROM pg_database ORDER BY "Database";

SELECT table_schema, table_name, total_bytes AS total
    , pg_size_pretty(index_bytes) AS INDEX
    , pg_size_pretty(toast_bytes) AS toast
    , pg_size_pretty(table_bytes) AS TABLE
  FROM (
  SELECT *, total_bytes-index_bytes-COALESCE(toast_bytes,0) AS table_bytes FROM (
      SELECT c.oid,nspname AS table_schema, relname AS TABLE_NAME
              , c.reltuples AS row_estimate
              , pg_total_relation_size(c.oid) AS total_bytes
              , pg_indexes_size(c.oid) AS index_bytes
              , pg_total_relation_size(reltoastrelid) AS toast_bytes
          FROM pg_class c
          LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
          WHERE relkind = 'r'
  ) a
) a
WHERE table_schema != 'information_schema' AND table_schema != 'pg_catalog'
ORDER BY total DESC,table_schema,table_name;

## Состояние репликации

9: select client_addr, state, sent_location, write_location, flush_location, replay_location from pg_stat_replication;
10: select client_addr, state, sent_lsn, write_lsn, flush_lsn, replay_lsn from pg_stat_replication;

## Блокировки

select
  lock.locktype,
  lock.relation::regclass,
  lock.mode,
  lock.transactionid as tid,
  lock.virtualtransaction as vtid,
  lock.pid,
  lock.granted
from pg_catalog.pg_locks lock
  left join pg_catalog.pg_database db
    on db.oid = lock.database
where (db.datname = '<db>' or db.datname is null)
  and not lock.pid = pg_backend_pid()
order by lock.pid;

## Дамп/рестор таблиц

pg_dump -Fc -d <db> -t cybo.profits_hours > cybo.profits_hours.dump
pg_dump -Fc -d <db> -t market_data.minutes > market_data.minutes.dump
pg_dump -h 127.0.0.1 -p 6432 -U <user> -Fd <db> -T log.default_log -T bk.operation -T shops.payments_in -T shops.payments_out -T shops.payment_out_idents -f <db>
pg_restore -h 172.16.121.8 -U <user> -W -Cc -d <db> -n cybo -t profits_hours -Fc 

-O/--no-owner - не восстанавливать владельцев

pg_dump -p 5437 -O -x -Fc <db>  > <db>.dump

pg_restore -h 172.16.121.8 -U <user> -C -d <db>

pg_restore --clean --if-exist --no-acl --no-owner --verbose -d <db> -U <user>

cat /<db>.dump | pg_restore --clean --if-exist --no-acl --no-owner --verbose -d <db> -U <user>

pg_dump -h 172.21.21.27 -p 5437 -U <user> --exclude-table-data='(geo_*|fias_*|pghero_*)' -O -x -Fc <db> | pg_restore --clean --if-exist --no-acl --no-owner --verbose -d <db> -U <user>

--exclude-table-data='(geo_*|fias_*)'

create database confluencedb_docker LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8' TEMPLATE template0;

pg_dump -U confluence -O -x -Fc confluencedb | pg_restore --clean --if-exist --no-acl --no-owner --verbose -d confluencedb_docker -U confluence

vC8MSDTT8j


dpkg-reconfigure locales

create database <db> LC_COLLATE = 'ru_RU.UTF-8' LC_CTYPE = 'ru_RU.UTF-8' TEMPLATE template0;
create database "<db>" LC_COLLATE = 'ru_RU.UTF-8' LC_CTYPE = 'ru_RU.UTF-8' TEMPLATE template0;

export PGPASSWORD=<passowrd>
pg_dump -h 192.168.100.2 -p 6432 -U <user> -O -x -Fc <db> | pg_restore --clean --if-exist --no-acl --no-owner --verbose -d <db> -U <user>
pg_dump -h 192.168.100.2 -p 6432 -U <user> -O -x -Fd "<db>" | pg_restore --clean --if-exist --no-acl --no-owner --verbose -d "<db>" -U <user>

## Очистка

VACUUM (VERBOSE, ANALYZE) "log"."error";

vacuum full analyze log.error
vacuum full analyze device.log
vacuum full analyze deficit.task_data
