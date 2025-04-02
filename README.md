# Домашнее задание к занятию "`Защита хоста`" - `Хасаншин Марат`

### Задание 1

1. Установите **eCryptfs**.
2. Добавьте пользователя cryptouser.
3. Зашифруйте домашний каталог пользователя с помощью eCryptfs.


*В качестве ответа  пришлите снимки экрана домашнего каталога пользователя с исходными и зашифрованными данными.*  


Установка eCryptfs 

```sh
sudo apt install ecryptfs-utils
```
Создание пользователя cryptouser

```sh
adduser --encrypt-home   cryptouser
```
Вывод
```sh
Adding user `cryptouser' ...
Adding new group `cryptouser' (1001) ...
Adding new user `cryptouser' (1001) with group `cryptouser' ...
Creating home directory `/home/cryptouser' ...
Setting up encryption ...

************************************************************************
YOU SHOULD RECORD YOUR MOUNT PASSPHRASE AND STORE IT IN A SAFE LOCATION.
  ecryptfs-unwrap-passphrase ~/.ecryptfs/wrapped-passphrase
THIS WILL BE REQUIRED IF YOU NEED TO RECOVER YOUR DATA AT A LATER TIME.
************************************************************************


Done configuring.

Copying files from `/etc/skel' ...
New password:
Retype new password:
passwd: password updated successfully
Changing the user information for cryptouser
Enter the new value, or press ENTER for the default
        Full Name []: Denis
        Room Number []:
        Work Phone []:
        Home Phone []:
        Other []:
Is the information correct? [Y/n] Y
```
Проверка

```sh

root@ubuntu22-client:~# su cryptouser
Signature not found in user keyring
Perhaps try the interactive 'ecryptfs-mount-private'
cryptouser@ubuntu22-client:/root$ ecryptfs-mount-private
Enter your login passphrase:
Inserted auth tok with sig [4a7b4a15dfe61cac] into the user session keyring
cryptouser@ubuntu22-client:/root$ cd
cryptouser@ubuntu22-client:~$ touch test_file.txt
cryptouser@ubuntu22-client:~$ ls -la
total 88
drwx------ 2 cryptouser cryptouser 4096 Apr 01 14:41 .
drwxr-xr-x 5 root       root       4096 Apr 01 14:33 ..
-rw-rw-r-- 1 cryptouser cryptouser    0 Apr 01 14:35 123
-rw-rw-r-- 1 cryptouser cryptouser    0 Apr 01 14:35 345,
-rw-r--r-- 1 cryptouser cryptouser  220 Apr 01 14:33 .bash_logout
-rw-r--r-- 1 cryptouser cryptouser 3771 Apr 01 14:33 .bashrc
lrwxrwxrwx 1 cryptouser cryptouser   36 Apr 01 14:33 .ecryptfs -> /home/.ecryptfs/cryptouser/.ecryptfs
lrwxrwxrwx 1 cryptouser cryptouser   35 Apr 01 14:33 .Private -> /home/.ecryptfs/cryptouser/.Private
-rw-r--r-- 1 cryptouser cryptouser  807 Apr 01 14:33 .profile
-rw-rw-r-- 1 cryptouser cryptouser    0 Apr 01 14:41 test_file.txt
-rw-rw-r-- 1 cryptouser cryptouser    4 Apr 01 14:37 test.txt
cryptouser@ubuntu22-client:~$ pwd
/home/cryptouser
cryptouser@ubuntu22-client:~$ exit
exit
root@ubuntu22-client:~# ls -la /home/cryptouser/
total 8
dr-x------ 2 cryptouser cryptouser 4096 Apr 01 14:33 .
drwxr-xr-x 5 root       root       4096 Apr 01 14:33 ..
lrwxrwxrwx 1 cryptouser cryptouser   56 Apr 01 14:33 Access-Your-Private-Data.desktop -> /usr/share/ecryptfs-utils/ecryptfs-mount-private.desktop
lrwxrwxrwx 1 cryptouser cryptouser   36 Apr 01 14:33 .ecryptfs -> /home/.ecryptfs/cryptouser/.ecryptfs
lrwxrwxrwx 1 cryptouser cryptouser   35 Apr 01 14:33 .Private -> /home/.ecryptfs/cryptouser/.Private
lrwxrwxrwx 1 cryptouser cryptouser   52 Apr 01 14:33 README.txt -> /usr/share/ecryptfs-utils/ecryptfs-mount-private.txt
```


### Задание 2

1. Установите поддержку **LUKS**.
2. Создайте небольшой раздел, например, 100 Мб.
3. Зашифруйте созданный раздел с помощью LUKS.

*В качестве ответа пришлите снимки экрана с поэтапным выполнением задания.*

### Решение Задание 2

Устанавливаем gparted cryptsetup (LUKS)

```sh
apt install gparted cryptsetup
```
Проверка

```sh
root@ubuntu22-client:~# cryptsetup --version
cryptsetup 2.4.3
```
В esxi добавляем доп. диск размер (100 МБ)

```sh
echo "- - -" | tee /sys/class/scsi_host/host*/scan
```

Проверка

```
fdisk -l
Disk /dev/sdb: 100 MiB, 104857600 bytes, 204800 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```
Подготавливаем раздел (тип luks2)

```sh
cryptsetup -y -v --type luks2 luksFormat /dev/sdb
```

Вывод
```sh
root@ubuntu22-client:~# cryptsetup -y -v --type luks2 luksFormat /dev/sdb
WARNING: Device /dev/sdb already contains a 'ext4' superblock signature.

