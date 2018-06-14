#!/usr/bin/env bash

. /vagrant/provision/func/proxy.sh
. /vagrant/provision/func/consul.sh
. /vagrant/provision/func/vault.sh
. /vagrant/provision/func/consul-template.sh

export DEBIAN_FRONTEND=noninteractive
apt-get update

#
# Install Consul agent
#

ipaddr="$1"
install_consul_client "$ipaddr" "/vagrant/consul/proxy.json"

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

root_token=$(get_root_token)
install_consul_template "$root_token" "/vagrant/templates/proxy-templates.hcl.tmpl"
install -c -m 0644 /vagrant/templates/proxy.nginx.ctmpl /etc/consul-template/templates
# run_consul_template_once
