#!/bin/bash

. /vagrant/provision/func/proxy.sh
. /vagrant/provision/func/vault.sh

export DEBIAN_FRONTEND=noninteractive
apt-get update

#
# Install Vault server
#
install_vault_server

echo "export VAULT_ADDR=http://localhost:8200" >> /home/vagrant/.profile
export VAULT_ADDR=http://localhost:8200

until curl -fs -o /dev/null localhost:8200/v1/sys/init; do
  echo "Waiting for Vault to start..."
  sleep 1
done

init=$(curl -fs localhost:8200/v1/sys/init | jq -r .initialized)

if [ "$init" == "false" ]; then
  echo "Initializing Vault"
  vault operator init -key-shares=1 -key-threshold=1 > /vagrant/vault-init.txt
else
  echo "Vault is already initialized"
fi

sealed=$(curl -fs localhost:8200/v1/sys/seal-status | jq -r .sealed)
unseal_key=$(awk '{ if (match($0,/Unseal Key 1: (.*)/,m)) print m[1] }' /vagrant/vault-init.txt)
root_token=$(awk '{ if (match($0,/Initial Root Token: (.*)/,m)) print m[1] }' /vagrant/vault-init.txt)

if [ "$sealed" == "true" ]; then
  echo "Unsealing Vault"
  vault operator unseal $unseal_key > /dev/null
else
  echo "Vault is already unsealed"
fi

vault login $root_token > /dev/null
vault write secret/bcl/database database=broadleaf username=broadleaf password=ech9Weith4Phei7W > /dev/null
