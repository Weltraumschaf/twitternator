# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "debian/buster64"

    config.vm.provision "shell", inline: <<-SHELL
        export DEBIAN_FRONTEND="noninteractive"
        apt-get update
        apt-get upgrade -y
        apt-get install -y make

        (
            cd /vagrant
            make
        )
    SHELL
end
