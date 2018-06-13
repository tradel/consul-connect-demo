#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update

ipaddr="$1"

#
# Install Consul server
#

cd /tmp
apt-get -y install unzip
unzip -o /vagrant/consul_*_linux_amd64.zip -d /tmp
install -c -m 0755 /tmp/consul /usr/local/sbin
install -c -m 0644 /vagrant/provision/consul.service /etc/systemd/system
install -d -m 0755 -o vagrant /data/consul /etc/consul.d
sed -e "s/@@BIND_ADDR@@/${ipaddr}/" < /vagrant/consul/server.json.tmpl > /etc/consul.d/config.json

systemctl daemon-reload
systemctl enable consul
systemctl restart consul

consul intention create -deny '*' '*'
consul intention create -allow admin mysql
consul intention create -allow site mysql
consul intention create -allow proxy admin
consul intention create -allow proxy site
