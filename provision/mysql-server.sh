#!/bin/bash

. /vagrant/provision/func/proxy.sh
. /vagrant/provision/func/consul.sh

export DEBIAN_FRONTEND=noninteractive
apt-get update

ipaddr="$1"
root_token=$(awk '{ if (match($0,/Initial Root Token: (.*)/,m)) print m[1] }' /vagrant/vault-init.txt)

#
# Install Consul agent
#

install_consul_client "$ipaddr" /vagrant/consul/mysql.json

#
# Install MySQL server
#
export MYSQL_PWD="abc123"

debconf-set-selections <<< "mysql-server mysql-server/root_password password ${MYSQL_PWD}"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${MYSQL_PWD}"
apt-get -y install mysql-server monitoring-plugins
install -c -m 0644 /vagrant/mysql/mysqld.cnf /etc/mysql/mysql.conf.d

systemctl enable mysql
systemctl restart mysql

mysql -u root -e "create user if not exists root@'%' identified by 'abc123'"
mysql -u root -e "grant all privileges on *.* to root@'%' with grant option"
mysql -u root -e "grant proxy on '@' to root@'%'"

mysql -u root -e "create database if not exists broadleaf"
mysql -u root -e "create user if not exists broadleaf@'%' identified by 'ech9Weith4Phei7W'"
mysql -u root -e "grant all privileges on broadleaf.* to broadleaf@'%'"

mysql -u root -e "flush privileges"
