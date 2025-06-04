# kubernetes start

Конфигурации по-умолчанию:

```bash
kubeadm config print init-defaults
kubeadm config print join-defaults
```

## kubernetes init

```bash
cat << EOF > cluster.yaml
# https://kubernetes.io/docs/reference/config-api/kubeadm-config.v1beta3/
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: stable
clusterName: k8s-cluster
# controlPlaneEndpoint: "192.168.217.100:6443"
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
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
---
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
mode: ipvs
EOF
```

```bash
sudo kubeadm --config cluster.yaml`
```

## kubernetes join

```bash
cat << EOF > cluster.yaml
# https://kubernetes.io/docs/reference/config-api/kubeadm-config.v1beta3/
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
EOF
```
