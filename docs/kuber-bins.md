# kubernetes binaries

Только установка бинарников

## Install containerd

```bash
sudo mkdir -p /etk/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc
cat << EOF | sudo tee /etc/apt/sources.list.d/docker.list
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable
EOF
sudo apt update
sudo apt install -y --no-install-recommends containerd.io
```

## Install kubernetes

```bash
sudo mkdir -p /etc/apt/keyrings
curl -sL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo tee /etc/apt/keyrings/kubernetes.asc
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes.asc] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
```

## Kubernetes preflight

```bash
echo "br_netfilter" | sudo tee /etc/modules-load.d/br_netfilter.conf
sudo modprobe br_netfilter
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo swapoff -a
sudo sed -e '/swap/ s/^#*/#/' -i /etc/fstab
```

## Install both: containerd + kubernetes

```bash
export KUBERNETES_VERSION=1.34
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc
curl -sL https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_VERSION}/deb/Release.key | sudo tee /etc/apt/keyrings/kubernetes.asc
cat << EOF | sudo tee /etc/apt/sources.list.d/docker.list
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable
EOF
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes.asc] https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_VERSION}/deb/ /
# deb [signed-by=/etc/apt/keyrings/kubernetes.asc] https://mirror.yandex.ru/mirrors/pkgs.k8s.io/core/stable/v${KUBERNETES_VERSION}/deb/ /
EOF
sudo apt update
sudo apt install -y --no-install-recommends kubelet kubeadm kubectl containerd.io cri-tools
```

```bash
# KUBERNETES_VERSION <=1.27
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
```

https://dl.k8s.io/v1.27.16/kubernetes-node-linux-amd64.tar.gz

## Configure containerd 1.7

```bash
sudo mkdir -p /etc/containerd/certs.d
cat << EOF | sudo tee /etc/containerd/config.toml
version = 2

[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
    sandbox_image = "registry.k8s.io/pause:3.8"

    [plugins."io.containerd.grpc.v1.cri".containerd]
      discard_unpacked_layers = true
      default_runtime_name = "runc"

      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v2"
          SystemdCgroup = true  # containerd 1.6

          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            SystemdCgroup = true  # containerd 1.7

    [plugins."io.containerd.grpc.v1.cri".registry]
      config_path = "/etc/containerd/certs.d"
EOF
sudo systemctl restart containerd
```

## Configure containerd 2.2

```bash
sudo mkdir -p /etc/containerd/certs.d
cat << EOF | sudo tee /etc/containerd/config.toml
version = 3

[plugins]
  [plugins."io.containerd.snapshotter.v1.devmapper"]
    discard_blocks = true

  [plugins."io.containerd.cri.v1.runtime"]
    [plugins."io.containerd.cri.v1.runtime".containerd]
      default_runtime_name = "runc"

      [plugins."io.containerd.cri.v1.runtime".containerd.runtimes]
        [plugins."io.containerd.cri.v1.runtime".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v2"

          [plugins."io.containerd.cri.v1.runtime".containerd.runtimes.runc.options]
            SystemdCgroup = true  # containerd 2.2

  [plugins."io.containerd.cri.v1.images"]
    [plugins."io.containerd.cri.v1.images".pinned_images]
      sandbox = "registry.k8s.io/pause:3.10.1"

    [plugins."io.containerd.cri.v1.images".registry]
      config_path = "/etc/containerd/certs.d:/etc/docker/certs.d"
EOF
sudo systemctl restart containerd
```

## Configure crictl

```bash
cat << EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 2
EOF
```
