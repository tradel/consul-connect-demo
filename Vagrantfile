# coding: utf-8

Vagrant.require_version ">= 2.0.0"

UBUNTU_BOX = "parallels/ubuntu-16.04"
# UBUNTU_BOX = "ubuntu/xenial64"
VIRTUAL_NET = "10.13.39"

Vagrant.configure("2") do |config|

  # Consul/Vault server
  config.vm.define "consul0", autostart: true do |m|
    box_ip = "#{VIRTUAL_NET}.10"
    m.vm.box = UBUNTU_BOX
    m.vm.provider "virtualbox" do |vb|
      vb.name = "consul0"
      vb.memory = 1024
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
      vb.linked_clone = true
    end
    m.vm.provider "parallels" do |p|
      p.name = "consul0"
      p.memory = 1024
      p.linked_clone = true
    end
    m.vm.network "private_network", ip: box_ip
    m.vm.network "forwarded_port", guest: 8500, host: 8500
    m.vm.network "forwarded_port", guest: 8200, host: 8200
    m.vm.provision "hosts", autoconfigure: true, sync_hosts: true
    m.vm.provision "shell" do |sh|
      sh.path = "provision/consul-server.sh"
      sh.args = box_ip
    end
    m.vm.provision "shell" do |sh|
      sh.path = "provision/vault-server.sh"
      sh.args = box_ip
    end
  end

  # MySQL server
  config.vm.define "mysql", autostart: true do |m|
    box_ip = "#{VIRTUAL_NET}.11"
    m.vm.box = UBUNTU_BOX
    m.vm.provider "virtualbox" do |vb|
      vb.name = "mysql"
      vb.memory = 512
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
      vb.linked_clone = true
    end
    m.vm.provider "parallels" do |p|
      p.name = "mysql"
      p.memory = 512
      p.linked_clone = true
    end
    m.vm.network "private_network", ip: box_ip
    m.vm.provision "hosts", autoconfigure: true, sync_hosts: true
    m.vm.provision "shell" do |sh|
      sh.path = "provision/mysql-server.sh"
      sh.args = box_ip
    end
  end

  # Broadleaf site server
  config.vm.define "admin", autostart: true do |m|
    box_ip = "#{VIRTUAL_NET}.12"
    m.vm.box = UBUNTU_BOX
    m.vm.provider "virtualbox" do |vb|
      vb.name = "admin"
      vb.memory = 1024
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
      vb.linked_clone = true
    end
    m.vm.provider "parallels" do |p|
      p.name = "admin"
      p.memory = 1024
      p.linked_clone = true
    end
    m.vm.network "private_network", ip: box_ip
    m.vm.network "forwarded_port", guest: 8444, host: 8444
    m.vm.provision "hosts", autoconfigure: true, sync_hosts: true
    m.vm.provision "shell" do |sh|
      sh.path = "provision/admin-server.sh"
      sh.args = box_ip
    end
  end

  # Broadleaf site server
  %w(site0 site1).each_with_index do |nodename, index|
    config.vm.define nodename, autostart: true do |m|
      box_ip = "#{VIRTUAL_NET}.#{13 + index}"
      m.vm.box = UBUNTU_BOX
      m.vm.provider "virtualbox" do |vb|
        vb.name = nodename
        vb.memory = 1024
        vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
        vb.linked_clone = true
      end
      m.vm.provider "parallels" do |p|
        p.name = nodename
        p.memory = 1024
        p.linked_clone = true
      end
      m.vm.network "private_network", ip: box_ip
      if index == 0 then
        m.vm.network "forwarded_port", guest: 8443, host: 8443
      end
      m.vm.provision "hosts", autoconfigure: true, sync_hosts: true
      m.vm.provision "shell" do |sh|
        sh.path = "provision/site-server.sh"
        sh.args = box_ip
      end
    end
  end

  # Consul/Vault server
  config.vm.define "proxy", autostart: true do |m|
    box_ip = "#{VIRTUAL_NET}.20"
    m.vm.box = UBUNTU_BOX
    m.vm.provider "virtualbox" do |vb|
      vb.name = "proxy"
      vb.memory = 512
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
      vb.linked_clone = true
    end
    m.vm.provider "parallels" do |p|
      p.name = "proxy"
      p.memory = 512
      p.linked_clone = true
    end
    m.vm.network "private_network", ip: box_ip
    m.vm.network "forwarded_port", guest: 443, host: 443
    m.vm.provision "hosts", autoconfigure: true, sync_hosts: true
    m.vm.provision "shell" do |sh|
      sh.path = "provision/proxy-server.sh"
      sh.args = box_ip
    end
  end

end
