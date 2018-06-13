#!/bin/bash

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
install -c -m 0644 /vagrant/consul/bcl-admin.json /etc/consul.d
sed -e "s/@@BIND_ADDR@@/${ipaddr}/" < /vagrant/consul/client.json.tmpl > /etc/consul.d/config.json

systemctl daemon-reload
systemctl enable consul
systemctl restart consul


#
# Install Java and Maven
#

apt-get -y install default-jdk maven


#
# Clone Broadleaf
#

cd $HOME
apt-get -y install git
git clone https://github.com/tradel/DemoSite.git


#
# Install consul-template
#

unzip -o /vagrant/consul-template_*_linux_amd64.zip -d /tmp
install -c -m 0755 /tmp/consul-template /usr/local/sbin
install -d -m 0755 -o vagrant /etc/consul-template /etc/consul-template/templates
install -c -m 0644 /vagrant/templates/common-shared.properties.ctmpl /etc/consul-template/templates
sed -e "s/@@ROOT_TOKEN@@/${root_token}/" < /vagrant/templates/consul-template.hcl.tmpl > /etc/consul-template/consul-template.hcl
/usr/local/sbin/consul-template -config /etc/consul-template/consul-template.hcl -once


#
# Install and start Broadleaf
#

pkill java

cd $HOME/DemoSite
mvn install

cd $HOME/DemoSite/admin
nohup mvn spring-boot:run &
