# postgres

psql -h <host> -p 5432 -d <db|postgres> -U <user> -W
pgcli - command line interface for Postgres with auto-completion and syntax

## Сокращения

\?  - помощь
\с  - соединиться с БД
\du - список ролей (пользователи СУБД) с их атрибутами
\l  - список БД
\db - список tablespace
\da - List of aggregate functions
\dn - список схем
\d  -
\dt *.* - список таблиц с указанием владельца
\d+ *.* - посмотреть данные объекта
\dp  - права доступа в контексте БД
\ddp - права доступа по-умолчанию в контексте БД
\df  - список процедур
\dy  - список триггеров
\x  - вертикальный вывод данных (или добавить :G в конце запроса вместо ;)
\conninfo - информация о текущем подключении

## Проверка активности

SELECT * FROM pg_stat_activity; - список коннектов (connect)
SELECT count(pid) FROM pg_stat_activity; - число открытых соединений
SELECT datname, usename, client_addr, client_hostname, state FROM pg_stat_activity;

SELECT usename, datname, client_addr, ssl, version, cipher FROM pg_stat_ssl
JOIN pg_stat_activity ON pg_stat_ssl.pid = pg_stat_activity.pid;

## Отключение сессий

select pg_terminate_backend(pid) from pg_stat_activity where datname='<db>';

select datname,usename,application_name,state,waiting,query from pg_stat_activity;
select datname,usename,application_name,state,wait_event_type,query from pg_stat_activity;

select datname,usename,application_name,state,waiting,query from pg_stat_activity where usename='pgsql';

wait_event_type | wait_event

select pg_terminate_backend(pid) from pg_stat_activity where usename='pgsql';

## Управление пользователями
# Для роли с атрибутом SUPERUSER проверки доступа не выполняются
CREATE USER <user>;
ALTER USER <user> WITH PASSWORD '<password>';
ALTER USER <user> WITH superuser createdb createrole replication bypassrls;
GRANT ALL PRIVILEGES ON DATABASE <db> TO <user>;

Место хранения информации о пользователях. Схема pg_catalog общая на инстанс.
SELECT * FROM pg_catalog.pg_authid;

## Удаленный доступ
SELECT * FROM pg_hba_file_rules();

## Управление правами

GRANT CONNECT ON DATABASE "<db>" TO <user>;
GRANT USAGE ON SCHEMA limits TO <user>;
GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA limits TO <user>;

ALTER DEFAULT PRIVILEGES IN SCHEMA limits GRANT SELECT ON TABLES TO <user>;

ALTER DATABASE <db> OWNER TO reptile;

## Просмотр прав пользователей

SELECT * FROM information_schema.role_table_grants WHERE grantee='<user>';

## Перенастройка в онлайне

ALTER SYSTEM SET wal_level = replica;
ALTER SYSTEM SET jit = off;

## Вычисление объемов

SELECT pg_database.datname as "Database", pg_size_pretty(pg_database_size(pg_database.datname)) as Size FROM pg_database ORDER BY "Database";

SELECT table_schema, table_name
    , pg_size_pretty(total_bytes) AS total
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
ORDER BY total_bytes DESC,table_schema,table_name;

## Репликация
Заливаем дамп базы с уадленного сервера:
pg_basebackup -P -R -X stream -c fast -h 78.155.202.229 -U postgres -D ./data
-P - отображать прогресс
-R - создать минимальный recovery.conf
-c - режим контрольных точек
-X - режим передачи журнала

Создание слота репликации
SELECT pg_create_physical_replication_slot('<name>');

Список существующих слотов репликации. Выводит в том числе логическую репликацию.
select * from pg_replication_slots;

Отставание слота репликации
SELECT
  pg_size_pretty(pg_current_wal_lsn() - restart_lsn) as delay,
  slot_name
FROM pg_replication_slots ORDER BY delay DESC;

Удаление слота репликации
select pg_drop_replication_slot('<name>');

Состояние реплики
select * from pg_stat_wal_receiver;

## Состояние репликации

9: select client_addr, state, sent_location, write_location, flush_location, replay_location from pg_stat_replication;
10: select client_addr, state, sent_lsn, write_lsn, flush_lsn, replay_lsn from pg_stat_replication;

## Расширения

Расширения включаются в конкретных БД и реплицируются с бинарной репликацией.
Необходимо подключение расширений параметром shared_preload_libraries в postgres.conf.
SELECT * FROM pg_extension;
SELECT * FROM pg_available_extensions;

CREATE EXTENSION <extension-name> [ WITH SCHEMA <schema-name> ]

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

## Создание таблицы

CREATE TABLE [IF NOT EXISTS] <table-name> (
   column1 datatype(length) column_constraint,
   column2 datatype(length) column_constraint,
   ...
   table_constraints
);

INSERT INTO <table-name> (column1, column2, …)
VALUES (value1, value2, …);

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

