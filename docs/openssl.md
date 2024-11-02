# Create CA

openssl genrsa -des3 -out ca.key 2048
$ password
openssl req -x509 -new -nodes -key ca.key -sha256 -subj "/CN=kube-ca" -days 3650 -out ca.crt

## Create dhparm

openssl dhparam -out /etc/nginx/ssl/dhparam 2048

## Create selfdigned CA
# via csr

openssl genpkey -algorithm ed25519 -out private.key
openssl req -new -nodes -key ca.key -out ca.csr
openssl x509 -req -in ca.csr -signkey ca.key -days 3700 -out ca.crt

# without csr

openssl req -x509 -sha256 -days 3700 -nodes -newkey rsa:2048 -subj "/CN=demo.mlopshub.com/C=US/L=San Fransisco" -keyout ca.key -out ca.crt 

## Create selfsigned certificate

openssl req -nodes -x509 -newkey rsa:4096 -keyout local.key -out local.pem -days 1825 -subj "/CN=Cybertonica gitlab server"

## Create certificate via csr

openssl genrsa -out kube-apiserver.key 2048
openssl req -new -key kube-apiserver.key -out kube-apiserver.csr -config file.cnf
openssl x509 -req -CA ca.crt -CAkey ca.key -CAcreateserial -in kube-apiserver.csr -out kube-apiserver.crt -days 1825 -extensions v3_ext -extfile file.cnf

```bash
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = RU
ST = State
L = Location/City
O = OrgName
OU = OrgUnit
CN = kube-ca

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster
DNS.5 = kubernetes.default.svc.cluster.local
IP.1 = <MASTER_IP>
IP.2 = <MASTER_CLUSTER_IP>

[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=keyEncipherment,dataEncipherment
extendedKeyUsage=serverAuth,clientAuth
subjectAltName=@alt_names
```

## CreateUsers

openssl genrsa -out service-account.key 2048
openssl req -new -key service-account.key -out service-account.csr -subj "/CN=<user-name>/O=<user-group>"
# users:
# - kubernetes-admin [/CN=kubernetes-admin/O=system:masters]
# - system:kube-scheduler [/CN=system:kube-scheduler]
# - system:kube-controller-manager [/CN=system:kube-controller-manager]
# groups:
# - system:masters

openssl x509 -req -in service-account.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out service-account.crt -days 1825 -extensions v3_ext -extfile kube-apiserver.cnf

openssl rsa -in key.crt -pubout > key.pub
openssl rsa -in key.crt -pubout -out key.pub

kubectl --kubeconfig admin.conf config set-cluster zaddr --server="https://172.16.121.13:6443" --certificate-authority="/etc/kubernetes/pki/ca.crt" --embed-certs=true
kubectl --kubeconfig admin.conf config set-credentials kubernetes-admin --client-key="/etc/kubernetes/pki/kube-scheduller.key" --client-certificate="/etc/kubernetes/pki/kube-scheduller.crt" --embed-certs=true
kubectl config --kubeconfig admin.conf set-context zaddr --cluster=zaddr --user=kubernetes-admin
kubectl config --kubeconfig admin.conf use-context zaddr

kubectl --kubeconfig scheduller.conf config set-cluster zaddr --server="https://172.16.121.13:6443" --certificate-authority="/etc/kubernetes/pki/ca.crt" --embed-certs=true
kubectl --kubeconfig scheduller.conf config set-credentials "system:kube-scheduler" --client-key="/etc/kubernetes/pki/kube-scheduller.key" --client-certificate="/etc/kubernetes/pki/kube-scheduller.crt" --embed-certs=true
kubectl config --kubeconfig scheduller.conf set-context zaddr --cluster=zaddr --user="system:kube-scheduler"
kubectl config --kubeconfig scheduller.conf use-context zaddr

kubectl --kubeconfig controller-manager.conf config set-cluster zaddr --server="https://172.16.121.13:6443" --certificate-authority="/etc/kubernetes/pki/ca.crt" --embed-certs=true
kubectl --kubeconfig controller-manager.conf config set-credentials "system:kube-controller-manager" --client-key="/etc/kubernetes/pki/kube-scheduller.key" --client-certificate="/etc/kubernetes/pki/kube-scheduller.crt" --embed-certs=true
kubectl config --kubeconfig controller-manager.conf set-context zaddr --cluster=zaddr --user="system:kube-controller-manager"
kubectl config --kubeconfig controller-manager.conf use-context zaddr

## create key pair

openssl genpkey -algorithm ed25519 -out private.key
openssl pkey -in private.key -pubout -out public.key

## Get certificate info over net

openssl s_client -connect <server-address>:<port>
