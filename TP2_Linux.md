# TP2 : 

# Partie : Files and users

## I. Fichiers

### 1. Find me
🌞 Trouver le chemin vers le répertoire personnel de votre utilisateur

```
[hugo@localhost ~]$ cd /home/hugo/
```

🌞 Trouver le chemin du fichier de logs SSH

```
[hugo@localhost /]$ cd /var/
[hugo@localhost log]$ sudo nano secure

    GNU nano 5.6.1                                            secure                                                      Oct 23 11:24:34 localhost sshd[810]: Server listening on 0.0.0.0 port 22.
    Oct 23 11:24:34 localhost sshd[810]: Server listening on :: port 22.
    Oct 23 11:24:56 localhost systemd[818]: pam_unix(systemd-user:session): session opened for user hugo(uid=1000) by (uid=>Oct 23 11:24:56 localhost login[716]: pam_unix(login:session): session opened for user hugo(uid=1000) by LOGIN(uid=0)
    Oct 23 11:24:56 localhost login[716]: LOGIN ON tty1 BY hugo
    Oct 23 11:29:07 localhost unix_chkpwd[4301]: password check failed for user (hugo)
    Oct 23 11:29:07 localhost sudo[4299]: pam_unix(sudo:auth): authentication failure; logname=hugo uid=1000 euid=0 tty=/de>Oct 23 11:29:13 localhost sudo[4299]:    hugo : TTY=tty1 ; PWD=/home/hugo ; USER=root ; COMMAND=/sbin/setenforce 0
    Oct 23 11:29:13 localhost sudo[4299]: pam_unix(sudo:session): session opened for user root(uid=0) by hugo(uid=1000)
    Oct 23 11:29:14 localhost sudo[4299]: pam_unix(sudo:session): session closed for user root
    Oct 23 11:30:26 localhost sudo[4312]:    hugo : TTY=tty1 ; PWD=/home/hugo ; USER=root ; COMMAND=/bin/dnf install -y nanoOct 23 11:30:26 localhost sudo[4312]: pam_unix(sudo:session): session opened for user root(uid=0) by hugo(uid=1000)
    Oct 23 11:31:29 localhost sudo[4312]: pam_unix(sudo:session): session closed for user root
    Oct 23 11:32:32 localhost sudo[13830]:    hugo : TTY=tty1 ; PWD=/home/hugo ; USER=root ; COMMAND=/bin/nano /etc/selinux>Oct 23 11:32:32 localhost sudo[13830]: pam_unix(sudo:session): session opened for user root(uid=0) by hugo(uid=1000)
    Oct 23 11:36:24 localhost sudo[13830]: pam_unix(sudo:session): session closed for user root
    Oct 23 11:41:02 localhost sudo[13841]:    hugo : TTY=tty1 ; PWD=/home/hugo ; USER=root ; COMMAND=/bin/dnf install -y tr>Oct 23 11:41:02 localhost sudo[13841]: pam_unix(sudo:session): session opened for user root(uid=0) by hugo(uid=1000)
    Oct 23 11:41:36 localhost groupadd[13895]: group added to /etc/group: name=tcpdump, GID=72
    Oct 23 11:41:36 localhost groupadd[13895]: group added to /etc/gshadow: name=tcpdump
    Oct 23 11:41:36 localhost groupadd[13895]: new group: name=tcpdump, GID=72
    Oct 23 11:41:36 localhost useradd[13902]: new user: name=tcpdump, UID=72, GID=72, home=/, shell=/sbin/nologin, from=noneOct 23 11:41:40 localhost sudo[13841]: pam_unix(sudo:session): session closed for user root
    Nov 23 09:59:13 localhost sshd[679]: Server listening on 0.0.0.0 port 22.
    Nov 23 09:59:13 localhost sshd[679]: Server listening on :: port 22.
    Nov 23 09:59:25 localhost systemd[1278]: pam_unix(systemd-user:session): session opened for user hugo(uid=1000) by (uid>
```

🌞 Trouver le chemin du fichier de configuration du serveur SSH

```
[hugo@localhost /]$ cd /etc/ssh
[hugo@localhost /]$ sudo nano sshd_config
```


## II. Users

### 1. Nouveau user

🌞 Créer un nouvel utilisateur

```
[hugo@localhost /]$ cd /home
[hugo@localhost home]$ sudo mkdir papier_alu
[hugo@localhost home]$ sudo usermod -d /home/papier_alu marmotte
```

### 2. Infos enregistrées par le système

🌞 Prouver que cet utilisateur a été créé

```
[hugo@localhost etc]$ sudo cat passwd| grep marmotte
[sudo] password for hugo:
marmotte:x:1002:1002::/home/papier_alu:/bin/bash
```

🌞 Déterminer le hash du password de l'utilisateur marmotte

