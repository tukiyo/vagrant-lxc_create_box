#!/bin/sh

set -e
set -x

ROOTFS=/var/lib/lxc/centos5/rootfs
LXCTARGET=centos5
RELEASE=centos59
VENDOR_DIR=$(pwd)/../vendor

if [ "$USER" != "root" ];then
    echo "[quit] please execute by root user."
    exit 0
fi

# ----------------------------------------------------------------------

## Bootstrapping the guest container rootfs
apt-get install -qq lxc curl rinse yum -y --force-yes
sudo cp ${VENDOR_DIR}/../lxc-templates/lxc-centos5-vagrant /usr/share/lxc/templates/
sudo chmod +x /usr/share/lxc/templates/lxc-centos5-vagrant
sudo MIRROR=http://ftp.jaist.ac.jp/pub/Linux/CentOS/5.9/os/x86_64/ lxc-create -t centos5-vagrant -n centos5

### Add some basic packages
PACKAGES="curl wget which vim-enhanced"
chroot ${ROOTFS} yum install $PACKAGES -y -q

# ----------------------------------------------------------------------

## Set up a working dir
mkdir -p /tmp/vagrant-lxc-${RELEASE}

## Compress container's rootfs
cd /var/lib/lxc/$LXCTARGET
sudo tar --numeric-owner -czf /tmp/vagrant-lxc-${RELEASE}/rootfs.tar.gz ./rootfs/*

## Prepare package contents
cd /tmp/vagrant-lxc-${RELEASE}
sudo chown $USER:$USER rootfs.tar.gz
cp $VENDOR_DIR/fgrehm/lxc-template .
cp $VENDOR_DIR/fgrehm/lxc.conf .
cp $VENDOR_DIR/fgrehm/metadata.json .
chmod +x lxc-template

## Vagrant box!
tar -czf $HOME/vagrant-lxc-${RELEASE}.box ./*

rm -r /tmp/vagrant-lxc-${RELEASE}

ls -lh $HOME/vagrant-lxc-${RELEASE}.box
