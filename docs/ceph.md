### ceph

## ceph basic info

ceph health detail / ceph -s
ceph df
ceph osd df tree
ceph osd pools ls detail
ceph osd crush rule ls

## ceph commands

ceph health		# Состояние
ceph -w 		# Расширенное состояние
ceph -v			# Версия

ceph osd pool ls 			      # Список пулов
ceph osd pool stats <pool>	# Статистика пула
ceph osd tree
ceph osd in/out osd.0
ceph osd crush remove osd.0
ceph auth del osd.0
ceph osd rm osd.0

ceph osd set [noin/noout/noup/nodown]
ceph osd unset [noin/noout/noup/nodown]

rdb -p <pool> list				    # Список образов в пуле
rdb -p <pool> info <image>		# Информация образа
rdb -p <pool> status <image>	# Состояние образа, в том числе куда подключен
rdb -p <pool> watch <image>		# Следить за событиями образа
rbd -p <pool> lock ls <image>
rdb -p <pool> device list
rdb -p <pool> map <image-id>
rbd -p <pool> create <name> --size 5G
rbd showmapped
rbd device unmap <device>

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

## ceph pg autoscale
ceph osd pool get <pool> pg_autoscale_mode
ceph osd pool set <pool> pg_autoscale_mode <mode>  # off/on/warn
ceph config set global osd_pool_default_pg_autoscale_mode <mode>

ceph osd pool set noautoscale
ceph osd pool unset noautoscale
ceph osd pool autoscale-status

## ceph pg num
ceph osd pool get <pool> pg_num
ceph osd pool set <pool> pgp_num <pgs>

### disks
lsblk /dev/vda --bytes --nodeps --pairs --paths --output SIZE,ROTA,RO,TYPE,PKNAME,NAME,KNAME,MOUNTPOINT,FSTYPE
udevadm info --query=property /dev/vda

### mgr
ceph mgr module disable nfs
