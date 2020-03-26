## Значения меток

label_values(node_load15,context) 
label_values(node_load1{context="$context"},host)

## Число CPU
count without(cpu, mode) (node_cpu_seconds_total{mode="idle"})

## Нагрузка на CPU
sum(irate(node_cpu_seconds_total{mode="system"}[2m])) by (host)
sum(irate(node_cpu_seconds_total{mode="iowait"}[2m])) by (host)
sum(irate(node_cpu_seconds_total{mode="user"}[2m])) by (host)

## LA
node_load1{}
node_load5{}
node_load15{}

## Memory
sum(node_memory_MemTotal_bytes{instance=~"$node"})

## uptime
sum(time() - node_boot_time_seconds{instance=~"$node"})

avg(irate(node_cpu_seconds_total{instance=~"$node",mode="system"}[2m])) by (instance)
avg(irate(node_cpu_seconds_total{instance=~"$node",mode="user"}[2m])) by (instance)
avg(irate(node_cpu_seconds_total{instance=~"$node",mode="iowait"}[2m])) by (instance)
1 - avg(irate(node_cpu_seconds_total{instance=~"$node",mode="idle"}[30m])) by (instance)

## LA
count without(cpu, mode) (node_cpu_seconds_total{mode="idle"})

## Disk IOps
rate(node_disk_reads_completed_total{device=~"(sd|vd)[a-z]"}[2m]) + rate(node_disk_writes_completed_total{device=~"(sd|vd)[a-z]"}[2m])
## Disk latency
irate(node_disk_read_time_seconds_total{device=~"(sd|vd)[a-z]"}[5m]) / irate(node_disk_reads_completed_total{device=~"(sd|vd)[a-z]"}[5m])
## Disk read/write
irate(node_disk_read_bytes_total{device=~"(sd|vd)[a-z]"}[2m])
irate(node_disk_written_bytes_total{device=~"(sd|vd)[a-z]"}[2m])