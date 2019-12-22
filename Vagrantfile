# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "debian/buster64"
    config.vm.hostname = "twitternator"

    config.vm.provision "shell", inline: <<-SHELL
        export DEBIAN_FRONTEND="noninteractive"
        apt-get update
        apt-get upgrade -y
        apt-get install -y make git

        (
            cd /vagrant
            make
        )
    SHELL
end