dpkg-reconfigure locales

create database <db> LC_COLLATE = 'ru_RU.UTF-8' LC_CTYPE = 'ru_RU.UTF-8' TEMPLATE template0;
create database "<db>" LC_COLLATE = 'ru_RU.UTF-8' LC_CTYPE = 'ru_RU.UTF-8' TEMPLATE template0;

export PGPASSWORD=<password>
pg_dump -h 192.168.100.2 -p 6432 -U <user> -O -x -Fc <db> | pg_restore --clean --if-exist --no-acl --no-owner --verbose -d <db> -U <user>
pg_dump -h 192.168.100.2 -p 6432 -U <user> -O -x -Fd "<db>" | pg_restore --clean --if-exist --no-acl --no-owner --verbose -d "<db>" -U <user>

## Очистка
### Анализ таблицы и перестройка
VACUUM (VERBOSE, ANALYZE) "log"."error";

vacuum full analyze log.error
vacuum full analyze device.log
vacuum full analyze deficit.task_data

## Мониторинг

Среднее время отклика = sum(total_time) / sum(calls) [pg_stat_statements]
Ошибки = sum(xact_rollback) [pg_stat_database]
Транзакций в секунду = sum(xact_commit + xact_rollback)
Запросов в секунду = sum(calls)

Состояния клиентов - count(*) where state = '' [pg_stat_activity]
Длительность запросов - now() - xact_start, now() - query_start

Активность в таблицах - n_tup_ins, n_tup_del, n_tup_upd [pg_stat_user_tables]
Размеры таблиц - pg_relation_size(), pg_total_relation_size ()

Получение данных о запросах - [pg_stat_statements] :
 - calls частота
 - total_time, mean_time длительность
 - shared_blks_* тяжесть
 - rows  жадность к строкам
 - temp_blks_* временные файлы
 - local_blks_* временные таблицы

Частые сбросы грязных страниц на диск [pg_stat_bgwriter]
 - checkpoint_req
 - checkpoint_timed

Процессы autovacuum:
 - count(*) WHERE query ~'^autovac'
 - count(*) WHERE now() - xact_start AND query ~'^autovac'

Репликация [pg_stat_replication]:
postgres9:
  - pg_xlog_location_diff()
  - (send|write|flush|replay)_location
postgres10:
  - pg_wal_lsn_diff()
  - (write|flush|replay)_lag

## Checkpoints
select * from pg_stat_bgwriter; - статистика сбросов shared_buffers на диск
select pg_stat_reset_shared('bgwriter'); - сброс статистики

## Фрагментированность таблиц
SELECT schemaname,
       tablename,
       dead_tuple_count(stats) AS dead_tuples,
       pg_size_pretty(dead_tuple_len(stats)) AS dead_space,
       pg_size_pretty(free_space(stats)) AS free_space,
       last_autovacuum,
       last_autoanalyze
FROM
  (SELECT pgt.schemaname AS schemaname,
          pgt.tablename AS tablename,
          pgstattuple(pgt.schemaname || '.' || pgt.tablename)
          AS stats,
          uts.last_autovacuum AS last_autovacuum,
          uts.last_autoanalyze AS last_autoanalyze
   FROM pg_tables AS pgt
   LEFT JOIN pg_stat_user_tables
        AS uts
        ON pgt.schemaname = uts.schemaname
   AND pgt.tablename = uts.relname
   WHERE pgt.schemaname NOT IN ('repack','pg_catalog')) AS r
ORDER BY dead_tuples DESC;

## Фрагментированность индексов
SELECT schemaname,
       indexname,
       tablename,
       dead_tuple_count(stats) AS dead_tuples,
       pg_size_pretty(dead_tuple_len(stats)) AS dead_space,
       pg_size_pretty(free_space(stats)) AS free_space
FROM
  (SELECT pgt.schemaname AS schemaname,
          pgt.indexname AS indexname,
          pgt.tablename AS tablename,
          pgstattuple(pgt.schemaname || '.' || pgt.indexname) AS stats
   FROM pg_indexes AS pgt
   WHERE pgt.schemaname NOT IN ('repack',
                                'pg_catalog')
     AND pgt.indexname NOT IN ('some',
                               'important',
                               'triggers')) AS r
ORDER BY dead_tuples DESC;

## Дефрагментация
pg_repack

## patroni
patronictl -c <config> list
patronictl -c postgres.yml reinit airflow-ml-db airflow-ml-db-1

## Indexes
CREATE INDEX by_date_stfs ON public.stfs_data (
  created_at DESC
)

## Конфиги

SHOW config_file;
select pg_reload_conf();

select name,setting from pg_settings;
SHOW <param-name>;
SET <param-name> TO <value>;

## Обслуживание

pg_waldump — вывести журнал предзаписи кластера БД Postgres Pro в понятном человеку виде
pg_archivecleanup — вычистить файлы архивов WAL Postgres Pro