```
[hugo@localhost etc]$ sudo cat shadow | grep marmotte
marmotte:$6$1slNVEUTfVy0H/6a$ieUobN9TqONkMCqxQ/HGKg5L4YFc9XW0rDQcsvSwcOTsqtFb8VkkBe4KAeOy2FaD9uex5uCHg3V/Nt3teKDLG/:19744:0:99999:7:::
```

 ### 3. Hint sur la ligne de commande

🌞 Tapez une commande pour vous déconnecter : fermer votre session utilisateur

```
 [hugo@localhost etc]$ exit
```

🌞 Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur marmotte

```
[root@localhost /]# su - marmotte
Last login: Mon Jan 22 11:17:26 CET 2024 on pts/0
[marmotte@localhost ~]$ cd /home
[marmotte@localhost home]$ cd hugo
-bash: cd: hugo: Permission denied
```

# Partie 2 : Programmes et paquets

## I. Programmes et processus

###  1. Run then kill

🌞 Lancer un processus sleep

```
[root@localhost /]# sleep 1000
[hugo@localhost ~]$ ps -ef | grep sleep
hugo        1801    1782  0 11:38 pts/0    00:00:00 sleep 1000
hugo        1803    1750  0 11:38 pts/1    00:00:00 grep --color=auto sleep
```

🌞 Terminez le processus sleep depuis le deuxième terminal

```
[hugo@localhost ~]$ kill 1801
```

### 2. Tâche de fond

🌞 Lancer un nouveau processus sleep, mais en tâche de fond

```
[hugo@localhost ~]$ sleep 1000 &
[1] 1808
```

🌞 Visualisez la commande en tâche de fond

```
[hugo@localhost ~]$ ps
    PID TTY          TIME CMD
   1386 pts/0    00:00:00 bash
   1782 pts/0    00:00:00 bash
   1808 pts/0    00:00:00 sleep
   1809 pts/0    00:00:00 ps
```

### 3. Find paths

🌞 Trouver le chemin où est stocké le programme sleep

```
[hugo@localhost /]$ sudo find -name sleep
./usr/bin/sleep
```
```
[hugo@localhost /]$ ls -al /usr/bin/sleep | grep sleep
-rwxr-xr-x. 1 root root 36312 Apr 24  2023 /usr/bin/sleep
```

rendu

🌞 Tant qu'on est à chercher des chemins : trouver les chemins vers tous les fichiers qui s'appellent .bashrc

```
[hugo@localhost /]$ sudo find -name .bashrc
./etc/skel/.bashrc
./root/.bashrc
./home/hugo/.bashrc
./home/toto/.bashrc
./home/marmotte/.bashrc
```

### 4. La variable PATH

🌞 Vérifier que

```
[hugo@localhost /]$ echo $PATH
/home/hugo/.local/bin:/home/hugo/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
[hugo@localhost /]$ which sleep
/usr/bin/sleep
[hugo@localhost /]$ which ssh
/usr/bin/ssh
[hugo@localhost /]$ which ping
/usr/bin/ping
```


[hugo@localhost ~]$ sudo dnf install git-all

## II. Paquets

```
[hugo@localhost ~]$ sudo dnf install git-all
  perl-overloading-0.02-480.el9.noarch                      perl-parent-1:0.238-460.el9.noarch
  perl-podlators-1:4.14-460.el9.noarch                      perl-subs-1.03-480.el9.noarch
  perl-vars-1.05-480.el9.noarch                             rocky-logos-httpd-90.14-2.el9.noarch
  subversion-1.14.1-5.el9_0.x86_64                          subversion-libs-1.14.1-5.el9_0.x86_64
  subversion-perl-1.14.1-5.el9_0.x86_64                     tcl-1:8.6.10-7.el9.x86_64
  tk-1:8.6.10-9.el9.x86_64                                  utf8proc-2.6.1-4.el9.x86_64
  xml-common-0.6.3-58.el9.noarch

Complete!
```

🌞 Utiliser une commande pour lancer Firefox

```
[hugo@localhost ~]$ which git
/usr/bin/git
```

🌞 Installer le paquet nginx

```
[hugo@localhost ~]$ sudo dnf install git-all
```

🌞 Déterminer

```
[hugo@localhost /]$ sudo find / -name "nginx*"
/etc/nginx/nginx.conf

[hugo@localhost /]$ cat /etc/nginx/nginx.conf
access_log  /var/log/nginx/access.log  main;
```

🌞 Mais aussi déterminer...



## Partie 3 : Poupée russe

🌞 Récupérer le fichier meow

```
    [hugo@localhost ~]$ wget https://gitlab.com/it4lik/b1-linux-2023/-/raw/master/tp/2/meow?inline=false
```

🌞 Trouver le dossier dawa/

```
[hugo@localhost /]$ file meow
meow: Zip archive data, at least v2.0 to extract
[hugo@localhost /]$ sudo mv meow meow.zip
[hugo@localhost /]$ unzip meow.zip
[hugo@localhost /]$ sudo mv meow meow.bz2
[hugo@localhost /]$ bzip2 -d meow.bz2
[hugo@localhost /]$ bzip2 -d meow.bz2
```