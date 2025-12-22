## Linux versions
Ubuntu:
- xenial = 16.04
- bionic = 18.04
- focal = 20.04

## power mode (governor)
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
for i in {0..63}; do echo "performance" > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_governor; done

## mount
sudo umount /test
sudo umount /dev/sdb3
sudo mount -o rw,remount -force /dev/sdb3 /test

## system calls
cat /proc/kallsyms - list of all system calls
cat /sys/kernel/debug/tracing/kprobe_events - зонды eBPF (kprobe - зонды ядра, uprobe - пользовательские зонды)

## bpftool

bpftool prog
bpftool prog show id 406
bpftool prog dump xlated/jited id 406

tc filter show dev cilium_host egress/ingress

## Systemd
systemd-delta --type=extended
ntpq -pn

### LogRotate
# https://wiki.enchtex.info/tools/system/logrotate
logrotate

sudo logrotate /etc/logrotate.conf --debug // Проверка

rotate 10  # кол-во хранимых сжатых фрагментов
size 16M   # максимальный размер несжатого файла; пока размер текущего
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
pvresize /dev/sda

lvextend -L[+2G|12G|+100%FREE] /dev/vg00/home
lvremove /dev/vg00/home
lvcreate -L3G -nredis-mibank fastssd

lvcreate -T -L 100G storage/thin
lvcreate -T -V 200G storage/thin -n test

lvreduce -L30G /dev/vg0/root

## ssh
# key generation
ssh-keygen -t rsa -b 4096 -C "comment" -f <output-name>
ssh-keygen -t ed25519 -C "comment" -f <output-name>

# key info
ssh-keygen -l -f <file>

# compare priv and pub keys
ssh-keygen -l -f <private-key>
ssh-keygen -l -f <public-key>

# check key in ssh-agent
ssh-add -L

# port-forwarding
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

## JQ: filters
jq '.|keys' // Получить только названия ключей указанного уровня
jq '.|map_values(keys)' // Получить только названия ключей указанного уровня и названия их подключей
jq '.monitoring[] | "\(.key) \(.value)" // Вывести значения ключей в консоль

jq '.items[] | select(."nvidia.com/gpu" != null) | ."nvidia.com/gpu"'
jq '.items | length'
jq '.items[] | select(.labels.lat!=null) | .id'
jq '.items[] | select(.labels.lat==null) | .id'
jq '.items[0:100]

## JQ: sort
jq '.items[] | sort_by(.date)'

## JQ: casts
jq '.items[] | {id: .id, date: .date}' file.json      # dicts
jq '[ .items[] | {id: .id, date: .date} ]' file.json  # [dict]

## JQ: formatted output
kubectl get --raw "/api/v1/nodes/tst-gpu109-f100/proxy/stats/summary" | jq '.pods[] | (.podRef.name) + ": " + (."ephemeral-storage".usedBytes | tostring)'

## JQ: AWS
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

## Page cache
reset cache:
sync; echo 3 | sudo tee /proc/sys/vm/drop_caches

## Wiregard
apt install wireguard
wg genkey | sudo tee /etc/wireguard/privatekey | wg pubkey | sudo tee /etc/wireguard/publickey

## Shared memory
Внктри Linux есть 2 механизма разделяемой памяти:
1. mmap - мапинг файла или его частей напрямую в память. В этом случае память разделяется между процессов созданных при помощи fork()
2. posix - память выделяется при помощи вызова shm_open(). В этом случае память может разделяться между любыми процессами.

Посмотреть за этим можно через утилиту `ipcs -a`
Поуправлять утилитами `ipcmk`/`ipcrm`

# peer-1
# /etc/wireguard/wg0.conf
```bash
[Interface]
# Адрес для интерфейса wg
Address = 10.128.0.1/30
ListenPort = 51820
Table = off
PrivateKey = <peer-1-private-key>

[Peer]
PublicKey = <peer-2-public-key>
# Перечень IP которые могут проходить через интерфейс
# Так же для них будет создан статический маршрут если значение Table не равно off
# Некоторые дистрибутивы не создают маршрут для 0.0.0.0/0 а некоторые создают
AllowedIPs = 0.0.0.0/0
# Если Endpoint не указан, то сервер работает в пассивном режиме и ждет входящих соединений
Endpoint = <peer-2-ip>:<peer-2-port>
```

# peer-2
# /etc/wireguard/wg0.conf
```bash
[Interface]
Address = 10.128.0.2/30
Table = off
PrivateKey = <peer-2-private-key>

[Peer]
PublicKey = <peer-1-public-key>
AllowedIPs = 0.0.0.0/0
Endpoint = <peer-1-ip>:<peer-1-port>
PersistentKeepalive = 25
```

# sudo systemctl enable wg-quick@wg0 && sudo systemctl start wg-quick@wg0
# sudo systemctl restart wg-quick@wg0

# console resolution
## extlinux
```bash
/boot/extlinux.conf:
nomodeset -> video=1280x720
```

## grub
```
/etc/default/grub
remove nomodeset
add:
GRUB_GFXMODE=1280x720
GRUB_GFXPAYLOAD=1280x720

update-grub
```

## yum/rpm
rpm -qa                  # Установленные пакеты
yum repolist             # Список репозиториев
yum repolist enabled     # Список активных репозиториев
yum whatprovides 'sshd'  # Найти пакет с бинарником sshd
yum search mc            # Найти пакет
yum install mc           # Установить пакет
yum list installed
yum --showduplicates list <package>

yum --disablerepo="*" --enablerepo="epel" list available

## dnf
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf config-manager [--enablerepo | --disablerepo] <repo-name>
dnf repolist enabled
dnf group list [--hidden]
dnf group install <group-name>
dnf group remove <group-name>

dnf --disablerepo="*" --enablerepo="epel" list available

## fio

modes:

- read
- randread
- write
- randwrite

```bash
fio \
  --name=test \
  --filename=/dev/drbd1000 \
  --ioengine=libaio \
  --iodepth=32 \
  --direct=1 \
  --rw=randread \
  --bs=16k \
  --size=2G \
  --numjob=1 \
  --group_reporting \
  --time_based \
  --runtime=60
```
