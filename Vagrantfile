# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/xenial64"
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y gcc g++ git libreadline-dev lzma-dev bison flex make
    git clone https://github.com/postgres/postgres.git
    sudo chown -R vagrant postgres
    sed -i 's#FLEX =#FLEX = /usr/bin/flex#' postgres/src/Makefile.global
    cd postgres && ./configure && make
    sudo make install
    cd contrib && make
    sudo make install
    sudo ln -s /usr/local/pgsql/bin/* /usr/bin
    sudo useradd postgres
    sudo mkdir /usr/local/pgsql/data
    sudo chown postgres /usr/local/pgsql/data
    sudo su postgres -c "export LC_ALL=en_US.utf8 && initdb -D /usr/local/pgsql/data/"
    sudo su postgres -c "pg_ctl -D /usr/local/pgsql/data/ -l /usr/local/pgsql/data/postgres.log start"
    sudo su postgres -c "createuser -s vagrant"
  SHELL
end
