#!/bin/bash

. /vagrant/provision/func/proxy.sh
. /vagrant/provision/func/consul.sh
. /vagrant/provision/func/vault.sh
. /vagrant/provision/func/consul-template.sh

export DEBIAN_FRONTEND=noninteractive
apt-get update

#
# Install Consul client
#

ipaddr="$1"
install_consul_client "$ipaddr" "/vagrant/consul/bcl-site.json"

#
# Install Java and Maven
#

apt-get -y install default-jdk maven
install -d -m 0755 $HOME/.m2
install -c -m 0644 /vagrant/maven/settings.xml $HOME/.m2/settings.xml

#
# Clone Broadleaf
#

cd $HOME
apt-get -y install git

if [ ! -d ./DemoSite ]; then
  git clone https://github.com/tradel/DemoSite.git
fi

#
# Install consul-template
#

root_token=$(get_root_token)
install_consul_template "$root_token" "/vagrant/templates/bcl-templates.hcl.tmpl"
install -c -m 0644 /vagrant/templates/common-shared.properties.ctmpl /etc/consul-template/templates
run_consul_template_once

#
# Install and start Broadleaf
#

pkill java

cd $HOME/DemoSite
mvn install || exit 1

cd $HOME/DemoSite/site
nohup mvn spring-boot:run >> $HOME/site.log &
