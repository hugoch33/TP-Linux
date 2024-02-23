# TP 4 :

## Partie 1 : Partitionnement du serveur de stockage

🌞 Partitionner le disque à l'aide de LVM

```bash
[hugo@localhost ~]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda           8:0    0    8G  0 disk
├─sda1        8:1    0    1G  0 part /boot
└─sda2        8:2    0    7G  0 part
  ├─rl-root 253:0    0  6.2G  0 lvm  /
  └─rl-swap 253:1    0  820M  0 lvm  [SWAP]
sdb           8:16   0    2G  0 disk
sdc           8:32   0    2G  0 disk
sr0          11:0    1 1024M  0 rom
```

```bash
    [hugo@localhost ~]$ sudo pvcreate /dev/sdb
    [sudo] password for hugo:
    Physical volume "/dev/sdb" successfully created.
    [hugo@localhost ~]$ sudo pvcreate /dev/sdc
    Physical volume "/dev/sdc" successfully created.
    [hugo@localhost ~]$ sudo vgcreate storage /dev/sdb
    *  Volume group "storage" successfully created
    [hugo@localhost ~]$ sudo vgs
    Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VBab785dd2-ec1cafb1 PVID NccRMmnjqP4wqaxxunFlfEC0gKDl2tLi last seen on /dev/sda2 not found.
    VG      #PV #LV #SN Attr   VSize  VFree
    storage   1   0   0 wz--n- <2.00g <2.00g
```

```bash
    [hugo@localhost ~]$ sudo vgextend storage /dev/sdc
    Volume group "storage" successfully extended
    [hugo@localhost ~]$ sudo vgs
    Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VBab785dd2-ec1cafb1 PVID NccRMmnjqP4wqaxxunFlfEC0gKDl2tLi last seen on /dev/sda2 not found.
    VG      #PV #LV #SN Attr   VSize VFree
    storage   2   0   0 wz--n- 3.99g 3.99g
    [hugo@localhost ~]$ sudo lvcreate -l 100%FREE storage -n last_data
    Logical volume "last_data" created.
        [hugo@localhost ~]$ sudo lvs
    Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VBab785dd2-ec1cafb1 PVID NccRMmnjqP4wqaxxunFlfEC0gKDl2tLi last seen on /dev/sda2 not found.
    LV        VG      Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
    last_data storage -wi-a----- 3.99g
```

🌞 Formater la partition

```bash
    [hugo@localhost ~]$ sudo mkfs -t ext4 /dev/storage/last_data
    [sudo] password for hugo:
    mke2fs 1.46.5 (30-Dec-2021)
    Creating filesystem with 1046528 4k blocks and 261632 inodes
    Filesystem UUID: 2897d007-79f3-4538-9e37-ca26b41a2b95
    Superblock backups stored on blocks:
            32768, 98304, 163840, 229376, 294912, 819200, 884736

    Allocating group tables: done
    Writing inode tables: done
    Creating journal (16384 blocks): done
    Writing superblocks and filesystem accounting information: done
```

🌞 Monter la partition

```bash
 [hugo@localhost ~]$ sudo mkdir /mnt/data1
    [hugo@localhost ~]$ sudo mount /dev/storage/last_data /mnt/data1
    [hugo@localhost ~]$ df -h
    Filesystem                     Size  Used Avail Use% Mounted on
    devtmpfs                       4.0M     0  4.0M   0% /dev
    tmpfs                          386M     0  386M   0% /dev/shm
    tmpfs                          155M  3.7M  151M   3% /run
    /dev/mapper/rl-root            6.2G  1.2G  5.1G  20% /
    /dev/sda1                     1014M  220M  795M  22% /boot
    tmpfs                           78M     0   78M   0% /run/user/1000
    /dev/mapper/storage-last_data  3.9G   24K  3.7G   1% /mnt/data1
```

```bash
    /dev/mapper/storage-last_data  3.9G   24K  3.7G   1% /mnt/data1
```

```bash
    [hugo@localhost ~]$ sudo nano /etc/fstab
    [sudo] password for hugo:
    [hugo@localhost ~]$ sudo umount /mnt/data1
    [hugo@localhost ~]$ sudo mount -av
    /                        : ignored
    /boot                    : already mounted
    none                     : ignored
    mount: /mnt/data1 does not contain SELinux labels.
        You just mounted a file system that supports labels which does not
        contain labels, onto an SELinux box. It is likely that confined
        applications will generate AVC messages and not be allowed access to
        this file system.  For more details see restorecon(8) and mount(8).
    mount: (hint) your fstab has been modified, but systemd still uses
        the old version; use 'systemctl daemon-reload' to reload.
    /mnt/data1               : successfully mounted
```

## Partie 2 : Serveur de partage de fichiers

🌞 Donnez les commandes réalisées sur le serveur NFS storage.tp4.linux

```bash
[hugo@storage ~]$ sudo dnf install nfs-utils

[hugo@storage storage]$ sudo mkdir site_web_1
[hugo@storage storage]$ sudo mkdir site_web_2

[hugo@storage storage]$ sudo nano /etc/exports

[hugo@storage storage]$ sudo systemctl enable nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
[hugo@storage storage]$ sudo systemctl start nfs-server

[hugo@storage storage]$ sudo firewall-cmd --permanent --add-service=nfs
success
[hugo@storage storage]$ sudo firewall-cmd --permanent --add-service=mountd
success
[hugo@storage storage]$ sudo firewall-cmd --permanent --add-service=rpc-bind
success
[hugo@storage storage]$ sudo firewall-cmd --reload
success

[hugo@storage storage]$ sudo firewall-cmd --permanent --list-all | grep services
  services: cockpit dhcpv6-client mountd nfs rpc-bind ssh
```

