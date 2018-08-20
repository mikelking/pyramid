# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.0.0"
#Vagrant::DEFAULT_SERVER_URL.replace('https://vagrantcloud.com')

INSTALL_ANSIBLE = <<BASH
#!/usr/bin/env bash
if [ -z $(which ansible) ]; then
  echo "### INSTALL SOFTWARE PROPERTIES COMMON ###"
  sudo apt-get install -y software-properties-common
  echo "### INSTALL PPA ###"
  sudo apt-add-repository ppa:ansible/ansible
  echo "### UPDATE APT CACHE ###"
  sudo apt-get update
  # echo "### UPGRADE PACKAGES"
  # sudo apt-get upgrade -y
  echo "### INSTALL ANSIBLE ###"
  sudo apt-get install -y ansible
fi
#sudo ansible-galaxy install -r /vagrant/ansible/roles/requirements.yml
BASH

# NOTE: Set the following environment variable to allow color output from Ansible:
# VAGRANT_FORCE_COLOR=1
ANSIBLE_INVENTORY = {
    "vagrant" => ["pyramid1"],
    "lcl" => ["pyramid1"],
    "lcl:vars" => ["project_path='/vagrant'"]
}

Vagrant.configure("2") do |config|
  # Work-around for the "stdin: is not a tty" error message
  #config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.define "pyramid1" do |pyramid-setup|
    pyramid.vm.hostname = "pyradmid.local"

  # Ubuntu 14.04.5 LTS (Trusty Tahr)
  # config.vm.box = "ubuntu/trusty64"

  # Ubuntu 16.04.1 LTS (Xenial Xerus)
    pyramid.vm.box = "ubuntu/xenial64"

  # Ubuntu 18.04.1 LTS (Bionic Beaver)
  # pyramid.vm.box = "bento/ubuntu-18.04"

    pyramid.vm.network "private_network", ip: "192.168.245.10"
    pyramid.vm.synced_folder "../", "/vagrant"
    pyramid.vm.provider "virtualbox" do |vb|
      vb.name = "Pyramid Base"
      vb.memory = "2048"
      vb.cpus = "2"
    end

    # Eliminates the need to manual host entries so long at the vagrant-hostsupdater is installed.
    vagrant plugin install vagrant-hostsupdater
    if Vagrant.has_plugin?("vagrant-hostsupdater")
      config.hostsupdater.aliases = ["olivent.pyramid.local", "ocom.pyramid.local", "jafdip.pyramid.local", "t329.pyramid.local", "mk.pyramid.local", "bnn.pyramid.local", "robo.pyramid.local"]
    else
      puts '*******************************************************************************'
      puts 'Hosts file entries:'
      puts '192.168.245.10  pyramid.local olivent.pyramid.local ocom.pyramid.local jafdip.pyramid.local t329.pyramid.local'
      puts '192.168.245.10  mk.pyramid.local bnn.pyramid.local robo.pyramid.local'
      puts '*******************************************************************************'
    end

    # Install Ansible on Guest
    pyramid.vm.provision "shell", keep_color: true, inline: INSTALL_ANSIBLE
    # Provision with Ansible
    pyramid.vm.provision "ansible_local" do |ansible|
      # ansible.verbose = "v" # Debugging
      # ansible.compatibility_mode = "2.0"
      ansible.groups = ANSIBLE_INVENTORY
      ansible.playbook = "ansible/provisioning/playbook.yml"
      ansible.config_file = "ansible/provisioning/group_vars/all/main.cfg"
      # ansible.playbook = "ansible/configure-vagrant.yml"
      # ansible.config_file = "ansible/ansible.cfg"
      # ansible.vault_password_file = "ansible/vault.password"
    end
  end
end
