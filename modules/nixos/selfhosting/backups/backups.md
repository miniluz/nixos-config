# Borg backups

`backup-borg` has the SSH key, passphrase, and remote path pre-configured.

```bash
# List archives
backup-borg list ssh://u489829-sub1@u489829-sub1.your-storagebox.de:23/./home-server-backups/<backup-name>

# Extract an archive
backup-borg extract ssh://u489829-sub1@u489829-sub1.your-storagebox.de:23/./home-server-backups/<backup-name>::<archive-name>
```

## Restoring: Actual

The backup contains `actual.zip` exported via the Actual API. Restore through the web UI.

## Restoring: LibreChat

The backup contains `LibreChat-mongodb.gz` and `vectordb.sql`.

```bash
# Restore MongoDB (--drop deletes all existing data first)
podman exec -i chat-mongodb \
  mongorestore --archive --gzip --drop --db LibreChat < ./LibreChat-mongodb.gz
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ^^^^   DELETES ALL DATA FIRST

# Restore PostgreSQL vectordb
# You can get the envvars from agenix -d librechat-env.age
# 1. Drop the database
podman exec -i vectordb /bin/bash -c \
  'PGPASSWORD=$POSTGRES_PASSWORD psql -U $POSTGRES_USER -d postgres -c "DROP DATABASE $POSTGRES_DB;"'
# 2. Recreate the database
podman exec -i vectordb /bin/bash -c \
  'PGPASSWORD=$POSTGRES_PASSWORD psql -U $POSTGRES_USER -d postgres -c "CREATE DATABASE $POSTGRES_DB;"'
# 3. Import the dump
podman exec -i vectordb /bin/bash -c \
  'PGPASSWORD=$POSTGRES_PASSWORD psql -U $POSTGRES_USER $POSTGRES_DB' < ./vectordb.sql
```

