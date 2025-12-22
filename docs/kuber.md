# kubectl
kubectl -n <ns> logs <pod> --previous --since 1h

kubectl -n <ns> create secret tls <name> --cert <certfile> --key <keyfile>
kubectl -n <ns> create secret tls <name> --cert <certfile> --key <keyfile> --dry-run -o yaml | kubectl apply -f -

kubectl -n <ns> get pod <pod> -o yaml
kubectl -n <ns> get pod <pod> -o json
kubectl -n <ns> get pod <pod> -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}'
kubectl -n <ns> get pod --sort-by='{.firstTimestamp}'
kubectl -n <ns> get pod --sort-by=.metadata.creationTimestamp
kubectl get no -o jsonpath='{ range .items[*]}{.metadata.name}{"\t"}{.status.allocatable.cpu}:{.status.allocatable.memory}{"\t"}{.spec.taints[*].key}{"\n"}{ end }'
kubectl get no -o json | jq '.items[].status.allocatable | select(."nvidia.com/gpu" != null)|."nvidia.com/gpu"'

kubectl get no -l <selectors> -o json | jq '.items[] | select(.status.allocatable."nvidia.com/gpu" != null)|.status.allocatable."nvidia.com/gpu" + ": " + .metadata.name'

kubectl rollout restart deployment/daemonset

# scheduller
kubectl -n kube-system describe endpoints kube-scheduler # who is leader

## list all images in cluster
kubectl get pods --all-namespaces -o jsonpath="{..image}" | tr -s '[[:space:]]' '\n' | sort | uniq -c | sort -gr

# kubectl systems
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint nodes --all node-role.kubernetes.io/master:NoSchedule-
kubectl taint node k0 node-role.kubernetes.io/master='':NoSchedule
kubectl label node k0 node-role.kubernetes.io/ingress=true
kubectl label node k0 node-role.kubernetes.io/ingress-
kubectl drain <node> [--ignore-daemonsets]

# kubectl debug
kubectl debug <pod-to-debug> -it --image=<debug-image> -c <container-name>

# kubeadm
sudo kubeadm init --node-name k0.xaddr.ru --kubernetes-version 1.22 --pod-network-cidr=10.244.0.0/20 --upload-certs --control-plane-endpoint 5.189.0.215
sudo kubeadm init --node-name k0.xaddr.ru --upload-certs --config cluster.yaml

sudo kubeadm init --service-cidr 10.255.0.0/17 --pod-network-cidr=10.255.128.0/17 --upload-certs

[cluster.yaml](https://godoc.org/k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/v1beta2)

sudo kubeadm token create --print-join-command --ttl 1h
sudo kubeadm init phase upload-certs --upload-certs

# CIDRS
kubectl cluster-info dump | jq '.items[0].spec.podCIDRs'

# kubeadm upgrade
Обновляться можно только на одну версию. Таким образом необходимо:
- Установить последний kubeadm следующей версии: `apt policy | grep kubeadm; apt install kubeadm=<new version>`
- Обновить control plane на каждом мастере: `kubeadm upgrade plan; kubeadm upgrade apply <new version>`
- Обновить kubelet-ы: `apt install kubelet=<new version>`

# kubeadm extra-sans
kubectl -n kube-system get configmap kubeadm-config -o jsonpath='{.data.ClusterConfiguration}' > kubeadm.yaml
kubeadm config upload from-file --config kubeadm.yaml
```
controlPlaneEndpoint: 172.17.147.10:6443
apiServer:
  certSANs:
  - "extra-name.example.com"
  - "1.1.1.1"
```

# Следующая команда по какой-то причине не умеет добавлять SANs
# Мне кажется, что он берет параметры обновления с существующих сертификатов
kubeadm certs renew apiserver

# Поэтому нужно использовать следующую
kubeadm init phase certs apiserver --config kubeadm.yaml

# calico
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.2/manifests/calico.yaml

# cilium
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/v0.13.2/cilium-linux-amd64.tar.gz
cilium install --helm-set ipam.operator.clusterPoolIPv4PodCIDR="172.28.0.0/17"

# argo
kubectl -n argocd apply -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.6.7/manifests/install.yaml

# prometheus operator
objects:
- Prometheus
- ServiceMonitor - таргеты
- PrometheusRule - правила
- Alertmanager -

# kube-router
kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml

# Ingress-nginx (kubernetes)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/service-nodeport.yaml

# Nginxinc-ingress
kubectl apply -f https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/common/ns-and-sa.yaml
kubectl apply -f https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/common/default-server-secret.yaml
kubectl apply -f https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/common/nginx-config.yaml
(optional)
kubectl apply -f https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/common/custom-resource-definitions.yaml
kubectl apply -f https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/rbac/rbac.yaml
(or)
kubectl apply -f https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/daemon-set/nginx-ingress.yaml
kubectl apply -f https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/deployment/nginx-ingress.yaml

kubectl apply -f https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/master/deployments/service/nodeport.yaml

# default ingress-class
```bash
annotations:
ingressclass.kubernetes.io/is-default-class: "true"
```

# Cert manager
kubectl create namespace cert-manager
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml

# kubelet params
## Out of resources
## https://kubernetes.io/docs/tasks/administer-cluster/out-of-resource/
# default
--eviction-hard=memory.available<100Mi,nodefs.available<10%,imagefs.available<15%
--eviction-hard=memory.available<500Mi,nodefs.available<1Gi,imagefs.available<,nodefs.inodesFree=5000
--eviction-hard=memory.available<5%,nodefs.available<5%,imagefs.available<5%
--eviction-soft=memory.available<1.5Gi
--eviction-soft-grace-period=2m30s
--housekeeping-interval=10s

## node protection
## system-reserved по-умолчанию не установлено
--system-reserved=cpu=150m,memory=256Mi,pid=128

## kube-reserved по-умолчанию не установлено
--kube-reserved=cpu=150m,memrory=256Mi,pid=128

## Garbage collecting

### Auth in API
export TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
curl -k -H "Authorization: Bearer $TOKEN" https://kubernetes.default.svc

# Auth
## via cert

export k8suser=username
# days in openssl req may be ignored
openssl req -batch -nodes -new -newkey rsa:4096 -days 1095 -sha512 -out ${k8suser}.csr -keyout ${k8suser}.key -subj "/CN=${k8suser}/O=MIB"
export REQUEST=$(base64 -w 0 ${k8suser}.csr)
# Если надо передать csr
echo ${REQUEST} | tr -d '\n'

# Если сразу применять csr
cat << EOF | sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${k8suser}
spec:
  request: ${REQUEST}
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF

kubectl certificate approve ${k8suser}
kubectl get csr ${k8suser} -o jsonpath='{.status.certificate}'
kubectl get csr ${k8suser} -o jsonpath='{.status.certificate}' | base64 -d

## private registry
kubectl -n production create secret generic selectel-k8s \
    --from-file=.dockerconfigjson=/home/reptile/.docker/selectel-k8s.json \
    --type=kubernetes.io/dockerconfigjson
