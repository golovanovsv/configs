# Vault

## login

export VAULT_ADDR=<https>
vault login -method=ldap username=reptile  # Токен сохраняется в ~/.vault-token

## secrets (v2) engine

vault kv list <engine-name>

vault kv get [-field=kubeconfig] <engine-name>/k8s

vault kv put <engine-name>/mongo/admin \
  username=admin \
  password=password

vault kv patch <engine-name>/mongo/admin newuser=newpassword

vault kv metadata get <engine-name>/mongo/admin

vault kv delete [-versions=3] <engine-name>/mongo/admin

## PKI (SSL) backend

vault secrets enable -path=<engine-name> pki -max-lease-ttl=87600h
vault write <engine-name>/root/generate/internal common_name=VaultCA issuer_name=VaultCA ttl=87600h
curl https://<vault-url>/v1/<engine-name>/ca/pem                    # default issuer certificate
curl https://<vault-url>/v1/<engine-name>/issuer/<issuer-name>/pem  # <issuer-name> issuer certificate

## mongo backend

## policy

path "test/db"{
    capabilities = ["read"]
}

## tokens

vault token create -policy=<policy name>

## ansible

Плагин (?) ansible-vault

{{ lookup('vault', 'test/db/mongo/users).username }}

## terraform

data "vault_generic_secret" "mongo" {
  path = "test/db/mongo/users"
}

resource "aws_ec2_instance" "server" {
  location = ${data.vault_generic_secret.mongo.data["username"]}
}

## python

import hvac
client = hvac.Client(url=os.getenv("VAULT_ADDR"),token=os.getenv("VAULT_TOKEN"))
secret = client.read("test/db/mongo/users")

bash```
{
  "backend": {
    "etcd": {
      "address": "https://172.22.5.133:2379,https://172.22.3.99:2379,https://172.22.1.233:2379",
      "ha_enabled": "true",
      "redirect_addr": "https://ip-172-22-5-133.eu-west-1.compute.internal:8200",
      "tls_ca_file": "/etc/ssl/etcd/ssl/ca.pem",
      "tls_cert_file": "/etc/ssl/etcd/ssl/node-ip-172-22-5-133.eu-west-1.compute.internal.pem",
      "tls_key_file": "/etc/ssl/etcd/ssl/node-ip-172-22-5-133.eu-west-1.compute.internal-key.pem"
    }
  },
  "cluster_name": "kubernetes-vault",
  "default_lease_ttl": "50080h",
  "listener": {
    "tcp": {
      "address": "0.0.0.0:8200",
      "tls_cert_file": "/etc/vault/ssl/api.pem",
      "tls_cipher_suites": "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA",
      "tls_key_file": "/etc/vault/ssl/api-key.pem",
      "tls_prefer_server_cipher_suites": true
    }
  },
  "max_lease_ttl": "87600h",
  "telemetry": {
    "disable_hostname": false,
    "prometheus_retention_time": "60s"
  },
  "ui": true
}
```
