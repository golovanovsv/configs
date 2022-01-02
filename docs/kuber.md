# kubectl
kubectl -n <ns> logs <pod> --previous --since 1h

kubectl -n <ns> create secret tls <name> --cert <certfile> --key <keyfile>
kubectl -n <ns> create secret tls <name> --cert <certfile> --key <keyfile> --dry-run -o yaml | kubectl apply -f -

kubectl -n <ns> get pod <pod> -o yaml
kubectl -n <ns> get pod <pod> -o json
kubectl -n <ns> get pod <pod> -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}'
kubectl get no -o jsonpath='{ range .items[*]}{.metadata.name}{"\t"}{.status.allocatable.cpu}:{.status.allocatable.memory}{"\t"}{.spec.taints[*].key}{"\n"}{ end }'
kubectl -n <ns> get pod --sort-by='{.firstTimestamp}'
kubectl -n <ns> get pod --sort-by=.metadata.creationTimestamp

# scheduller
kubectl -n kube-system describe endpoints kube-scheduler # who is leader

## list all images in cluster
kubectl get pods --all-namespaces -o jsonpath="{..image}" | tr -s '[[:space:]]' '\n' | sort | uniq -c | sort -gr

kubectl get mutatingwebhookconfiguration
kubectl get ValidatingWebhookConfiguration
kubectl get endpoints
kubectl get CSINode
kubectl get csidrivers

kubectl rollout restart deployment/

# kubectl systems
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint nodes --all node-role.kubernetes.io/master:NoSchedule-
kubectl taint node k0 node-role.kubernetes.io/master='':NoSchedule

kubectl drain <node> [--ignore-daemonsets]

kubectl label node k0 node-role.kubernetes.io/ingress=true
kubectl label node k0 node-role.kubernetes.io/ingress-

kubectl api-versions
kubectl get cs

# kubectl docs
kubectl explain pod.spec.containers

# kubeadm
sudo kubeadm init --node-name k0.xaddr.ru --kubernetes-version 1.16 --pod-network-cidr=10.244.0.0/20 --upload-certs --control-plane-endpoint 5.189.0.215
sudo kubeadm init --node-name k0.xaddr.ru --upload-certs --config /home/reptile/cluster.yml
sudo kubeadm token create --print-join-command

sudo kubeadm join --pod-network-cidr=10.244.0.0/24

kubeadm join 5.189.0.215:6443 [--control-plane] --token <token> --discovery-token-ca-cert-hash <dtoken>

[config.yaml](https://godoc.org/k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/v1beta2)

# CIDRS
kubectl cluster-info dump | jq '.items[0].spec.podCIDRs'

# kubeadm upload certs

sudo kubeadm init phase upload-certs --upload-certs

# kubeadm upgrade
Обновляться можно только на одну версию. Таким образом необходимо:
- Установить последний kubeadm следующей версии: `apt policy | grep kubeadm; apt install kubeadm=<new version>`
- Обновить control plane на каждом мастере: `kubeadm upgrade plan; kubeadm upgrade apply <new version>`
- Обновить kubelet-ы: `apt install kubelet=<new version>`

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

## API
ingress: extensions/v1beta1 >= 1.14 networking.k8s.io/v1beta1

### Auth in API
export TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
curl -k -H "Authorization: Bearer $TOKEN" https://kubernetes.default.svc

# Auth
## via cert

openssl req -batch -nodes -new -newkey rsa:4096 -sha512 -out <username>.csr -keyout <username>.key -subj "/CN=<username>/O=<org>"

export REQUEST=$(base64 -w 0 <username>.csr)
cat << EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: <username>
spec:
  request: ${REQUEST}
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF

kubectl certificate <approve|decline> <username>
kubectl get csr <username> -o jsonpath='{.status.certificate}' | base64 -d

openssl req -batch -nodes -new -newkey rsa:4096 -sha512 -out ingress0.csr -keyout ingress0.key -subj "/CN=system:node:ingress0/O=system:nodes"

export REQUEST=$(base64 -w 0 ingress0.csr)
cat << EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ingress0
spec:
  request: ${REQUEST}
  signerName: kubernetes.io/kube-apiserver-client-kubelet
  usages:
  - client auth
  - key encipherment
  - digital signature
EOF

kubectl get csr ingress0 -o jsonpath='{.status.certificate}' | base64 -d

# kubeadm config
apiVersion: kubeadm.k8s.io/v1beta1
kind: ClusterConfiguration
kubernetesVersion: stable
controlPlaneEndpoint: "192.168.0.1:6443"
apiServer:
  # certSANs:
  #  - "192.168.0.1"
  extraArgs:
    anonymous-auth: "false"
    audit-log-path: /var/log/k8s.log
controllerManager: {}
scheduler: {}
etcd:
  local:
    dataDir: "/var/lib/k8s-etcd"
