# Borg backups

`backup-borg` has the SSH key, passphrase, and remote path pre-configured.

```bash
# List archives
backup-borg list ssh://u489829-sub1@u489829-sub1.your-storagebox.de:23/./home-server-backups/<backup-name>

# Extract an archive
backup-borg extract ssh://u489829-sub1@u489829-sub1.your-storagebox.de:23/./home-server-backups/<backup-name>::<archive-name>
```

