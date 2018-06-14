Three-Tier ECommerce Demo for Consul Connect
============================================

This project is designed to demo the capabilities of the new Connect feature
in HashiCorp Consul. Connect replaces IP-based firewalls with service-level
security based around the concept of _intentions_.

This demo showcases the following features of the Hashi stack:

 * Consul and Consul Connect
 * Consul Templates to dynamically generate configuration files
 * Vault for secret storage
 * Vagrant to run multiple VM's on a single host


# Prerequisites

 1. Install either VirtualBox or Parallels Desktop.
 2. Install Vagrant.
 3. Download the latest binaries for Consul, Vault, and Consul-Template.
    Place them in the root folder of the project, but leave them zipped up.
    You'll have something like this:

        consul-template_0.19.4_linux_amd64.zip
        consul_1.2.0-beta3_linux_amd64.zip     
        vault_0.10.2_linux_amd64.zip

# Running the Demo

Open a shell prompt and run `vagrant up`. It should take a while, but
eventually you'll have six boxes running:

 1. `consul0` - Consul and Vault server
 2. `mysql` - Database server
 3. `admin` - Broadleaf Commerce admin server
 4. `site0` and `site1` - Broadleaf Commerce app servers
 5. `proxy` - Nginx proxy server

# Caveats

Consul-Template doesn't support Connect yet, so although there is a template
to dynamically generate the `nginx.conf`, it isn't used right now. 
