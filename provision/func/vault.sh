function install_vault_server() {
  cd /tmp
  apt-get -y install unzip jq

  unzip -o /vagrant/vault_*_linux_amd64.zip -d /tmp
  install -c -m 0755 /tmp/vault /usr/local/sbin
  install -c -m 0644 /vagrant/provision/vault.service /etc/systemd/system
  install -d -m 0755 -o vagrant /data/vault /etc/vault.d
  install -c -m 0644 /vagrant/vault/server.hcl /etc/vault.d

  systemctl daemon-reload
  systemctl enable vault
  systemctl restart vault
}

function get_root_token() {
  awk '{ if (match($0,/Initial Root Token: (.*)/,m)) print m[1] }' /vagrant/vault-init.txt
}
