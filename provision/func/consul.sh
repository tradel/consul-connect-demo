function install_consul_binary() {
  cd /tmp
  apt-get -y install unzip
  unzip -o /vagrant/consul_*_linux_amd64.zip -d /tmp
  install -c -m 0755 /tmp/consul /usr/local/sbin
  install -c -m 0644 /vagrant/provision/consul.service /etc/systemd/system
  install -d -m 0755 -o vagrant /data/consul /etc/consul.d

  if [[ "$#" -gt "0" ]]; then
    install -c -m 0644 $@ /etc/consul.d
  fi
}

function restart_consul() {
  systemctl daemon-reload
  systemctl enable consul
  systemctl restart consul
}

function install_consul_client() {
    ipaddr="$1"
    shift

    install_consul_binary $@
    sed -e "s/@@BIND_ADDR@@/${ipaddr}/" < /vagrant/consul/client.json.tmpl > /etc/consul.d/config.json

    restart_consul
}

function install_consul_server() {
  ipaddr="$1"
  shift

  install_consul_binary $@
  sed -e "s/@@BIND_ADDR@@/${ipaddr}/" < /vagrant/consul/server.json.tmpl > /etc/consul.d/config.json

  restart_consul
}
