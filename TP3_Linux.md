# TP 3

## Analyse du service



🌞 S'assurer que le service sshd est démarré

```bash
    systemctl status
    ● localhost.localdomain
        State: running
        Units: 283 loaded (incl. loaded aliases)
        Jobs: 0 queued
    Failed: 0 units
        Since: Mon 2024-01-29 10:30:42 CET; 15min ago
    systemd: 252-13.el9_2
    CGroup: /
            ├─init.scope
            │ └─1 /usr/lib/systemd/systemd --switched-root --system --deserialize 31
            ├─system.slice
            │ ├─NetworkManager.service
            │ │ └─1351 /usr/sbin/NetworkManager --no-daemon
            │ ├─auditd.service
            │ │ └─635 /sbin/auditd
            │ ├─chronyd.service
            │ │ └─671 /usr/sbin/chronyd -F 2
            │ ├─crond.service
            │ │ └─687 /usr/sbin/crond -n
            │ ├─dbus-broker.service
            │ │ ├─673 /usr/bin/dbus-broker-launch --scope system --audit
            │ │ └─675 dbus-broker --log 4 --controller 9 --machine-id 3a1b168db5724933a78856a88a8f18db --max-bytes 53687>
            │ ├─firewalld.service
            │ │ └─664 /usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
            │ ├─rsyslog.service
            │ │ └─665 /usr/sbin/rsyslogd -n
            │ ├─sshd.service
            │ │ └─683 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
            │ ├─systemd-journald.service
```
🌞 Analyser les processus liés au service SSH
```bash
[hugo@localhost ~]$ ps -ef | grep ssh
root         683       1  0 10:30 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1425     683  0 10:39 ?        00:00:00 sshd: hugo [priv]
hugo        1428    1425  0 10:39 ?        00:00:00 sshd: hugo@pts/0
hugo        1462    1429  0 10:56 pts/0    00:00:00 grep --color=auto ssh
```



🌞 Déterminer le port sur lequel écoute le service SSH

```bash
    [hugo@localhost ~]$ ss -atnl
    State         Recv-Q        Send-Q               Local Address:Port               Peer Address:Port       Process
    LISTEN        0             128                        0.0.0.0:22                      0.0.0.0:*
    LISTEN        0             128                           [::]:22                         [::]:*
```
le service ssh écoute sur le port 128

🌞 Consulter les logs du service SSH

```bash
    [hugo@localhost ~]$ journalctl -xe -u sshd
    Jan 29 11:05:10 localhost systemd[1]: Starting OpenSSH server daemon...
    ░░ Subject: A start job for unit sshd.service has begun execution
    ░░ Defined-By: systemd
    ░░ Support: https://access.redhat.com/support
    ░░
    ░░ A start job for unit sshd.service has begun execution.
    ░░
    ░░ The job identifier is 225.
    Jan 29 11:05:10 localhost sshd[682]: main: sshd: ssh-rsa algorithm is disabled
    Jan 29 11:05:10 localhost sshd[682]: Server listening on 0.0.0.0 port 22.
    Jan 29 11:05:10 localhost sshd[682]: Server listening on :: port 22.
    Jan 29 11:05:10 localhost systemd[1]: Started OpenSSH server daemon.
    ░░ Subject: A start job for unit sshd.service has finished successfully
    ░░ Defined-By: systemd
    ░░ Support: https://access.redhat.com/support
    ░░
    ░░ A start job for unit sshd.service has finished successfully.
    ░░
    ░░ The job identifier is 225.
    Jan 29 11:14:09 localhost.localdomain sshd[1332]: main: sshd: ssh-rsa algorithm is disabled
    Jan 29 11:14:09 localhost.localdomain sshd[1332]: Accepted publickey for hugo from 10.2.1.1 port 50679 ssh2: RSA SHA256:PC48DLaj+9>
    Jan 29 11:14:09 localhost.localdomain sshd[1332]: pam_unix(sshd:session): session opened for user hugo(uid=1000) by (uid=0)
```
```bash
[hugo@localhost log]$ sudo cat secure | tail -n 10
Jan 29 11:43:33 localhost sudo[1393]: pam_unix(sudo:session): session closed for user root
Jan 29 11:46:25 localhost sudo[1421]:    hugo : TTY=pts/0 ; PWD=/etc ; USER=root ; COMMAND=/bin/cat ssh
Jan 29 11:46:25 localhost sudo[1421]: pam_unix(sudo:session): session opened for user root(uid=0) by hugo(uid=1000)
Jan 29 11:46:25 localhost sudo[1421]: pam_unix(sudo:session): session closed for user root
Jan 29 11:47:17 localhost sudo[1430]:    hugo : TTY=pts/0 ; PWD=/etc ; USER=root ; COMMAND=/bin/cat ssh
Jan 29 11:47:17 localhost sudo[1430]: pam_unix(sudo:session): session opened for user root(uid=0) by hugo(uid=1000)
Jan 29 11:47:17 localhost sudo[1430]: pam_unix(sudo:session): session closed for user root
Jan 29 11:51:03 localhost sudo[1435]:    hugo : TTY=pts/0 ; PWD=/var ; USER=root ; COMMAND=/bin/cat secure
Jan 29 11:51:03 localhost sudo[1435]: pam_unix(sudo:session): session opened for user root(uid=0) by hugo(uid=1000)
Jan 29 11:51:03 localhost sudo[1435]: pam_unix(sudo:session): session closed for user root
```
 
