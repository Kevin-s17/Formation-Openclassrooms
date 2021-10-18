#! /bin/bash

#Decompression des archives
for z in *.zip; do unzip "$z"; done
bzip2 -d /home/kevftp/backups/*.bz2
cd backups

#Creation de la BDD
mysql -u root -p << EOF
USE mysql;
CREATE DATABASE wordpress CHARACTER SET UTF8 COLLATE UTF8_BIN;
CREATE USER 'wordpress'@'%' IDENTIFIED BY 'kevin123';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%';
quit;
EOF

#Remplacement des fichiers
mv /home/kevftp/backups/php.ini /etc/php/7.4/apache2
cd /var
rm -rf www
mv /home/kevftp/backups/www /var
cd /var/www/html
rm -rf wordpress
mv /home/kevftp/backups/wordpress /var/www/html
cd /etc
rm -rf apache2
mv /home/kevftp/backups/apache2 /etc
cd /home/kevftp
mv /backups/wp_files.sh /home/kevftp
mv /backups/wp_bp.sh /home/kevftp

service apache2 restart

cd backups
ls

echo "Commande pour importer la BDD: mysql -u wordpress -p wordpress < wp_BDD_XXX.sql" 
