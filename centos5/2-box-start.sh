#!/bin/sh
if [ "$USER" = "root" ];then
    echo "[quit] please execute by normal user."
    exit 0
fi

RELEASE=centos59

mkdir -p ~/local/vagrant/${RELEASE} && cd ~/local/vagrant/${RELEASE}
vagrant init my-centos59 $HOME/vagrant-lxc-${RELEASE}.box
vagrant up --provider=lxc
#vagrant ssh -c "sudo chown -R vagrant:vagrant /home/vagrant"
vagrant ssh
