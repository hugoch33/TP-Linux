# TP1 : Casser avant de construire

## II. Casser

### 2. Fichier

🌞 **Supprimer des fichiers**


    [hugo@localhost ~]$ rm /boot/vmlinuz-5.14.0-284.11.1.el9_2.x86_64
    [hugo@localhost ~]$ rm /boot/vmlinuz-0-rescue-b01d02e8bcee45c897afaf016cbfc3c5


### 3. Utilisateurs

🌞 **Mots de passe**

    [hugo@localhost /]$ sudo awk -F: '/\/home/ && !/nologin/ {print $1}' /etc/passwd | xargs -I {} sudo sh -c 'echo "{}:nouveaumdp" |chpasswd'

🌞 **Another way ?**

    [hugo@localhost ~]$ sudo awk -F: '{print $1}' /etc/passwd | xargs -I {} sudo usermod -L {}

## 4. Disques

🌞 **Effacer le contenu du disque dur**

    [hugo@localhost ~]$ sudo dd if=/dev/zero of=/dev/sda1 bs=4M status=progress
