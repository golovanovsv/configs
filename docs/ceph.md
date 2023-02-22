### ceph

ceph health		# Состояние
ceph -w 		# Расширенное состояние
ceph -v			# Версия

ceph osd pool ls 			# Список пулов
ceph osd pool stats <pool>	# Статистика пула
ceph osd tree
ceph osd in/out osd.0
ceph osd crush remove osd.0
ceph auth del osd.0
ceph osd rm osd.0

rdb -p <pool> list				# Список образов в пуле
rdb -p <pool> info <image>		# Информация образа
rdb -p <pool> status <image>	# Состояние образа, в том числе куда подключен
rdb -p <pool> watch <image>		# Следить за событиями образа
rbd -p <pool> lock ls <image>
rdb -p <pool> device list
rdb -p <pool> map <image-id>
rbd -p <pool> create <name> --size 5G

## ceph users
ceph dashboard ac-user-create <username> <password> administrator

## ceph status (crashes)
ceph crash ls
ceph crash info <id>
ceph crash archive <id>
ceph crash archive-all

## ceph status (MON_DISK_LOW)
ceph config get mon mon_data_avail_warn
ceph config set mon mon_data_avail_warn 10
ceph config set mon mon_data_avail_crit 5

### disks
lsblk /dev/vda --bytes --nodeps --pairs --paths --output SIZE,ROTA,RO,TYPE,PKNAME,NAME,KNAME,MOUNTPOINT,FSTYPE
udevadm info --query=property /dev/vda
