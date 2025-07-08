# I believe there are a few ways to do this:
#
#    1. My current way, using a minimal /etc/nixos/configuration.nix that just imports my config from my home directory (see it in the gist)
#    2. Symlinking to your own configuration.nix in your home directory (I think I tried and abandoned this and links made relative paths weird)
#    3. My new favourite way: as @clot27 says, you can provide nixos-rebuild with a path to the config, allowing it to be entirely inside your dotfies, with zero bootstrapping of files required.
#       `nixos-rebuild switch -I nixos-config=path/to/configuration.nix`
#    4. If you uses a flake as your primary config, you can specify a path to `configuration.nix` in it and then `nixos-rebuild switch —flake` path/to/directory

# A rebuild script that commits on a successful build
set -e

# cd to your config dir
pushd "$NH_FLAKE"

# Pull latest changes and fail if pull fails
if ! git pull; then
    echo "Failed to pull latest changes, exiting."
    popd
    exit 1
fi

# Edit your config
"${NIX_CONFIG_EDITOR:-${EDITOR:-vi}}" "$NH_FLAKE"

# Early return if no changes were detected (thanks @singiamtel!)
if [ -z "$(git status --porcelain)" ]; then
    echo "No changes detected, exiting."
    popd
    exit 1
fi

# Autoformat your nix files
nixfmt . &>/dev/null \
|| ( nixfmt . ; echo "formatting failed!" && exit 1)

# Shows your changes
git diff -U0

git add .

echo "NixOS Rebuilding..."

# Ask for sudo before anything happens
sudo -v

while true; do
  sudo -v
  sleep 60
done &
KEEP_SUDO_PID=$!

# Rebuild, output simplified errors, log trackebacks
set -o pipefail
if ! (nh os switch 2>&1 | tee "$NH_FLAKE/nixos-switch.log") then
  echo "NixOS Rebuild failed!"
  notify-send -e "NixOS Rebuilt Failed!" --icon=computer-fail-symbolic
  kill $KEEP_SUDO_PID
  exit 1
fi

# Kill sudo loop
kill $KEEP_SUDO_PID

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep True)

# Commit all changes witih the generation metadata
git commit -am "$current"

git push

# Back to where you were
popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available