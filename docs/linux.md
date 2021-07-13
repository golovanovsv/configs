## Linux versions
Ubuntu:
- xenial = 16.04
- bionic = 18.04
- focal = 20.04

## mount
sudo umount /test
sudo umount /dev/sdb3
sudo mount -o rw,remount -force /dev/sdb3 /test

## Systemd
systemd-delta --type=extended
ntpq -pn

### LogRotate
logrotate

sudo logrotate /etc/logrotate.conf --debug // Проверка

rotate 10  # кол-во хранимых сжатых фрагментов
size=16M   # максимальный размер несжатого файла; пока размер текущего
           # файла журнала не превысит данный порог, файл не будет "ротирован"
weekly   # игнорировать размер файла; производить ротацию регулярно, раз в неделю
daily / monthly /hourly / early
missingok  # отсутствие файла не является ошибкой
nocopytruncate  # не сбрасывать файл журнала после копирования
nocreate   # не создавать пустой журнал
nodelaycompress # не откладывать сжатие файла на следующий цикл
nomail     # не отправлять содержимое удаляемых (старых) журналов по почте
notifempty # не обрабатывать пустые файлы
noolddir   # держать все файлы в одном и том же каталоге
compress   # сжимать
postrotate
    /usr/bin/killall -HUP httpd
endscript # Между postrotate и endscript расположены команды
          # интерпретатора sh(1), исполняемые непосредственно после ротации.
          # В данном примере сюда помещена команда kill, перезапускающая
          # httpd-сервер. Это необходимо для нормальной процедуры

create # Указывает, что необходимо создать пустой лог файл после перемещения старого
olddir # Перемещать старые логи в отдельную папку;

## Devicemapper
dmsetup status
dmsetup info /dev/dm-0
dmsetup status /dev/dm-0

## DeviceAdm
devadm control --reload-rules

## Disk queue
cat /sys/block/<dev>/queue/scheduler
echo cfq > /sys/block/<dev>/queue/scheduler

## lvm
lvremove /dev/vg00/home
lvcreate -L3G -nredis-mibank fastssd

## yum
yum list installed
yum --showduplicates list <package>

## ssh
port-forwarding
ssh -L local_socket:remote_socket
ssh -L [local_address:]local_port:host:hostport

## rsync
# -r - recursive
rsync <from> <to>
rsync --progress -r 127.0.0.1:kube/* /data/var/log/td-agent/kube/
# Папку в корень
rsync --progress postgres -r sgolovanov@mongo-m-1:~

## iptables
sudo iptables -t nat -L -n -v

### Swap usage by procs
find /proc -maxdepth 2 -path "/proc/[0-9]*/status" -readable \
  -exec awk -v FS=":" '{process[$1]=$2;sub(/^[ \t]+/,"",process[$1]);} END {if(process["VmSwap"] && process["VmSwap"] != "0 kB") printf "%10s %-30s %20s\n",process["Pid"],process["Name"],process["VmSwap"]}' '{}' \; | awk '{print $(NF-1),$0}' | sort -hr | head | cut -d " " -f2- 

### Memory
ps -o pid,user,%mem,command ax | sort -b -k3 -r | more

# Отсортировать по памяти
top -o %MEM
 - VIRT - объем виртуальной памяти
 - RES  - объем реальной памяти

pmap -x <PID> - подробности по использованию памяти процессом
 - anon - выделенная в прооцессе работы память

### docker container by pid
cat /proc/<PID>/cgroup
docker ps | grep <cgroup id>

### sed
sed -i '50001,$ d' filename - удалить линии в файле с 50001
sed -i -e 's/aaaa/bbbb/g' filename - замена

### cgroups
systemd-cgtop
systemd-cgls [/docker/....]

## sudo
root ALL = (ALL:ALL) NOPASSWD:ALL

root      - пользователь или группа (начинается со значка %)
ALL       - все хосты
(ALL:ALL) - от имени каких пользователей:групп можно выполнять комманды
NOPASSWD  - какие команды можно выполнять без пароля
PASSWD    - для каких команд пароль требуется

## alternatives

update-alternatives --display python3
update-alternatives --set python3 /usr/bin/python3.5

## Hot add devices

disks:
  echo "- - -" >> /sys/class/scsi_host/host<number>/scan

cpu:
  echo 1 > /sys/devices/system/cpu/cpu*/online

## JQ
aws ec2 describe-instances | ./jq '.Reservations[].Instances[] | "\(.NetworkInterfaces[].PrivateIpAddress) \(.State.Name)"'
aws ec2 describe-instances | ./jq '.Reservations[].Instances[] | select(.State.Name=="running") | .NetworkInterfaces[].PrivateIpAddress' | sed 's/\"//g'
# Получить имена виртуалок, подключенных к subnet-id
aws ec2 describe-instances --filters Name=subnet-id,Values=subnet-1623465f | jq '.Reservations[].Instances[].Tags[] | select(.Key=="Name") | .Value'

## IP
ip route get <ip>
ip rule list

## xfs
xfs_admin -l /dev/sdb1
xfs_admin -L externo /dev/sdb1
