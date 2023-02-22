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

# scheduller
kubectl -n kube-system describe endpoints kube-scheduler # who is leader

## list all images in cluster
kubectl get pods --all-namespaces -o jsonpath="{..image}" | tr -s '[[:space:]]' '\n' | sort | uniq -c | sort -gr

## some resources
kubectl get mutatingwebhookconfiguration
kubectl get ValidatingWebhookConfiguration
kubectl get endpoints
kubectl get CSINode
kubectl get csidrivers
kubectl api-versions
kubectl get cs

kubectl rollout restart deployment/daemonset

# kubectl systems
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint nodes --all node-role.kubernetes.io/master:NoSchedule-
kubectl taint node k0 node-role.kubernetes.io/master='':NoSchedule
kubectl label node k0 node-role.kubernetes.io/ingress=true
kubectl label node k0 node-role.kubernetes.io/ingress-

kubectl drain <node> [--ignore-daemonsets]

# kubectl docs
kubectl explain pod.spec.containers

# kubeadm
sudo kubeadm init --node-name k0.xaddr.ru --kubernetes-version 1.22 --pod-network-cidr=10.244.0.0/20 --upload-certs --control-plane-endpoint 5.189.0.215
sudo kubeadm init --node-name k0.xaddr.ru --upload-certs --config cluster.yaml

[cluster.yaml](https://godoc.org/k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/v1beta2)
```bash
cat << EOF > cluster.yaml
# https://kubernetes.io/docs/reference/config-api/kubeadm-config.v1beta3/
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: stable
clusterName: cluster-name
controlPlaneEndpoint: "192.168.217.100:6443"
# imageRepository: "<3-rd party repo>"
networking:
  dnsDomain: cluster.local
  podSubnet: 10.255.0.0/17
  serviceSubnet: 10.255.128.0/17
etcd:
  local:
    dataDir: /var/lib/etcd
  extraArgs:
    # election-timeout: 1000
    snapshot-count: 10000
apiServer:
  timeoutForControlPlane: 4m0s
  extraArgs:
    audit-log-path: /var/log/k8s.log
    authorization-mode: Node,RBAC
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
# Ключ, для закрытия загружаемых сертификатов
certificateKey: "<key>"
# Список начальных токенов
bootstrapTokens: {}
nodeRegistration:
  criSocket: "/var/run/docker.sock"
  kubeletExtraArgs:
    pod-infra-container-image: "<3-rd party repo>/pause:3.8"
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: JoinConfiguration
# Развернуть на ноде master-сервер
controlPlane:
  # Ключ, для открытия загруженных сертификатов
  certificateKey: "<key>"
  localAPIEndpoint:
    bindPort: 6443
discovery:
  bootstrapToken:
    apiServerEndpoint: "192.168.217.100:6443"
    # Токен и хэш CA для подключения
    token: "<token>"
    caCertHashes:
      - "<ca-hash>"
nodeRegistration:
  taints:
  - key: ingress
    effect: NoSchedule

  kubeletExtraArgs:
    node-labels: "ingress=true,type=cpu"
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
---
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
mode: ipvs
EOF
```
sudo kubeadm token create --print-join-command --ttl 1h
sudo kubeadm init phase upload-certs --upload-certs
# CIDRS
kubectl cluster-info dump | jq '.items[0].spec.podCIDRs'

# kubeadm upgrade
Обновляться можно только на одну версию. Таким образом необходимо:
- Установить последний kubeadm следующей версии: `apt policy | grep kubeadm; apt install kubeadm=<new version>`
- Обновить control plane на каждом мастере: `kubeadm upgrade plan; kubeadm upgrade apply <new version>`
- Обновить kubelet-ы: `apt install kubelet=<new version>`

# calico
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

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

# install kubelet
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo update-alternatives --set arptables /usr/sbin/arptables-legacy
sudo update-alternatives --set ebtables /usr/sbin/ebtables-legacy

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# kubelet params
## Out of resources
## https://kubernetes.io/docs/tasks/administer-cluster/out-of-resource/
--eviction-hard=memory.available<500Mi,nodefs.available<1Gi,imagefs.available<,nodefs.inodesFree=5000
--eviction-hard=memory.available<5%,nodefs.available<5%,imagefs.available<5%
--eviction-soft=memory.available<1.5Gi
--eviction-soft-grace-period=2m30s
--housekeeping-interval=10s
--system-reserved=memory=1.5G

## Garbage collecting

### Auth in API
export TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
curl -k -H "Authorization: Bearer $TOKEN" https://kubernetes.default.svc

# Auth
## via cert

export USERNAME=username
openssl req -batch -nodes -new -newkey rsa:4096 -sha512 -out ${USERNAME}.csr -keyout ${USERNAME}.key -subj "/CN={$USERNAME}/O=MIB"

export REQUEST=$(base64 -w 0 $USERNAME.csr)
cat << EOF | sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${USERNAME}
spec:
  request: ${REQUEST}
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF

kubectl certificate approve ${USERNAME}
kubectl get csr ${USERNAME} -o jsonpath='{.status.certificate}'
kubectl get csr ${USERNAME} -o jsonpath='{.status.certificate}' | base64 -d

## private registry
kubectl -n production create secret generic selectel-k8s \
    --from-file=.dockerconfigjson=/home/reptile/.docker/selectel-k8s.json \
    --type=kubernetes.io/dockerconfigjson
