#!/bin/sh
ROOTFS=/var/lib/lxc/ubuntu0/rootfs
LXCTARGET=ubuntu0
RELEASE=raring
VENDOR_URL="https://raw.github.com/tukiyo/vagrant-lxc_create_box/master/vendor"

if [ "$USER" != "root" ];then
    echo "[quit] please execute by root user."
    exit 0
fi

# ----------------------------------------------------------------------

## Bootstrapping the guest container rootfs
apt-get install -qq lxc -y --force-yes
MIRROR=http://jp.archive.ubuntu.com/ubuntu lxc-create -t ubuntu-vagrant -n $LXCTARGET

## Configure the vagrant user
chroot ${ROOTFS} apt-get install -qq -y --force-yes

### Add some basic packages
PACKAGES="curl wget"
chroot ${ROOTFS} apt-get install -qq $PACKAGES -y --force-yes

### install Chef
#chroot ${ROOTFS} curl -L https://www.opscode.com/chef/install.sh -k \
#chroot ${ROOTFS} curl -L $VENDOR_URL/www.opscode.com/chef/install.sh -k \
#      | bash


## Free up some disk space
chroot ${ROOTFS} rm -rf /tmp/*
chroot ${ROOTFS} apt-get clean

# ----------------------------------------------------------------------

## Set up a working dir
mkdir -p /tmp/vagrant-lxc-${RELEASE}

## Compress container's rootfs
cd /var/lib/lxc/$LXCTARGET
sudo tar --numeric-owner -czf /tmp/vagrant-lxc-${RELEASE}/rootfs.tar.gz ./rootfs/*

## Prepare package contents
cd /tmp/vagrant-lxc-${RELEASE}
sudo chown $USER:$USER rootfs.tar.gz
#wget -q https://raw.github.com/fgrehm/vagrant-lxc/master/boxes/common/lxc-template
#wget -q https://raw.github.com/fgrehm/vagrant-lxc/master/boxes/common/lxc.conf
#wget -q https://raw.github.com/fgrehm/vagrant-lxc/master/boxes/common/metadata.json
wget -q $VENDOR_URL/fgrehm/lxc-template
wget -q $VENDOR_URL/fgrehm/lxc.conf
wget -q $VENDOR_URL/fgrehm/metadata.json
chmod +x lxc-template

## Vagrant box!
tar -czf $HOME/vagrant-lxc-${RELEASE}.box ./*

rm -r /tmp/vagrant-lxc-${RELEASE}

ls -lh $HOME/vagrant-lxc-${RELEASE}.box
