# kubectl

kubectl -n <ns> logs <pod> --previous --since 1h

kubectl -n <ns> create secret tls <name> --cert <certfile> --key <keyfile>
kubectl -n <ns> create secret tls <name> --cert <certfile> --key <keyfile> --dry-run -o yaml | kubectl apply -f -

kubectl -n <ns> get pod <pod> -o yaml
kubectl -n <ns> get pod <pod> -o json
kubectl -n <ns> get pod <pod> -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}'

kubectl get mutatingwebhookconfiguration
kubectl get endpoints
kubectl get CSINode
kubectl get csidrivers

# kubectl systems
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint nodes --all node-role.kubernetes.io/master:NoSchedule-
kubectl taint node k0 node-role.kubernetes.io/master='':NoSchedule

kubectl label node k0 node-role.kubernetes.io/ingress=true
kubectl label node k0 node-role.kubernetes.io/ingress-

kubectl api-versions
kubectl get cs

# kubeadm

sudo kubeadm init --node-name k0.xaddr.ru --kubernetes-version 1.16 --pod-network-cidr=10.244.0.0/23 --upload-certs --control-plane-endpoint 5.189.0.215
sudo kubeadm init --node-name k0.xaddr.ru --upload-certs --config /home/reptile/cluster.yml
sudo kubeadm token create --print-join-command

sudo kubeadm join --pod-network-cidr=10.244.0.0/24

kubeadm join 5.189.0.215:6443 [--control-plane] --token <token> --discovery-token-ca-cert-hash <dtoken>

[config.yaml](https://godoc.org/k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/v1beta2)

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

# Nginxinx-ingress
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
