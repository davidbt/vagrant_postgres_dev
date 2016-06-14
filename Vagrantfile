# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "geerlingguy/ubuntu1604"

  config.vm.synced_folder ".", "/home/vagrant/shared"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 4
    vb.name = "postgresql-devel"
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
    sleep 10
    sudo su postgres -c "createdb test"
    cat /home/vagrant/shared/test_parallel.sql | sudo su postgres -c "psql test"
  SHELL
end
