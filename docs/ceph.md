### ceph

ceph health		# Состояние
ceph -w 		# Расширенное состояние
ceph -v			# Версия

ceph osd pool ls 			# Список пулов
ceph osd pool stats <pool>	# Статистика пула

rdb -p <pool> list				# Список образов в пуле
rdb -p <pool> info <image>		# Информация образа
rdb -p <pool> status <image>	# Состояние образа, в том числе куда подключен
rdb -p <pool> watch <image>		# Следить за событиями образа