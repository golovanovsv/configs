## Управление интерфейсами

ip addr add <ip>/<mask> dev <dev>
ip link set <dev> up

## vxlan

ip link add <name> type vxlan id <id> local <ip> remote <ip> dstport <port>
