function install_consul_template() {
  root_token="$1"
  config="$2"

  unzip -o /vagrant/consul-template_*_linux_amd64.zip -d /tmp
  install -c -m 0755 /tmp/consul-template /usr/local/sbin
  install -d -m 0755 -o vagrant /etc/consul-template /etc/consul-template/templates
  sed -e "s/@@ROOT_TOKEN@@/${root_token}/" < ${config} > /etc/consul-template/consul-template.hcl
}

function run_consul_template_once() {
  /usr/local/sbin/consul-template -config /etc/consul-template/consul-template.hcl -once
}
