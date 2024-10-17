# etcd

# common operations

export ETCDCTL_API=3
export ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt
export ETCDCTL_CERT=/etc/kubernetes/pki/etcd/peer.crt
export ETCDCTL_KEY=/etc/kubernetes/pki/etcd/peer.key
export ETCDCTL_ENDPOINTS=

etcdctl member list -w table
etcdctl cluster-health
etcdctl endpoint status -w table
etcdctl endpoint health -w table

etcdctl move-leader <id>
etcdctl member update <member-id> --peer-urls="<new url>"

# maintenance
## member defragmentation
## Команда выполняется на каждом участнике кластера отдельно ели не заданы ETCDCTL_ENDPOINTS

etcdctl defrag

## compaction
## Сжатие выполняется сразу во всем кластере

rev=$(etcdctl --endpoints=:2379 endpoint status --write-out="json" | egrep -o '"revision":[0-9]*' | egrep -o '[0-9].*')
etcdctl compact $rev
etcdctl defrag
etcdctl alarm disarm

# operations in docker

docker exec -it 9643024b51ce etcdctl \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  --cert /etc/kubernetes/pki/etcd/server.crt \
  --key /etc/kubernetes/pki/etcd/server.key \
  --endpoints https://127.0.0.1:2379 \
-w table member list

# curl oparations

curl --cacert ca.crt --cert peer.crt --key peer.key https://192.168.0.1:2380/members

# ETCDCTL_API=2
etcdctl ls [-r/--recursive] /
etcdctl mkdir /dir
etcdctl get <key>
etcdctl rm [-r/--recursive] /

export ETCDCTL_API=3
export ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt
export ETCDCTL_CERT=/etc/kubernetes/pki/etcd/peer.crt
export ETCDCTL_KEY=/etc/kubernetes/pki/etcd/peer.key

etcdctl endpoint status -w table
