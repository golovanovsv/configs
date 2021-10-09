# Users

SHOW CREATE USER
echo -n "<PASSWORD>" | sha256sum | tr -d '-'

# Tables
RENAME DATABASE atomic_database1 TO atomic_database2 [ON CLUSTER cluster]
Переименование и **перенос** таблиц
RENAME TABLE [db11.]name11 TO [db12.]name12 [ON CLUSTER cluster]

# Alters
select mutation_id,database,table,command,parts_to_do,is_done from system.mutations where is_done = 0;
select mutation_id,database,table,latest_fail_reason,create_time,latest_fail_time from system.mutations where is_done = 0;
select mutation_id,parts_to_do from system.mutations where is_done = 0;
KILL MUTATION WHERE mutation_id = '0000004890'


# Partitions

select partition, name, table from system.parts where active and table = '<table>' order by name limit 20  //   3.39
select count(name) from system.parts where active and table = '<table>'
alter table <table> drop partition '2020-04-01'

# Replications
SELECT * FROM system.replicas
SELECT database,table,engine,is_leader,zookeeper_path,replica_name FROM system.replicas;

# Sizes

SELECT database, table, round(sum(bytes) / 1024/1024/1024, 2) as size_gb
FROM system.parts
WHERE active
GROUP BY database, table
ORDER BY size_gb DESC

# Обновление оператора

Теперь все объекты в одном манифесте:
https://raw.githubusercontent.com/Altinity/clickhouse-operator/master/deploy/operator/clickhouse-operator-install.yaml
Манифест строго привязан к kube-system. SA смаплена в cluster-admin.

1. Обновляем оператор:
   kubectl apply -f https://raw.githubusercontent.com/Altinity/clickhouse-operator/master/deploy/operator/clickhouse-operator-install.yaml
2. Комментируем блок в секрете etc-clickhouse-operator-usersd-files:
   <!--  <default_database_engine>Ordinary</default_database_engine>  -->
3. Перезапускаем оператор

# Установка

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E0C56BD4
echo "deb https://repo.clickhouse.tech/deb/stable/ main/" | sudo tee /etc/apt/sources.list.d/clickhouse.list
sudo apt-get update
sudo apt-get install -y clickhouse-client

# Бэкап

docker run --rm -it --network host -v "${PWD}:/var/lib/clickhouse" \
   -e CLICKHOUSE_HOST="10.235.107.174" \
   -e CLICKHOUSE_USERNAME="admin" \
   -e CLICKHOUSE_PASSWORD="password" \
   -e S3_REGION="eu-west-1" \
   -e S3_BUCKET="cbt-temp" \
   -e S3_ACCESS_KEY="<>" \
   -e S3_SECRET_KEY="<>" \
   --memory="2048m" \
   alexakulov/clickhouse-backup create ts-21.05.2021

docker run --rm -it --network host -v "${PWD}:/var/lib/clickhouse" \
   -e CLICKHOUSE_HOST="10.255.128.34" \
   -e CLICKHOUSE_USERNAME="admin" \
   -e CLICKHOUSE_PASSWORD="password" \
   -e S3_REGION="eu-west-1" \
   -e S3_BUCKET="cbt-temp" \
   -e S3_ACCESS_KEY="<>" \
   -e S3_SECRET_KEY="<>" \
   --memory="2048m" \
   alexakulov/clickhouse-backup restore --rm -s integration-20.04.2021
