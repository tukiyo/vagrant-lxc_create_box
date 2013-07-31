* 最新版のVagrantを[ダウンロード](http://downloads.vagrantup.com)し、インストールを済ませておく。

quick-start (centos 6.4 64bit 最小構成)
====

```bash:準備
$ vagrant plugin install vagrant-lxc
$ sudo apt-get install lxc curl wget
```

```bash:centos64の環境を作りたい場合
$ wget https://www.dropbox.com/s/v8m445x7e3xw19a/vagrant-lxc-centos64.box
$ vagrant init my-centos vagrant-lxc-raring.box
```

```bash:ubuntu13.04の環境を作りたい場合
$ wget https://www.dropbox.com/s/d8k4ugqhlxa8vqr/vagrant-lxc-raring.box
$ vagrant init my-raring vagrant-lxc-raring.box
```

```bash:起動
$ vagrant up --provider=lxc   (/var/lib/lxc/vagrant-xxxx が作成されます。)
$ vagrant ssh
```


独自のboxを作成する方法
====
[GitHub](https://github.com/tukiyo/vagrant-lxc_create_box.git)に上げました。参考にしてください。

例）centos6.4を作成する場合
----

```bash:
$ sudo cp -p lxc-templates/lxc-centos-vagrant /usr/share/lxc/templates/
$ cd centos
$ sudo sh 1-bootstrap.sh
```

例）ubuntu 13.04 を作成する場合
----

```bash:
$ sudo cp -p lxc-templates/lxc-ubuntu-vagrant /usr/share/lxc/templates/
$ cd ubuntu
$ sudo sh 1-bootstrap.sh
```

vagrantの長所
====

* /vagrant/ の同期

メモリはたったの20MBしか使わない
----

```Bash:
$ free -m
             total       used       free     shared    buffers     cached
Mem:          7734       5603       2130          0        310       3445
-/+ buffers/cache:       1847       5886
Swap:         3867          0       3867
$ vagrant up
Bringing machine 'default' up with 'lxc' provider...
[default] Setting up mount entries for shared folders...
[default] -- /vagrant
[default] Starting container...
[default] Waiting for container to start. This should not take long.
[default] Container started and ready for use!
$ free -m
             total       used       free     shared    buffers     cached
Mem:          7734       5623       2110          0        310       3446
-/+ buffers/cache:       1867       5867
Swap:         3867          0       3867
$ vagrant halt default
[default] Attempting graceful shutdown of VM...
$ free -m
             total       used       free     shared    buffers     cached
Mem:          7734       5603       2130          0        310       3445
-/+ buffers/cache:       1847       5886
Swap:         3867          0       3867
```
