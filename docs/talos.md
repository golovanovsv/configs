# Talos

## Configs

```bash
# Через внешние секреты
talosctl gen secrets -o secrets.yaml
talosctl gen config --with-secrets secrets.yaml <cluster-name> https://<api-endpoint>:6443

# Создать секреты в процессе
talosctl gen config <cluster-name> https://<api-endpoint>:6443
```

## Bootstrap

Вне зависимости от того как был запущен кластер talos требуется ручное действие для бутстрапа кластера `etcd`:

```bash
talosctl --talosconfig talosconfig --nodes 172.16.121.22 bootstrap
```

## Install

### Manual ISO/USB

Загружаем сервер(-а) с ISO/USB носителей. Talos запускается в режиме `maintenance`.

После этого можно применить конфигурационный файл к серверу(-ам):

```bash
talosctl --talosconfig talosconfig --nodes 172.16.121.22 apply-config --file <controlplane|worker>.yaml --insecure
```

Флаг `--insecure` требуется потому что на пустом сервере нет никаких сертификатов. После применения конфигурации к серверу talos установиться на диск сервера и применит к себе все параметры из конфигурационного файла.

### PXE

Можно загружать сервера автоматически по протоколу PXE. Если в процессе загрузки не передать ядру параметр `talos.config=http://example.com/config.yaml` то как и в случае с загрузкой с ISO/USB сервер загрузиться в режиме `maintenance`. Это потребует его ручной инициализации.

Если есть настроенный iPXE сервер, то моно передать параметр `talos.config` со ссылкой на уже подготовленный файл с конфигурацией и сервер установиться и подключиться к существующему кластеру самостоятельно согласное параметрам в конфигурационном файле.

Для такого способа загрузки требуются заранее сконфигурированные DHCP/TFTP/iPXE [сервисы](./hardware.md).

### Cloud

Загружаем сервера из шаблона, который или уже есть у вашего облачного провайдера или вы его самостоятельно создаете из образов в [генераторе](https://factory.talos.dev/)

```bash
openstack image create --private --disk-format qcow2 --file openstack-amd64-v1.13.3.raw --min-ram 2 --min-disk 20 "Talos Linux v1.13.3"
```

Для передачи конфигурации серверу можно использовать поле `userdata` в API/UI облачного провайдера.

### Cilium

```bash
cilium install \
    --set ipam.mode=kubernetes \
    --set kubeProxyReplacement=true \
    --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    --set cgroup.autoMount.enabled=false \
    --set cgroup.hostRoot=/sys/fs/cgroup \
    --set k8sServiceHost=localhost \
    --set k8sServicePort=7445
```

## Overlay

```bash
sda      8:0    0    10G  0 disk
├─sda1   8:1    0   100M  0 part  # STATE
├─sda2   8:2    0     1M  0 part  # BIOS
├─sda3   8:3    0     2G  0 part  # BOOT
├─sda4   8:4    0     1M  0 part  # META
└─sda5   8:6    0   7.8G  0 part  # EPHEMERAL
```

## Debug

```bash
talosctl --nodes <node> debug <debug-image>
cd /host
```
