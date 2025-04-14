#!/bin/bash

if [[ -z "$DB_USER" || -z "$DB_PASSWORD" ]]; then
  echo "❌ Error: DB_USER or DB_PASSWORD is not set."
  exit 1
fi

SOURCE_DB="ShopDB"
FULL_BACKUP_DB="ShopDBReserve"
DATA_ONLY_DB="ShopDBDevelopment"

FULL_BACKUP_FILE="/tmp/full_backup.sql"
DATA_ONLY_FILE="/tmp/data_only_backup.sql"

echo " Creating full backup of $SOURCE_DB..."
mysqldump -u"$DB_USER" -p"$DB_PASSWORD" "$SOURCE_DB" > "$FULL_BACKUP_FILE"

echo " Restoring full backup into $FULL_BACKUP_DB..."
mysql -u"$DB_USER" -p"$DB_PASSWORD" "$FULL_BACKUP_DB" < "$FULL_BACKUP_FILE"

echo " Creating data-only backup of $SOURCE_DB..."
mysqldump -u"$DB_USER" -p"$DB_PASSWORD" --no-create-info "$SOURCE_DB" > "$DATA_ONLY_FILE"

echo " Restoring data-only backup into $DATA_ONLY_DB..."
mysql -u"$DB_USER" -p"$DB_PASSWORD" "$DATA_ONLY_DB" < "$DATA_ONLY_FILE"

echo "✅ Done! Check the records in $FULL_BACKUP_DB and $DATA_ONLY_DB."