## 2. Modification du service

🌞 Identifier le fichier de configuration duserveur SSH

```bash
[hugo@localhost /]$ sudo cat /etc/ssh/sshd_config
```

🌞 Modifier le fichier de conf

```
[hugo@localhost /]$ echo $RANDOM
5406
```

```bash
[hugo@localhost ~]$ sudo cat /etc/ssh/sshd_config | grep Port
#Port 5406
#GatewayPorts no
```
```bash
[hugo@localhost ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
Warning: NOT_ENABLED: 80:tcp
success
[hugo@localhost ~]$ sudo firewall-cmd --reload
success
[hugo@localhost ~]$ ^C
[hugo@localhost ~]$ sudo firewall-cmd --add-port=5406/tcp --permanent
success
[hugo@localhost ~]$ sudo firewall-cmd --reload
success
```

```bash
[hugo@localhost ~]$ sudo firewall-cmd --list-all | grep port
  ports: 5406/tcp
  forward-ports:
  source-ports:
```

```
[hugo@localhost ~]$ sudo systemctl restart sshd
```

## II. Service HTTP

## 1. Mise en place


🌞 Installer le serveur NGINX

```bash
sudo dnf search nginx
```

```bash
sudo dnf install nginx
```

🌞 Démarrer le service NGINX

```bash
[hugo@localhost ~]$ sudo systemctl start nginx
[hugo@localhost ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; preset: disabled)
     Active: active (running) since Tue 2024-01-30 10:33:11 CET; 1s ago
    Process: 11275 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 11276 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 11277 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 11278 (nginx)
      Tasks: 2 (limit: 4673)
     Memory: 1.9M
        CPU: 25ms
     CGroup: /system.slice/nginx.service
```
🌞 Déterminer sur quel port tourne NGINX

```bash
Jan 30 10:33:11 localhost.localdomain systemd[1]: Started The nginx HTTP and reverse proxy server.
[hugo@localhost ~]$ sudo ss -anlnpt | grep nginx
[sudo] password for hugo:
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=11279,fd=6),("nginx",pid=11278,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=11279,fd=7),("nginx",pid=11278,fd=7))
```

🌞 Déterminer les processus liés au service NGINX

```bash
[hugo@localhost ~]$ ps -ef | grep nginx
root       11278       1  0 10:33 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx      11279   11278  0 10:33 ?        00:00:00 nginx: worker process
hugo       11313    1327  0 11:00 pts/0    00:00:00 grep --color=auto nginx
```

🌞 Déterminer le nom de l'utilisateur qui lance NGINX

```bash
[hugo@localhost ~]$ cat /etc/passwd | grep root
root:x:0:0:root:/root:/bin/bash
operator:x:11:0:operator:/root:/sbin/nologin
``` 

🌞 Test !

```bash
[hugo@localhost ~]$ curl http://10.2.1.11:80 | head -n 7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
100  7620  100  7620    0     0  1860k      0 --:--:-- --:--:-- --:--:-- 1860k
```

## 2. Analyser la conf de NGINX

🌞 Déterminer le path du fichier de configuration de NGINX

```bash
[hugo@localhost /]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2334 Oct 16 20:00 /etc/nginx/nginx.conf
```

🌞 Trouver dans le fichier de conf

```bash
[hugo@localhost ~]$ cat /etc/nginx/nginx.conf | grep "server {" -A 25
    server {
        listen       80;
        listen       [::]:80;
        servername  ;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
```


```bash
[hugo@localhost nginx]$ cat nginx.conf | grep include
include /usr/share/nginx/modules/*.conf;
```

## 3. Déployer un nouveau site web

🌞 Créer un site web

```bash
[hugo@localhost var]$ sudo mkdir www
[sudo] password for hugo:
[hugo@localhost var]$ cd www
[hugo@localhost www]$ sudo mkdir tp3_linux
[hugo@localhost www]$ cd tp3_linux/
[hugo@localhost tp3_linux]$ sudo nano index.html
[hugo@localhost tp3_linux]$
```
🌞 Gérer les permissions