WARNING!
========
This will overwrite data on /dev/sdb irrevocably.

Are you sure? (Type 'yes' in capital letters): YES
Enter passphrase for /dev/sdb:
Verify passphrase:
Existing 'ext4' superblock signature on device /dev/sdb will be wiped.

Key slot 0 created.
Command successful.
```

Открываем устройство /dev/sdb и задаем ему имя cryptodisk

```sh
sudo cryptsetup luksOpen /dev/sdb cryptodisk
```
Проверяем

```sh
root@ubuntu22-client:~# ls -al /dev/mapper/cryptodisk
lrwxrwxrwx 1 root root 7 Apr 01 20:53 /dev/mapper/cryptodisk -> ../dm-1
```

Форматируем раздел

```sh
sudo dd if=/dev/zero of=/dev/mapper/cryptodisk
sudo mkfs.ext4 /dev/mapper/cryptodisk
```

Вывод

```sh
root@ubuntu22-client:~# sudo dd if=/dev/zero of=/dev/mapper/cryptodisk
dd: writing to '/dev/mapper/cryptodisk': No space left on device
172033+0 records in
172032+0 records out
88080384 bytes (88 MB, 84 MiB) copied, 1.76524 s, 49.9 MB/s
root@ubuntu22-client:~# sudo mkfs.ext4 /dev/mapper/cryptodisk
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 21504 4k blocks and 21504 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

Монтируем открытый раздел

```sh
mkdir .secret
sudo mount /dev/mapper/cryptodisk .secret/
```


Завершение работы

```sh
sudo umount .secret
sudo cryptsetup luksClose cryptodisk
```


## Дополнительные задания (со звёздочкой*)

Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале

```sh
sudo apt install gparted
apt install cryptsetup
root@ubuntu22-client:~# cryptsetup --version
cryptsetup 2.4.3

```


### Задание 3 *

1. Установите **apparmor**.
2. Повторите эксперимент, указанный в лекции.
3. Отключите (удалите) apparmor.


*В качестве ответа пришлите снимки экрана с поэтапным выполнением задания.*

### Решение Задание 3 *

Установка AppArmor

```sh
sudo apt install apparmor-profiles apparmor-utils apparmor-profiles-extra
```
Проверяем статус AppArmor

