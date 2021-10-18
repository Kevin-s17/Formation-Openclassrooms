#!/bin/bash
# Script sauvegarde site repertoire www + apache2 + fichier php.ini + scripts

#Variables
DATE=$(date +%Y-%m-%d-%H:%M)
DESTINATION="/home/kevftp/backups"
user="root"
mdp="kevin123"

#Creation du repertoire backups
[ ! -d $DESTINATION ] && mkdir $DESTINATION && chown 0.0 $DESTINATION && chmod 777 $DESTINATION
cd $DESTINATION

#Creation de l'archive et enregistrement dans le repertoire de destination
cp -R /var/www $DESTINATION/
cp -R /etc/apache2 $DESTINATION/
cp -R /etc/php/7.4/apache2/php.ini $DESTINATION/
cd /home/kevftp
cp -R wp_files.sh $DESTINATION/
cp -R wp_bp.sh $DESTINATION/

zip -e -P kevftp -r wp_files_$DATE.zip backups

#Envoyer les fichiers vers serveur de backups
sshpass -p kevftp sftp kevftp@10.0.0.2 << SFTP

cd /opt/ftp
mkdir backups
cd backups
put wp_files_$DATE.zip 
exit
SFTP

#Suppression du repertoire
cd /home/kevftp
rm -rf backups
rm -rf wp_files_$DATE.zip

#crontab
#20 3	* * 1	/home/kevftp/fichiers.sh
