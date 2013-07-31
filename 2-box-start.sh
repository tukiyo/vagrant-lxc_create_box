if [ "$USER" = "root" ];then
    echo "[quit] please execute by normal user."
    exit 0
fi

RELEASE=raring

mkdir -p ~/local/vagrant/${RELEASE} && cd ~/local/vagrant/${RELEASE}
vagrant init my-box $HOME/vagrant-lxc-${RELEASE}.box
vagrant up --provider=lxc
vagrant ssh
