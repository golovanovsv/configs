etcd

ETCDCTL_API=3 

etcdctl \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  --cert /etc/kubernetes/pki/etcd/server.crt \
  --key /etc/kubernetes/pki/etcd/server.key \
  --endpoints https://127.0.0.1:2379 \
  member list

etcdctl cluster-health
etcdctl endpoint status

docker exec -it 9643024b51ce etcdctl \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  --cert /etc/kubernetes/pki/etcd/server.crt \
  --key /etc/kubernetes/pki/etcd/server.key \
  --endpoints https://127.0.0.1:2379 \
-w table member list

etcdctl member update $(cat memeber_id) --peer-urls="<new url>"

# --force-new-cluster

curl --cacert ca.crt --cert peer.crt --key peer.key https://192.168.218.2:2380
https://192.168.218.2:2380/members