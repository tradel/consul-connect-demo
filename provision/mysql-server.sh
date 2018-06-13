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
install -c -m 0644 /vagrant/consul/mysql.json /etc/consul.d
sed -e "s/@@BIND_ADDR@@/${ipaddr}/" < /vagrant/consul/client.json.tmpl > /etc/consul.d/config.json

systemctl daemon-reload
systemctl enable consul
systemctl restart consul


#
# Install MySQL server
#

debconf-set-selections <<< 'mysql-server mysql-server/root_password password abc123'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password abc123'
apt-get -y install mysql-server
install -c -m 0644 /vagrant/mysql/mysqld.cnf /etc/mysql/mysql.conf.d

systemctl enable mysql
systemctl restart mysql

mysql -u root -pabc123 -e "create user root@'%' identified by 'abc123'"
mysql -u root -pabc123 -e "grant all privileges on *.* to root@'%' with grant option"
mysql -u root -pabc123 -e "grant proxy on '@' to root@'%'"

mysql -u root -pabc123 -e "create database broadleaf"
mysql -u root -pabc123 -e "create user broadleaf@'%' identified by 'ech9Weith4Phei7W'"
mysql -u root -pabc123 -e "grant all privileges on broadleaf.* to broadleaf@'%'"

mysql -u root -pabc123 -e "flush privileges"
