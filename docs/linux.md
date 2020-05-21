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

## yum
yum list installed

## rsync
rsync <from> <to>
rsync --progress 127.0.0.1:kube/* /data/var/log/td-agent/kube/

## iptables
sudo iptables -t nat -L -n -v

### Swap usage by procs
find /proc -maxdepth 2 -path "/proc/[0-9]*/status" -readable \
  -exec awk -v FS=":" '{process[$1]=$2;sub(/^[ \t]+/,"",process[$1]);} END {if(process["VmSwap"] && process["VmSwap"] != "0 kB") printf "%10s %-30s %20s\n",process["Pid"],process["Name"],process["VmSwap"]}' '{}' \; | awk '{print $(NF-1),$0}' | sort -hr | head | cut -d " " -f2- 

### docker container by pid
cat /proc/<PID>/cgroup
docker ps | grep <cgroup id>
