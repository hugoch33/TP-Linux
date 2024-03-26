# TP 5

## Partie 1 : Script carte d'identité

🌞 Vous fournirez dans le compte-rendu Markdown, en plus du fichier, un exemple d'exécution avec une sortie

```bash
[hugo@tp5 idcard]$ ./idcard.sh 
Machine Name : tp5
OS Rocky Linux and kernel version is 5.14.0-284.11.1.el9_2.x86_64
IP : 10.5.1.100/24
RAM : 285Mi memory available on 771Mi total memory
Disk : 16G space left
Top 5 processes by RAM usage :
     - Le processus 1410 utilise 11     .5% de la RAM
     - Le processus 1626 utilise 11.9% de la RAM
     - Le processus 1515 utilise 9.5% de la RAM
     - Le processus 1637 utilise 7.2% de la RAM
     - Le processus 660 utilise 5.3% de la RAM
Listening ports :
     - 323 udp : chronyd
     - 22 tcp : sshd
PATH directories :
     - /home/hugo/.vscode-server/bin/903b1e9d8990623e3d7da1df3d33db3e42d80eda/bin/remote-cli
     - /home/hugo/.local/bin
     - /home/hugo/bin
     - /usr/local/bin
     - /usr/bin
     - /usr/local/sbin
     - /usr/sbin
 
Here is your random cat (jpg file) https://th.bing.com/th/id/OIP.IbhnBcBXK5wyahXWCgklRQHaJ4?rs=1&pid=ImgDetMain
```
# II. Script youtube-dl
## 1. Premier script youtube-dl

### A. Le principe

### B. Rendu attendu
🌞 Vous fournirez dans le compte-rendu, en plus du fichier, **un exemple d'exécution avec une sortie**
```bash
[hugo@tp5 yt]$ sudo -u yt ./yt.sh 'https://www.youtube.com/watch?v=Hc62oxU1BIY'
La vidéo est déjà téléchargée
[youtube] kQeBeCmNIvU: Downloading webpage
[download] Destination: download/Kazuya_DORYA_Fest/Kazuya_DORYA_Fest.mp4
[download] 100% of 1.62MiB in 00:01
Video : https://www.youtube.com/watch?v=Hc62oxU1BIY
Path  : /chemin/vers/le/dossier/download/Kazuya_DORYA_Fest/Kazuya_DORYA_Fest.mp4
```
## 2. MAKE IT A SERVICE

### A. Adaptation du script
### C. Rendu

🌞 Vous fournirez dans le compte-rendu, en plus des fichiers :

- un `systemctl status yt` quand le service est en cours de fonctionnement
```bash
[hugo@tp5 yt]$ sudo systemctl status yt
● yt.service - Youtube Video Downloader
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; preset: disabled)
     Active: active (running) since Tue 2024-03-05 14:51:22 CET; 6min 46s ago
   Main PID: 10920 (yt-v2.sh)
      Tasks: 2 (limit: 4673)
     Memory: 6.1M
        CPU: 1min 42.128s
     CGroup: /system.slice/yt.service
             ├─10920 /bin/bash /srv/yt/yt-v2.sh
             └─11040 sleep 1


Mar 05 14:56:28  storage yt-v2.sh[10943]: [youtube] CySAWSIAsNY: Downloading webpage
Mar 05 14:56:39  storage yt-v2.sh[10943]: [download] Destination: /srv/yt/download/Kazuya_DORYA_Fest/Kazuya_DORYA_Fest.mp4
Mar 05 14:56:40 storage yt-v2.sh[10943]: [677B blob data]
Mar 05 14:56:55  storage yt-v2.sh[10920]: Video : https://www.youtube.com/watch?v=Hc62oxU1BIY
Mar 05 14:57:03  storage yt-v2.sh[10920]: Path  : /srv/yt/download/Kazuya_DORYA_Fest/Kazuya_DORYA_Fest.mp4
```

🌞 Le journalctl :

```bash
Mar 05 14:57:03 storage systemd[1]: Started Youtube Video Downloader.
░░ Subject: A start job for unit yt.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit yt.service has finished successfully.
░░
░░ The job identifier is 3887.
Mar 05 14:57:18 storage yt-v2.sh[10920]: La vidéo est déjà téléchargée
Mar 05 14:57:48 storage yt-v2.sh[10943]: [youtube] Hc62oxU1BIY: Downloading webpage
Mar 05 14:58:06 storage yt-v2.sh[10943]: [download] Destination: /srv/yt/download/Kazuya_DORYA_Fest/Kazuya_DORYA_Fest.mp4
Mar 05 14:58:07 storage yt-v2.sh[10943]: [680B blob data]
Mar 05 14:58:29 storage yt-v2.sh[10920]: Video : https://www.youtube.com/watch?v=Hc62oxU1BIY
Mar 05 14:58:29 storage yt-v2.sh[10920]: Path : /srv/yt/download/Kazuya_DORYA_Fest/Kazuya_DORYA_Fest.mp4
```