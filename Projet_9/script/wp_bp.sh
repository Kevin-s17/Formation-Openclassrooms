#!/bin/bash
# Script sauvegarde repertoire wordpress + BDD

#Variables
DATE=$(date +%Y-%m-%d-%H:%M)
DESTINATION="/home/kevftp/backups"
user="root"
mdp="kevin123"
[ ! -d $DESTINATION ] && mkdir $DESTINATION && chown 0.0 $DESTINATION && chmod 777 $DESTINATION
cd $DESTINATION

#Sauvegarde mysql
echo kevftp | sudo -S MYSQL_PWD=$mdp mysqldump -u $user wordpress | bzip2 -c > "$DESTINATION"/wp_BDD_"$DATE".sql.bz2

#Creation de l'archive et enregistrement dans le repertoire de destination
cp -R /var/www/html/wordpress $DESTINATION/
cd /home/kevftp
zip -e -P kevftp -r wp_bp_$DATE.zip backups

#Envoyer les fichiers vers serveur de backups
sshpass -p kevftp sftp kevftp@10.0.0.2 << SFTP
cd /opt/ftp
mkdir backups
cd backups
put wp_bp_$DATE.zip
exit
SFTP

#Suppression du repertoire
cd /home/kevftp
rm -rf backups
rm -rf wp_bp_$DATE.zip

#crontab
#20 3	* * *	/home/kevftp/wp_bp.sh
