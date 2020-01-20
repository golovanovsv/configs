# Create CA

openssl genrsa -des3 -out ca.key 2048
$ password
openssl req -x509 -new -nodes -key ca.key -sha256 -subj "/CN=kube-ca" -days 3650 -out ca.crt 

openssl genrsa -out kube-apiserver.key 2048
openssl req -new -key kube-apiserver.key -out kube-apiserver.csr -config file.cnf
openssl x509 -req -in kube-apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out kube-apiserver.crt -days 1825 -extensions v3_ext -extfile file.cnf

```bash
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = RU
ST = ST
L = Moscow
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
openssl req -new -key service-account.key -out service-account.csr -subj "/CN=kube-admin"
openssl x509 -req -in service-account.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out service-account.crt -days 1825 -extensions v3_ext -extfile kube-apiserver.cnf

openssl rsa -in key.crt -pubout > key.pub
openssl rsa -in key.crt -pubout -out key.pub
