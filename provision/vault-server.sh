#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update

#
# Install Vault server
#

cd /tmp
apt-get -y install unzip
unzip -o /vagrant/vault_*_linux_amd64.zip -d /tmp
install -c -m 0755 /tmp/vault /usr/local/sbin
install -c -m 0644 /vagrant/provision/vault.service /etc/systemd/system
install -d -m 0755 -o vagrant /data/vault /etc/vault.d
install -c -m 0644 /vagrant/vault/server.hcl /etc/vault.d

systemctl daemon-reload
systemctl enable vault
systemctl restart vault

echo "export VAULT_ADDR=http://localhost:8200" >> /home/vagrant/.profile
source /home/vagrant/.profile

vault operator init -key-shares=1 -key-threshold=1 | tee /vagrant/vault-init.txt
unseal_key=$(awk '{ if (match($0,/Unseal Key 1: (.*)/,m)) print m[1] }' /vagrant/vault-init.txt)
root_token=$(awk '{ if (match($0,/Initial Root Token: (.*)/,m)) print m[1] }' /vagrant/vault-init.txt)

vault operator unseal $unseal_key
vault login $root_token
vault write secret/bcl/database database=broadleaf username=broadleaf password=ech9Weith4Phei7W