- contenu du fichier `/etc/exports` dans le compte-rendu notamment

```bash
[hugo@storage site_web_1]$ sudo cat /etc/exports
[sudo] password for hugo:
/dev/storage/site_web_1 10.5.1.101(rw,sync,no_subtree_check)
/dev/storage/site_web_2 10.5.1.101(rw,sync,no_subtree_check)
```

🌞 Donnez les commandes réalisées sur le client NFS web.tp4.linux

```bash
[hugo@web ~]$ sudo dnf install nfs-utils -y

[hugo@web ~]$ sudo mkdir -p /nfs/general
[sudo] password for hugo:
[hugo@web ~]$ sudo mkdir -p /nfs/home

[hugo@web www]$ sudo mkdir site_web_1
[hugo@web www]$ sudo mkdir site_web_2
[hugo@web www]$ sudo mount 10.5.1.102:/dev/storage/site_web_1 /var/www/site_web_1
[hugo@web www]$ sudo mount 10.5.1.102:/dev/storage/site_web_2 /var/www/site_web_2

[hugo@web www]$ df -h | grep 10.5.1.102
10.5.1.102:/dev/storage/site_web_1  4.0M     0  4.0M   0% /var/www/site_web_1
10.5.1.102:/dev/storage/site_web_2  4.0M     0  4.0M   0% /var/www/site_web_2

[hugo@web site_web_1]$ sudo touch test
[hugo@web site_web_1]$ sudo nano test
[hugo@web site_web_1]$ cat test
test 1 2 3 4 5 6 7 8 9

[hugo@web site_web_1]$ sudo nano /etc/fstab
```

- contenu du fichier `/etc/fstab` dans le compte-rendu notamment

```bash
[hugo@web site_web_1]$ cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Mon Oct 23 09:14:19 2023
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=c07c37d6-37d3-497c-8c28-b3f3b1966d11 /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0
10.5.1.102:/dev/storage/site_web_1 /var/www/site_web_1 nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
10.5.1.102:/dev/storage/site_web_1 /var/www/site_web_1 nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```

## Partie 3 : Serveur web

🌞 Installez NGINX

```bash
[hugo@web site_web_1]$ sudo dnf install nginx -y
```

```bash
[hugo@web /]$ ps -ef | grep nginx
root        4608       1  0 12:06 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       4609    4608  0 12:06 ?        00:00:00 nginx: worker process
hugo        4618    4228  0 12:08 pts/0    00:00:00 grep --color=auto nginx
```

```bash
[hugo@web /]$ sudo ss -alnpt | grep nginx
LISTEN 0      511          0.0.0.0:80         0.0.0.0:*    users:(("nginx",pid=4609,fd=6),("nginx",pid=4608,fd=6))
LISTEN 0      511             [::]:80            [::]:*    users:(("nginx",pid=4609,fd=7),("nginx",pid=4608,fd=7))
```

```bash
[hugo@web nginx]$ sudo cat nginx.conf | grep root
[sudo] password for hugo:
        root         /usr/share/nginx/html;
#        root         /usr/share/nginx/html;
```

```bash

[hugo@web html]$ ls -al
total 12
drwxr-xr-x. 3 root root  143 Feb 20 12:05 .
drwxr-xr-x. 4 root root   33 Feb 20 12:05 ..
-rw-r--r--. 1 root root 3332 Oct 16 19:58 404.html
-rw-r--r--. 1 root root 3404 Oct 16 19:58 50x.html
drwxr-xr-x. 2 root root   27 Feb 20 12:05 icons
lrwxrwxrwx. 1 root root   25 Oct 16 20:00 index.html -> ../../testpage/index.html
-rw-r--r--. 1 root root  368 Oct 16 19:58 nginx-logo.png
lrwxrwxrwx. 1 root root   14 Oct 16 20:00 poweredby.png -> nginx-logo.png
lrwxrwxrwx. 1 root root   37 Oct 16 20:00 system_noindex_logo.png -> ../../p
```

🌞 Configurez le firewall pour autoriser le trafic vers le service NGINX

```bash
    [hugo@web /]$ sudo firewall-cmd --add-port=80/tcp --permanent
    success
    [hugo@web /]$ sudo firewall-cmd --reload
    success
```

🌞 Accéder au site web

```bash
[hugo@web /]$ curl 10.2.1.11:80 | head -n 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
100  7620  100  7620    0     0   620k      0 --:--:-- --:--:-- --:--:--  620k
curl: (23) Failed writing body
```

🌞 Vérifier les logs d'accès

```bash
[hugo@web nginx]$ sudo cat access.log | tail -3
10.5.1.1 - - [20/Feb/2024:10:49:23 +0100] "GET /icons/poweredby.png HTTP/1.1" 200 15443 "http://10.5.1.101/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0" "-"
10.5.1.1 - - [20/Feb/2024:10:49:23 +0100] "GET /poweredby.png HTTP/1.1" 200 368 "http://10.5.1.101/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0" "-"
10.5.1.1 - - [20/Feb/2024:10:49:23 +0100] "GET /favicon.ico HTTP/1.1" 404 3332 "http://10.5.1.101/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0" "-"
```
