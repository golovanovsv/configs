## Управление интерфейсами
ip addr add <ip>/<mask> dev <dev>
ip link set <dev> up

## namespaces
lsns -t <type>  # types: net/time/mnt/uts/pid/ipc/cgroup
nsenter \
  -t <target pid> \  # target pid for enter
  -n                 # enter to network namespace
  <cmd>              # command

## netns
ip netns list
ip netns list-id
ip netns add <ns-name>
ip netns <ns-name> exec bash

## veth
ip link add veth0 type veth peer name veth1
ip link set veth0 up
ip link set veth1 netns <ns-name>
ip netns exec <ns-name> ip link set veth1 up

## vxlan
# VTEP - VXLAN Tunnel Endpoints
ip link add <name> type vxlan \
  id <id> \         # 24-битный ID vxlan (VNI)
  dstport <port> \  # Порт для работы vxlan (8472/UDP Linux 4789/UDP IANA)
  local <ip> \      # Локальный IP для терминации vxlan
  group <mcast> \   # Мультикаст группа для автопоиска vxlan
  dev <eth> \       # Устройство на котором работает vxlan
  ttl 1

ip link add <name> type vxlan \
  id <id> \ 
  dstport <port> \
  local <ip> \
  remote <ip> \     # Статический VTEP без использования муьтикаста

bridge link                                              # Перечень vxlan
bridge fdb append 00:00:00:00:00:00 dev <name> dst <ip>  # Дополнительный VTEP для vxlan
