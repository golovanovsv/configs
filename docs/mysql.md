# mysql

## Пользователи

CREATE USER 'mail'@'%' IDENTIFIED BY 'Mailpa$$word';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,ALTER ON maildb.* TO 'mail'@'%';
CREATE USER 'roundcube'@'%' IDENTIFIED BY 'q7JAu3VBhwkYS5BD';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,ALTER ON roundcube.* TO 'roundcube'@'%';

ALTER USER 'mail'@'%' IDENTIFIED WITH mysql_native_password BY 'Mailpa$$word';
ALTER USER 'roundcube'@'%' IDENTIFIED WITH mysql_native_password BY 'q7JAu3VBhwkYS5BD';

## Процессы

SHOW PROCESSLIST \G;
select * from information_schema.processlist where command='sleep' and time > 60;
select GROUP_CONCAT(CONCAT('KILL QUERY ',id,';') SEPARATOR ' ') from information_schema.processlist where info like '%insert%';

## Конфигурация

SHOW GLOBAL/SESSION VARIABLES
SHOW GLOBAL/SESSION VARIABLES like '%con%'
SET GLOBAL/SESSION interactive_timeout=3;

## Репликация

SHOW SLAVE HOSTS;
SHOW SLAVE STATUS\G

STOP/START SLAVE;
STOP/START SLAVE IO_THREAD;
STOP/START SLAVE SQL_THREAD;

## Наливка реплики

SET GLOBAL read_only = ON;
mysqldump -u<user> -p<passwd> --all-databases --triggers --routines --events --skip-lock-tables > all_databases.sql
SHOW MASTER STATUS;
SET GLOBAL read_only = OFF;

scp all_databases.sql
RESET MASTER;
mysql -u<user> -p<passwd> < all_databases.sql

CHANGE MASTER TO MASTER_HOST='192.168.114.2',MASTER_LOG_FILE='mysql-bin.170868', MASTER_LOG_POS=7871312; 
,MASTER_USER='slave_user', MASTER_PASSWORD='password';
START SLAVE IO_THREAD;
START SLAVE SQL_THREAD;
