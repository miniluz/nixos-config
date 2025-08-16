# Assumptions

## Wireguard

A wireguard config file without a killswitch is provided as a host secret in
`w0conf.age`.

## Reverse proxy

An SSL key for the domain names `*.nebula.local` and `nebula.local`. The SSL key
is expected to be an agenix secret in the host-secrets at
`nebula.local.key.age`. The certificate is expected to be unencrypted at the
host-secrets at `nebula.local.crt`. Also, the server must be running through
Tailscale on `100.64.1.1` for DNS to work.

```bash
nix-shell -p openssl --run "openssl genrsa 2048" | agenix -e nebula.local.key.age
nix-shell -p openssl --run "
  agenix -d nebula.local.key.age | \
  openssl req \
    -x509 \
    -new \
    -nodes \
    -days 365 \
    -key /dev/stdin \
    -out nebula.local.crt \
    -subj '/CN=nebula.local' \
    -extensions v3_req \
    -config <(cat <<'EOF'
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = nebula.local

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = nebula.local
DNS.2 = *.nebula.local
EOF
)
"
```

# Setup

## Actual

Make the account and import. Cannot be configured declaratively. You will need
to update the host `actual-password` and `actual-sync-id` secrets.

## Immich

You will need to open the Immich web interface at http://localhost:2283 to
complete the setup process. You might need to restart the immich service for it
to actually open.

## Jellyfin

1. Go into every ARR
1. Set up their media folder.
1. Set up Transmission.
1. Note: Readarr requires more config.
1. Write down their API key.
1. Go into Prowlarr and set it up with every ARR with their API keys.
1. Add into Prowlarr the indexers:

- PirateBay
- RARBG
- YTS
- NYA.SI
- 1337x
- EliteTorrent
- MoviesDVDR
- Book and audiobook indexes!
- Lat-Team (Maybe, it's private)

4. Go into Jellyfin, set up the account and add the media folders.
5. Go into Jellyseer and set up the integration with Jellyfin and the ARRs.
6. Go into Audiobookshelf, set up the account and add the media folder.

### Readarr

Set up the new metadata servers as
<https://github.com/blampe/rreading-glasses?tab=readme-ov-file#usage> says:

Navigate to `http(s)://<your instance>/settings/development`. This page isn't
shown in the UI, so you'll need to manually enter the URL.

Update Metadata Provider Source with `https://hardcover.bookinfo.pro` (or
`https://api.bookinfo.pro`) if you'd like to use the public instance. If you're
self-hosting use your own address.

Click Save.

### Spotizerr

Requires manual setup for your spotify and deezer API keys

# Server data

## Immich

Simple folder structure at /media/server-data/immich. Note that storage template
is OFF.

System Postgres database also needs to be backed up for all the metadata. The
[immich](https://immich.app/docs/administration/backup-and-restore#filesystem)
and [postgres](https://www.postgresql.org/docs/current/backup.html)
documentations should explain how to do it.

# Ports

- Syncthing: `127.0.0.1:8384`, transfer port `0.0.0.0:22000`, discovery port
  `0.0.0.0:21027`.

- Immich: `0.0.0.0:2283`, ML at localhost:3003.
- Actual: `0.0.0.0:9991`.

- Transmission: `0.0.0.0:9091`.

- Jellyfin: `0.0.0.0:8096`.
- Audiobookshelf: `0.0.0.0:9292`.

- Jellyseer: `0.0.0.0:5055`.

- Prowlarr: `0.0.0.0:9696`.

- Radarr: `0.0.0.0:7878`.
- Sonarr: `0.0.0.0:8989`.
- Bazarr: `0.0.0.0:6767`
- Spotizerr: `0.0.0.0:7171`
- Podgrab: `0.0.0.0:4242`

- Readarr: `0.0.0.0:8787`
- Readarr audiobooks: `0.0.0.0:9494`

- Calibre server: `0.0.0.0:9880`
- Calibre web: `0.0.0.0:9881`
