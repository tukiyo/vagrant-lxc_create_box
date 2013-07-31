#!/bin/sh

ROOTFS=/var/lib/lxc/centos0/rootfs
LXCTARGET=centos0
RELEASE=centos64
VENDOR_URL="https://raw.github.com/tukiyo/vagrant-lxc_create_box/master/vendor"

if [ "$USER" != "root" ];then
    echo "[quit] please execute by root user."
    exit 0
fi

# ----------------------------------------------------------------------

## Bootstrapping the guest container rootfs
apt-get install -qq lxc curl yum -y --force-yes
sudo wget -q -O /usr/share/lxc/templates/lxc-centos https://gist.github.com/hagix9/3514296/raw/7f6bb4e291fad1dad59a49a5c02f78642bb99a45/lxc-centos
sudo chmod 755 /usr/share/lxc/templates/lxc-centos
sudo MIRROR=http://ftp.jaist.ac.jp/pub/Linux/CentOS/6.4/os/x86_64/ lxc-create -t centos -n centos0

## Configure the vagrant user
chroot ${ROOTFS} useradd --create-home -s /bin/bash vagrant
echo -n 'vagrant:vagrant' | chroot ${ROOTFS} chpasswd
mkdir ${ROOTFS}/home/vagrant/.ssh
wget -q https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
    -O ${ROOTFS}/home/vagrant/.ssh/authorized_keys
chroot ${ROOTFS} chown -R vagrant:vagrant /home/vagrant

## Set up SSH access and passwordless sudo
cp -p ${ROOTFS}/etc/sudoers ${ROOTFS}/etc/sudoers.orig
sed -i -e \
      's/^# \(%wheel.*NOPASSWD\)/\1/g' \
      ${ROOTFS}/etc/sudoers

### Add some basic packages
PACKAGES="curl wget"
chroot ${ROOTFS} yum install $PACKAGES -y -q

### install Chef
#chroot ${ROOTFS} curl -L https://www.opscode.com/chef/install.sh -k \
#chroot ${ROOTFS} curl -L $VENDOR_URL/www.opscode.com/chef/install.sh -k \
#      | bash


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
