# borg

borg list <folder> - список бэкапов
borg mount <folder> /mnt - смонтировать все бэкапы
borg mount <folder>::<backup name> /mnt - смонтировать бэкап

borg init -e none borg@ops.i-retail.com:server9

Linux:
borg create --progress --stats --list borg@ops.example.com:server5::"FreeServer5-78.47.247.171-vert-prod-{now:%Y-%m-%d}" -e /proc -e /dev -e /sys -e /run -e /swapfile /

FreeBSD:
borg create --progress --stats --list borg@ops.example.com:server9::"FreeServer9-138.201.118.152-beta-{now:%Y-%m-%d}" -e /proc -e /dev -e /sys -e /entropy /
