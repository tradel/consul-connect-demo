#!/bin/bash

. /vagrant/provision/func/proxy.sh
. /vagrant/provision/func/consul.sh

export DEBIAN_FRONTEND=noninteractive
apt-get update

#
# Install Consul server
#

ipaddr="$1"
install_consul_server "$ipaddr" || exit
sleep 5

echo "Setting intentions in Consul"
consul intention create -replace -deny '*' '*'
consul intention create -replace -allow admin mysql
consul intention create -replace -allow site mysql
consul intention create -replace -allow proxy admin
consul intention create -replace -allow proxy site
