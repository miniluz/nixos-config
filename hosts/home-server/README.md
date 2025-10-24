# home-server documentation

## Assumptions and setup

### Tailscale is functioning

Tailscale should be working correctly. To do this, run
`nix-shell -p tailscale --run "sudo tailscale up"`.

### Server package versioning

The NixOS config is expected to be at `~/nixos-config-base`. The server will
have its own NixOS config at `~/nixos-config` so it can use its own nixpkgs and
nixpkgs-unstable versions that will autoupdate independently.

The configuration at `~/nixos-config-base` will not be auto-updated. It must be
pulled manually to stop breakages from the main config.

### Wireguard

A wireguard config file without a killswitch is provided as a host secret in
`w0conf.age`. The forwarded port should be the same on the VPN and the server,
and needs to be specified to transmission.

### Reverse proxy

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

## Setup

### Actual

Make the account and import. Cannot be configured declaratively. You will need
to update the host `actual-password` and `actual-sync-id` secrets.

### Immich

You will need to open the Immich web interface at `http://localhost:2283` to
complete the setup process. You might need to restart the immich service for it
to actually open.

### Jellyfin

1. Go into Radarr
   - Set up the media folder
   - Set up Transmission as a download client
   - Set up
     [renaming](https://trash-guides.info/Radarr/Radarr-recommended-naming-scheme/)
     (remember to show advanced)
   - Copy its API key to a file and to `recyclarr-keys.age` as `RADARR_API_KEY`.
   - Delete all existing formats except "All"
   - Set up a custom quality profile called HD-Original that includes
     Bluray-1080p, WEB 1080p and Bluray-720p in that order, with upgrades
     disallowed, with the original language selected. Then create another one
     for HD-Spanish, HD-Spanish-Latino and HD-English.
   - Manually start recyclarr
2. Go into Sonarr
   - Set up the media folder
   - Set up Transmission as a download client
   - Set up
     [renaming](https://trash-guides.info/Sonarr/Sonarr-recommended-naming-scheme/)
     (remember to show advanced)
   - Copy its API key to a file and to `recyclarr-keys.age` as `SONARR_API_KEY`.
   - Delete all existing formats except "All"
   - Set up a custom quality profile called HD that includes WEB 1080p,
     Bluray-1080p, HDTV-1080p, WEB 720p, Bluray-720p and HDTV-720p in that
     order, with upgrades disallowed.
3. Start Recyclarr manually
4. Go into Bazarr
   - Enable Sonarr, put in the API key and ensure the score is 90
   - Enable Radarr, put in the API key and ensure the score is 80
   - Add English, Spanish and Spanish (Latino) to the language filer, set up a
     language profile containing all three with no further options, then apply
     it as the default language format for series and movies.
   - Add to providers:
     - YIFY Subtitles
     - Subtitulamos.tv
     - Gestdown
     - Argenteam
     - OpenSubtitles.com (account is in bitwarden)
     - AnimeTosho (With empty AniDB integration (I'm not sure if this works))
     - Subdivx
     - Subf2m (use <https://www.whatsmyua.info/> to get the UserAgent)
     - TVSubtitles
   - On the subtitles page, disable upgrading substitles, enable automatic
     synchronization, and set the minimum score to 96 for series and 86 for
     movies.
5. Podgrab requires no setup other than adding your podcasts
6. Go into Prowlarr and set it up with every ARR with their API keys.
   - Set up every ARR with their API keys. Note that bc Prowlarr is behind the
     VPN, you need to provide the Prowlarr server address as
     `http://192.168.15.1:9696` and Radarr's and Sonarr's as
     `http://192.168.15.5:7878` and `http://192.168.15.5:8989`.
   - Set up Transmission
   - Add the indexers:
     - BitSearch
     - PirateBay
     - RARBG
     - YTS
     - NYA.SI
     - 1337x
     - EliteTorrent
     - MoviesDVDR
     - EBookBay
     - Book and audiobook indexes!
     - Anidex
     - Bangumi Moe
     - Lat-Team (Maybe, it's private)
   - Make them have minimum seeders (maybe 4) and also vibes-prioritize them
7. Go into Jellyfin, set up the account and add the media folders. For
   reference, I used <https://nixos.wiki/wiki/Intel_Graphics> and
   <https://nixos.wiki/wiki/Accelerated_Video_Playback> and
   <https://wiki.archlinux.org/title/Hardware_video_acceleration#Verification>
   for the setup, the last link has the command to see the available formats.
   With the admin account, go into the dashboard, playback, transcoding and
   enable Hardware acceleration with Intel QuickSync, no device, and enabling:
   - H264
   - HEVC
   - MPEG2
   - VP9
   - HEVC 10bit
   - VP9 10bit.
8. Go into Jellyseer and set up the integration with Jellyfin, Sonarr and
   Radarr.
9. Go into Audiobookshelf, set up the account and add the media folder.

## Restoring from a backup

```sh
cat /var/run/agenix/borg-pass # use agenix otherwise to read
cat /var/run/agenix/borg-ssh-ed25519 # but you must decrypt this to a file
# Remember you also have these on BitWarden

BORG_RSH="ssh -i /var/run/agenix/borg-ssh-ed25519" borg list ssh://u489829-sub1@u489829-sub1.your-storagebox.de:23/./home-server-backups/syncthing-miniluz-polar
# Outputs:
# home-server-syncthing-miniluz-polar-2025-09-21T00:00:00 Sun, 2025-09-21 00:00:20 [...]
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ you want this bit

BORG_RSH="ssh -i /var/run/agenix/borg-ssh-ed25519" borg extract ssh://u489829-sub1@u489829-sub1.your-storagebox.de:23/./home-server-backups/syncthing-miniluz-polar::home-server-syncthing-miniluz-polar-2025-09-21T00:00:00
```

## Ports

- Syncthing: `127.0.0.1:8384`, transfer port `0.0.0.0:22000`, discovery port
  `0.0.0.0:21027`.

- Immich: `0.0.0.0:2283`, ML at localhost:3003.
- Actual: `0.0.0.0:9991`.

- Transmission: `0.0.0.0:9091`.

- Jellyfin: `0.0.0.0:8096`.
- Audiobookshelf: `0.0.0.0:9292`.

- Jellyseer: `0.0.0.0:5055`.

- Prowlarr: `0.0.0.0:9696`.
- Flaresolverr: `127.0.0.1:8191`.

- Radarr: `0.0.0.0:7878`.
- Sonarr: `0.0.0.0:8989`.
- Bazarr: `0.0.0.0:6767`
