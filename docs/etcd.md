etcd

ETCDCTL_API=3 

etcdctl \
  --cacert /etc/kubernetes/pki/ca.crt \
  --cert /etc/kubernetes/pki/etcd.crt \
  --key /etc/kubernetes/pki/etcd.key \
  --endpoints https://192.168.36.12:2379 \
  member list

etcdctl cluster-health
etcdctl endpoint status

docker exec -it 9643024b51ce etcdctl \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  --cert /etc/kubernetes/pki/etcd/server.crt \
  --key /etc/kubernetes/pki/etcd/server.key \
  --endpoints https://127.0.0.1:2379 \
-w table member list