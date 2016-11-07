 #!/bin/bash
 TIMESTAMP=`date +%d-%m-%y`
 MONGODUMP_PATH="/usr/bin/mongodump"
 PG_DUMP_PATH="/usr/bin/pg_dump"
 MONGO_DATABASE="formhub"
 POSTGRES_DATABASE="backoffice"
 BACKUPS_ORIGIN="/var/www/vhosts/backoffice.storelevel.net"
 BACKUPS_DIR="/var/respaldos"
 BACKUP_NAME="STORELEVEL-$TIMESTAMP"
 tar pczfv $BACKUPS_DIR/$BACKUP_NAME.tar.gz $BACKUPS_ORIGIN/* --exclude logs --exclude env
 $MONGODUMP_PATH -d $MONGO_DATABASE -o $BACKUPS_DIR/$MONGO_DATABASE$TIMESTAMP.json
 $PG_DUMP_PATH -Fp --no-acl --no-owner $POSTGRES_DATABASE > $BACKUPS_DIR/$POSTGRES_DATABASE$TIMESTAMP.sql
 find $BACKUPS_DIR/* -mtime +3 -exec rm -r {} \;
