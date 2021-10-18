#!/bin/bash

#Supprime les sauvegardes de plus de 7 jours
find /opt/ftp/backups -name wp_* -mtime +7 -exec rm "{}" \;
