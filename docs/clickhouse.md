# Users

SHOW CREATE USER

# Partitions

select partition, name, table from system.parts where active and table = '<table>' order by name limit 20  //   3.39
alter table <table> drop partition '2020-04-01'

# Sizes

SELECT table, round(sum(bytes) / 1024/1024/1024, 2) as size_gb
FROM system.parts
WHERE active
GROUP BY table
ORDER BY size_gb DESC
