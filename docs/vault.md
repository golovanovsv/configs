## generic backend

vault write test/db/mongo/users \
  username=admin \
  password=password

vault read test/db/mongo/users

## aws backend
vault write aws/creds/deploy arn=arn:aws:iam::aws:policy/AmazonEC2eadOnlyAccess lease_duration=<seconds>
vault read aws/creds/deploy
  access_key <key>
  secret_key <token>

## mongo backend

## policy
path "test/db"{
    capabilities = ["read"]
}

## tokens
vault token-create -policy=<policy name> 

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
