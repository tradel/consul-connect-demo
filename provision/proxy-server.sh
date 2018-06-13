#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
apt-get update

ipaddr="$1"
root_token=$(awk '{ if (match($0,/Initial Root Token: (.*)/,m)) print m[1] }' /vagrant/vault-init.txt)

#
# Install Consul agent
#

cd /tmp
apt-get -y install unzip
unzip -o /vagrant/consul_*_linux_amd64.zip -d /tmp
install -c -m 0755 /tmp/consul /usr/local/sbin
install -c -m 0644 /vagrant/provision/consul.service /etc/systemd/system
install -d -m 0755 -o vagrant /data/consul /etc/consul.d
install -c -m 0644 /vagrant/consul/proxy.json /etc/consul.d
sed -e "s/@@BIND_ADDR@@/${ipaddr}/" < /vagrant/consul/client.json.tmpl > /etc/consul.d/config.json

systemctl daemon-reload
systemctl enable consul
systemctl restart consul


#
# Install nginx server
#

apt-get -y install nginx
unlink /etc/nginx/sites-enabled/default

mkdir /etc/nginx/ssl
install -c -m 0644 /vagrant/ssl/*.pem /etc/nginx/ssl

#
# Install consul-template
#

unzip -o /vagrant/consul-template_*_linux_amd64.zip -d /tmp
install -c -m 0755 /tmp/consul-template /usr/local/sbin
install -d -m 0755 -o vagrant /etc/consul-template /etc/consul-template/templates
install -c -m 0644 /vagrant/templates/proxy.nginx.ctmpl /etc/consul-template/templates
sed -e "s/@@ROOT_TOKEN@@/${root_token}/" < /vagrant/templates/proxy-templates.hcl.tmpl > /etc/consul-template/consul-template.hcl
# /usr/local/sbin/consul-template -config /etc/consul-template/consul-template.hcl -once
