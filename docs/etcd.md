etcd

ETCDCTL_API=3 

etcdctl \
  --cacert /etc/kubernetes/pki/ca.crt \
  --cert /etc/kubernetes/pki/etcd.crt \
  --key /etc/kubernetes/pki/etcd.key \
  --endpoints https://192.168.36.12:2379 \
  member list

etcdctl cluster-health