```sh
root@ubuntu22-client:~# sudo apparmor_status
apparmor module is loaded.
66 profiles are loaded.
48 profiles are in enforce mode.
   /snap/snapd/20671/usr/lib/snapd/snap-confine
   /snap/snapd/20671/usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /snap/snapd/21759/usr/lib/snapd/snap-confine
   /snap/snapd/21759/usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /usr/bin/man
   /usr/bin/pidgin
   /usr/bin/pidgin//sanitized_helper
   /usr/bin/totem
   /usr/bin/totem-audio-preview
   /usr/bin/totem-video-thumbnailer
   /usr/bin/totem//sanitized_helper
   /usr/lib/NetworkManager/nm-dhcp-client.action
   /usr/lib/NetworkManager/nm-dhcp-helper
   /usr/lib/connman/scripts/dhclient-script
   /usr/lib/snapd/snap-confine
   /usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /{,usr/}sbin/dhclient
   apt-cacher-ng
   lsb_release
   man_filter
   man_groff
   nvidia_modprobe
   nvidia_modprobe//kmod
   snap-update-ns.lxd
   snap.lxd.activate
   snap.lxd.benchmark
   snap.lxd.buginfo
   snap.lxd.check-kernel
   snap.lxd.daemon
   snap.lxd.hook.configure
   snap.lxd.hook.install
   snap.lxd.hook.remove
   snap.lxd.lxc
   snap.lxd.lxc-to-lxd
   snap.lxd.lxd
   snap.lxd.migrate
   snap.lxd.user-daemon
   tcpdump
   ubuntu_pro_apt_news
   ubuntu_pro_esm_cache
   ubuntu_pro_esm_cache//apt_methods
   ubuntu_pro_esm_cache//apt_methods_gpgv
   ubuntu_pro_esm_cache//cloud_id
   ubuntu_pro_esm_cache//dpkg
   ubuntu_pro_esm_cache//ps
   ubuntu_pro_esm_cache//ubuntu_distro_info
   ubuntu_pro_esm_cache_systemctl
   ubuntu_pro_esm_cache_systemd_detect_virt
18 profiles are in complain mode.
   /usr/bin/irssi
   avahi-daemon
   dnsmasq
   dnsmasq//libvirt_leaseshelper
   identd
   klogd
   mdnsd
   nmbd
   nscd
   php-fpm
   ping
   samba-bgqd
   smbd
   smbldap-useradd
   smbldap-useradd///etc/init.d/nscd
   syslog-ng
   syslogd
   traceroute
0 profiles are in kill mode.
0 profiles are in unconfined mode.
0 processes have profiles defined.
0 processes are in enforce mode.
0 processes are in complain mode.
0 processes are unconfined but have a profile defined.
0 processes are in mixed mode.
0 processes are in kill mode.
```

Проверка

```sh
cp /usr/bin/man /usr/bin/man.orig
cp /bin/ping /usr/bin/man
man ya.ru
```
Вывод

```sh
root@ubuntu22-client:~# man ya.ru
PING ya.ru (77.88.44.242) 56(84) bytes of data.
64 bytes from ya.ru (77.88.44.242): icmp_seq=1 ttl=243 time=4.83 ms
64 bytes from ya.ru (77.88.44.242): icmp_seq=2 ttl=243 time=4.57 ms
64 bytes from ya.ru (77.88.44.242): icmp_seq=3 ttl=243 time=4.61 ms
64 bytes from ya.ru (77.88.44.242): icmp_seq=4 ttl=243 time=4.57 ms
64 bytes from ya.ru (77.88.44.242): icmp_seq=5 ttl=243 time=4.57 ms
^C
--- ya.ru ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4005ms
rtt min/avg/max/mdev = 4.568/4.630/4.831/0.101 ms
```
Включаем режим блокировки

```sh
root@ubuntu22-client:~# sudo aa-complain man
Setting /usr/bin/man to complain mode.
root@ubuntu22-client:~# man ya.ru
PING ya.ru (77.88.55.242) 56(84) bytes of data.
64 bytes from ya.ru (77.88.55.242): icmp_seq=1 ttl=50 time=9.65 ms
64 bytes from ya.ru (77.88.55.242): icmp_seq=2 ttl=50 time=9.36 ms
64 bytes from ya.ru (77.88.55.242): icmp_seq=3 ttl=50 time=9.41 ms
64 bytes from ya.ru (77.88.55.242): icmp_seq=4 ttl=50 time=9.49 ms
64 bytes from ya.ru (77.88.55.242): icmp_seq=5 ttl=50 time=9.45 ms
^C
--- ya.ru ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4006ms
rtt min/avg/max/mdev = 9.361/9.472/9.651/0.099 ms
root@ubuntu22-client:~# sudo aa-enforce man
Setting /usr/bin/man to enforce mode.
root@ubuntu22-client:~# man ya.ru
```

Просмотр профиля приложения ping

```sh
nano /etc/apparmor.d/bin.ping
abi <abi/3.0>,

include <tunables/global>
profile ping /{usr/,}bin/{,iputils-}ping flags=(complain) {
  include <abstractions/base>
  include <abstractions/consoles>
  include <abstractions/nameservice>

  capability net_raw,
  capability setuid,
  network inet raw,
  network inet6 raw,

  /{,usr/}bin/{,iputils-}ping mixr,
  /etc/modules.conf r,

  # Site-specific additions and overrides. See local/README for details.
  include if exists <local/bin.ping>
}
```

Останавливаем службу

```sh
user@user:~$ sudo service apparmor stop
```

Выгружаем профили

```sh
user@user:~$ sudo service apparmor teardown
```
Удаляем apparmor

```sh
apt remove --assume-yes --purge apparmor
```
